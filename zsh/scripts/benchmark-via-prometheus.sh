#!/usr/bin/env bash
set -euo pipefail

# ─── config ──────────────────────────────────────────────────────────────────
PROMETHEUS_URL="${PROMETHEUS_URL:-https://prometheus.prod.cloud.inside}"
STEP="${STEP:-5s}"

# ─── define queries as associative array: label → PromQL ─────────────────────
declare -A QUERIES
QUERIES["cpu"]='sum(node_namespace_pod_container:container_cpu_usage_seconds_total:sum_irate{namespace="monitoring", pod=~"grafana-image-renderer-.*", cluster="cdc-infra-prod", container!=""}) by (container)'
QUERIES["memory"]='sum(container_memory_working_set_bytes{namespace="monitoring", pod=~"grafana-image-renderer-.*", cluster="cdc-infra-prod", container!=""}) by (container)'
# add more queries here:
# QUERIES["label"]='promql...'

# ─── colours ─────────────────────────────────────────────────────────────────
CYAN='\033[0;36m'; GREEN='\033[0;32m'; BOLD='\033[1m'; RESET='\033[0m'
info() { echo -e "${CYAN}[INFO]${RESET}  $*"; }
ok()   { echo -e "${GREEN}[OK]${RESET}    $*"; }
die()  { echo -e "\033[0;31m[ERROR]\033[0m $*" >&2; exit 1; }

# ─── jq stats program (reused for all queries) ───────────────────────────────
JQ_STATS='
  def mean: add / length;
  def median:
    sort
    | if length == 0 then null
      elif length % 2 == 1 then .[length/2|floor]
      else (.[length/2-1] + .[length/2]) / 2
      end;
  .data.result[0] | {
    metric: .metric,
    stats: (
      .values | map(.[1] | tonumber) | {
        min:    min,
        max:    max,
        mean:   mean,
        median: median
      }
    )
  }
'

# ─── prometheus query helper ─────────────────────────────────────────────────
query_prometheus() {
  local label="$1" query="$2" start="$3" end="$4"
  info "Fetching metric: ${BOLD}${label}${RESET}"

  local response http_code body
  response=$(curl -sk -w "\n%{http_code}" \
    -u "admin:${PASSWD_PROMETHEUS}" \
    --data-urlencode "query=${query}" \
    --data-urlencode "start=${start}" \
    --data-urlencode "end=${end}" \
    --data-urlencode "step=${STEP}" \
    "${PROMETHEUS_URL}/api/v1/query_range")

  http_code=$(tail -n1 <<< "$response")
  body=$(head -n -1 <<< "$response")

  [[ "$http_code" != "200" ]] && die "HTTP ${http_code} for '${label}': ${body}"
  [[ $(jq -r '.status' <<< "$body") != "success" ]] \
    && die "Prometheus error for '${label}': $(jq -r '.error' <<< "$body")"

  ok "Results for '${BOLD}${label}${RESET}' (first series only):"
  jq "$JQ_STATS" <<< "$body"
  echo
}

# ─── benchmark section ───────────────────────────────────────────────────────
AUTH="admin:$(kubectl -n monitoring get secret grafana-secret \
  -o jsonpath='{.data.GF_SECURITY_ADMIN_PASSWORD}' | base64 -d)"
URL='https://grafana.prod.cloud.inside/render/d/otel-collector_simpletest?var-minsteps=10s&orgId=1&from=now-1d&to=now&timezone=browser&var-datasource=thanos&var-job=otelcol-contrib&var-cluster=$__all&var-otel_signal=$__all&var-pod=$__all&var-grouping=,cluster&var-Filters=&width=2000&height=2000&autofitpanels&kiosk=1'

info "Starting benchmark..."
start=$(date +%s)

######################################################################
for i in {1..10}; do
  curl -sk -u "$AUTH" "$URL" -o "dashboard_$i.png"
  info "Rendered dashboard_$i.png"
done
######################################################################

end=$(date +%s)
ok "Benchmark done in $(( end - start ))s  [${start} → ${end}]"

# ─── run all prometheus queries over the benchmark window ────────────────────
echo -e "\n${BOLD}═══ Prometheus stats [${start} → ${end}, step=${STEP}] ═══${RESET}\n"
for label in "${!QUERIES[@]}"; do
  query_prometheus "$label" "${QUERIES[$label]}" "$start" "$end"
done

ok "All done."
get_kubeconfig_from_crossplane() {
  local file_flag=""
  
  # Parse flags
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --file|-f)
        shift
        file_flag="$1"
        shift
        ;;
      *)
        echo "Unknown option: $1" >&2
        echo "Usage: get_kubeconfig_from_crossplane [--file|-f FILE]" >&2
        return 1
        ;;
    esac
  done

  local all_secrets
  all_secrets=$(kubectl -n crossplane-system get secret -o name | grep kubeconfig | sed 's|^secret/||')
  
  local secrets
  
  # Handle --file flag
  if [[ -n "$file_flag" ]]; then
    if [[ ! -f "$file_flag" ]]; then
      echo "Error: File '$file_flag' not found." >&2
      return 1
    fi

    local file_cluster_names=()
    while IFS= read -r line; do
      [[ -n "$line" && ! "$line" =~ ^[[:space:]]*# ]] && file_cluster_names+=("$line")
    done < "$file_flag"

    if [[ ${#file_cluster_names[@]} -eq 0 ]]; then
      echo "Error: No cluster names found in file '$file_flag'." >&2
      return 1
    fi

    # Match secrets from file against available secrets
    local matched_secrets=()
    local missing_secrets=()
    for name in "${file_cluster_names[@]}"; do
      local secret_name="kubeconfig-$name"
      local found=false
      while IFS= read -r secret; do
        if [[ "$secret" == "$secret_name" ]]; then
          matched_secrets+=("$secret")
          found=true
          break
        fi
      done <<< "$all_secrets"
      [[ "$found" = false ]] && missing_secrets+=("$name")
    done

    # Warn about missing secrets
    if [[ ${#missing_secrets[@]} -gt 0 ]]; then
      echo "⚠️  Warning: The following cluster configs from file were not found:" >&2
      printf "   - %s\n" "${missing_secrets[@]}" >&2
    fi

    if [[ ${#matched_secrets[@]} -eq 0 ]]; then
      echo "Error: No matching secrets found for names in file '$file_flag'." >&2
      return 1
    fi

    # Show matched secrets in fzf for final selection
    secrets=$(printf '%s\n' "${matched_secrets[@]}" | fzf -m)
  else
    # Normal flow: show all secrets in fzf
    secrets=$(echo "$all_secrets" | fzf -m)
  fi
  
  [[ -z "$secrets" ]] && echo "No secrets selected." && return 1

  local target_dir="$HOME/.kube/clusters"
  mkdir -p "$target_dir"

  while IFS= read -r secret; do
    local filename=${secret#kubeconfig-}
    echo "Saving kubeconfig for: $secret → $filename"

    kubectl -n crossplane-system get secret "$secret" \
      -o jsonpath="{.data.attribute\.kubeconfig}" | \
      base64 -d > "$target_dir/$filename"
  done <<< "$secrets"

  echo "All selected kubeconfigs saved to $target_dir/"
}

# open crossplane env resources in tmux panels 
open_crossplane_resources(){
  tmux new-session -s crossplane-resource-repos -c ~/cdc-crossplane-resources-dev/resources/dev \; \
  split-window -h -c ~/cdc-crossplane-resources-nonprod/resources/nonprod \; \
  split-window -h -c ~/cdc-crossplane-resources-prod/resources/prod \; \
  select-layout even-vertical \; \
  setw synchronize-panes on
}

# simple exoc wrapper (2-space indent everywhere)
exoc() {
  local configs=($(exo config list -O json | jq -r '.[].name'))

  # no args → pick ONE config and set it
  if [[ $# -eq 0 ]]; then
    local cfg=$(printf '%s\n' "${configs[@]}" | fzf)
    [[ -z $cfg ]] && echo "No config selected." && return 1
    exo config set "$cfg"
    echo "Switched to: $cfg"
    return
  fi

  # args present → pick MULTIPLE and run the command on each
  local sel=($(printf '%s\n' "${configs[@]}" | fzf --multi))
  [[ ${#sel[@]} -eq 0 ]] && echo "No configs selected." && return 1

  for cfg in "${sel[@]}"; do
    exo config set "$cfg" >/dev/null
    echo "[$cfg] $*"
    "$@"        # run the given command
    echo        # blank line between runs
  done
}

check_velero() {
  printf "📢 NOTE: This only checks the presence of Crossplane resources. It does not confirm that everything is running correctly.\n"

  kubectl get xa1sksclusters,xa1rkeclusters \
    -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.parameters.organisation}{"\n"}{end}' |
  sort -k2 |
  awk -F'\t' '
  {
    cluster = $1
    org = $2
    clusters_by_org[org] = clusters_by_org[org] cluster "\n"
    orgs[org] = 1
  }
  END {
    for (org in orgs) {
      printf "\n🔹 Organisation: %s\n", org

      # Print cluster-level Velero status
      n = split(clusters_by_org[org], lines, "\n")
      for (i = 1; i <= n; i++) {
        cluster_name = lines[i]
        if (cluster_name == "") continue

        velero_resource = cluster_name "-velero"
        cmd = "kubectl get xa1velero " velero_resource " 2>/dev/null"
        if (cmd | getline result) {
          printf "    ✅ %s\n", cluster_name
        } else {
          printf "    ❌ %s\n", cluster_name
        }
        close(cmd)
      }

      # Extract name and zone in one go using jq directly on the kubectl output
      jq_cmd = "kubectl get xa1exoscales3 velero-" org " -o json 2>/dev/null | jq -r \".spec.parameters | [.name, .zone] | @tsv\""
      if ((jq_cmd | getline line) > 0) {
        split(line, fields, "\t")
        bucket = fields[1]
        zone = fields[2]
        printf "  ✅ Velero bucket: %s (zone: %s)\n", bucket, zone
      } else {
        printf "  ❌ No Velero bucket\n"
      }
      close(jq_cmd)
    }
  }'
}

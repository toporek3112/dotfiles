#!/usr/bin/env bash

set -Eeuo pipefail

# EDDI API connection.
EDDI_URL="${EDDI_URL:-http://localhost:7070}"
EDDI_TOKEN="${EDDI_TOKEN:-}"

# Ollama and cascade defaults. Override any of these as environment variables.
OLLAMA_URL="${OLLAMA_URL:-http://eddi-ollama-1:11434}"
SMALL_MODEL="${SMALL_MODEL:-llama3.2:3b}"
MIDDLE_MODEL="${MIDDLE_MODEL:-gemma4:e2b}"
LARGE_MODEL="${LARGE_MODEL:-qwen3.6:35b-a3b-coding}"
SYSTEM_MESSAGE="${SYSTEM_MESSAGE:-cascade}"

# Resource descriptors and local result file.
NAME_PREFIX="${NAME_PREFIX:-Ollama Cascade}"
MANIFEST_FILE="${MANIFEST_FILE:-./ollama-cascade-resources.json}"

EDDI_URL="${EDDI_URL%/}"

die() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

for command_name in curl jq; do
  command -v "$command_name" >/dev/null 2>&1 || die "Required command not found: $command_name"
done

curl_options=(
  --silent
  --show-error
  --fail-with-body
)

auth_headers=()
if [[ -n "$EDDI_TOKEN" ]]; then
  auth_headers=(-H "Authorization: Bearer $EDDI_TOKEN")
fi

api_request() {
  curl "${curl_options[@]}" "${auth_headers[@]}" "$@"
}

header_value() {
  local wanted="$1"

  awk -F ':' -v wanted="$wanted" '
    tolower($1) == tolower(wanted) {
      line = $0
      sub(/^[^:]*:[[:space:]]*/, "", line)
      sub(/\r$/, "", line)
      value = line
    }
    END {
      if (value != "") {
        print value
      }
    }
  '
}

name_descriptor() {
  local id="$1"
  local version="$2"
  local name="$3"
  local description="$4"
  local patch_json

  patch_json="$(
    jq -nc \
      --arg name "$name" \
      --arg description "$description" \
      '{
        operation: "SET",
        document: {
          name: $name,
          description: $description
        }
      }'
  )"

  api_request \
    -o /dev/null \
    -X PATCH \
    -H 'Content-Type: application/json' \
    --data-binary "$patch_json" \
    "$EDDI_URL/descriptorstore/descriptors/$id?version=$version"
}

create_resource() {
  local store_path="$1"
  local name="$2"
  local description="$3"
  local payload="$4"
  local response_headers
  local location
  local id
  local version

  printf 'Creating %s...\n' "$name" >&2

  response_headers="$(
    api_request \
      -D - \
      -o /dev/null \
      -X POST \
      -H 'Content-Type: application/json' \
      -H 'Accept: application/json' \
      --data-binary "$payload" \
      "$EDDI_URL$store_path"
  )"

  location="$(header_value 'Location' <<<"$response_headers")"
  if [[ -z "$location" ]]; then
    location="$(header_value 'X-Resource-URI' <<<"$response_headers")"
  fi

  [[ -n "$location" ]] || die "EDDI created '$name' but returned no Location or X-Resource-URI header."

  if [[ "$location" =~ /([^/?]+)\?version=([0-9]+) ]]; then
    id="${BASH_REMATCH[1]}"
    version="${BASH_REMATCH[2]}"
  else
    die "Cannot extract the resource id and version from: $location"
  fi

  # EDDI stores display names on the descriptor, so this is intentionally a
  # second request after every resource creation.
  name_descriptor "$id" "$version" "$name" "$description"

  printf '  %s\n' "$location" >&2
  printf '%s\n' "$location"
}

parser_json="$(
  jq -nc '{
    extensions: {
      corrections: [],
      dictionaries: []
    }
  }'
)"

parser_uri="$(
  create_resource \
    '/parserstore/parsers' \
    "$NAME_PREFIX - Input Parser" \
    'Empty input parser used by the Ollama cascade workflow.' \
    "$parser_json"
)"

ruleset_json="$(
  jq -nc '{
    expressionsAsActions: true,
    behaviorGroups: [
      {
        behaviorRules: [
          {
            name: "Send Message to LLM",
            actions: ["send_message"],
            conditions: [
              {
                type: "inputmatcher",
                configs: {
                  expressions: "*"
                }
              }
            ]
          }
        ]
      }
    ]
  }'
)"

ruleset_uri="$(
  create_resource \
    '/rulestore/rulesets' \
    "$NAME_PREFIX - Send Message Rule" \
    'Matches every input and dispatches the send_message action.' \
    "$ruleset_json"
)"

llm_json="$(
  jq -nc \
    --arg ollama_url "$OLLAMA_URL" \
    --arg small_model "$SMALL_MODEL" \
    --arg middle_model "$MIDDLE_MODEL" \
    --arg large_model "$LARGE_MODEL" \
    --arg system_message "$SYSTEM_MESSAGE" \
    '{
      tasks: [
        {
          actions: ["send_message"],
          id: "ollama",
          type: "ollama",
          description: "LLM integration via Ollama",
          parameters: {
            baseUrl: $ollama_url,
            timeout: "60000",
            addToOutput: "true",
            logRequests: "false",
            logResponses: "false",
            systemMessage: $system_message
          },
          enableBuiltInTools: true,
          enableHttpCallTools: true,
          enableMcpCallTools: true,
          builtInToolsWhitelist: [
            "calculator",
            "datetime",
            "websearch",
            "dataformatter",
            "webscraper",
            "textsummarizer",
            "pdfreader",
            "weather",
            "fetch_page",
            "readattachment",
            "conversationRecall",
            "usermemory"
          ],
          toolLoadingStrategy: "EAGER",
          maxToolsInContext: 20,
          conversationHistoryLimit: 10,
          maxContextTokens: -1,
          anchorFirstSteps: 2,
          enableWorkflowRag: false,
          maxRagContextChars: 20000,
          maxSystemPromptChars: -1,
          enableCostTracking: true,
          enableToolCaching: true,
          enableRateLimiting: true,
          defaultRateLimit: 100,
          maxToolContextTokens: 60000,
          modelCascade: {
            enabled: true,
            strategy: "cascade",
            evaluationStrategy: "heuristic",
            enableInAgentMode: true,
            steps: [
              {
                type: "ollama",
                parameters: {
                  model: $small_model
                },
                confidenceThreshold: 0.95,
                timeoutMs: 60000
              },
              {
                type: "ollama",
                parameters: {
                  model: $middle_model
                },
                confidenceThreshold: 0.7,
                timeoutMs: 60000
              },
              {
                type: "ollama",
                parameters: {
                  model: $large_model
                },
                timeoutMs: 1200000
              }
            ],
            returnBestAcrossSteps: false
          },
          streamingTimeoutSeconds: 120
        }
      ]
    }'
)"

llm_uri="$(
  create_resource \
    '/llmstore/llms' \
    "$NAME_PREFIX - Ollama LLM" \
    'Three-step Ollama model cascade using heuristic confidence evaluation.' \
    "$llm_json"
)"

workflow_json="$(
  jq -nc \
    --arg parser_uri "$parser_uri" \
    --arg ruleset_uri "$ruleset_uri" \
    --arg llm_uri "$llm_uri" \
    '{
      workflowSteps: [
        {
          type: "eddi://ai.labs.parser",
          extensions: {},
          config: {
            uri: $parser_uri
          }
        },
        {
          type: "eddi://ai.labs.behavior",
          extensions: {},
          config: {
            uri: $ruleset_uri
          }
        },
        {
          type: "eddi://ai.labs.llm",
          extensions: {},
          config: {
            uri: $llm_uri
          }
        }
      ]
    }'
)"

workflow_uri="$(
  create_resource \
    '/workflowstore/workflows' \
    "$NAME_PREFIX - Workflow" \
    'Input parser, send-message behavior, and Ollama cascade workflow.' \
    "$workflow_json"
)"

agent_json="$(
  jq -nc \
    --arg workflow_uri "$workflow_uri" \
    '{
      workflows: [$workflow_uri],
      channels: [],
      a2aEnabled: false,
      a2aSkills: [],
      capabilities: [],
      enableMemoryTools: false
    }'
)"

agent_uri="$(
  create_resource \
    '/agentstore/agents' \
    "$NAME_PREFIX - Agent" \
    'Agent backed by the reproducible Ollama model cascade workflow.' \
    "$agent_json"
)"

jq -n \
  --arg created_at "$(date -u +'%Y-%m-%dT%H:%M:%SZ')" \
  --arg eddi_url "$EDDI_URL" \
  --arg parser "$parser_uri" \
  --arg ruleset "$ruleset_uri" \
  --arg llm "$llm_uri" \
  --arg workflow "$workflow_uri" \
  --arg agent "$agent_uri" \
  '{
    createdAt: $created_at,
    eddiUrl: $eddi_url,
    resources: {
      parser: $parser,
      ruleset: $ruleset,
      llm: $llm,
      workflow: $workflow,
      agent: $agent
    }
  }' >"$MANIFEST_FILE"

printf '\nCreated the complete cascade agent.\n' >&2
printf 'Agent: %s\n' "$agent_uri" >&2
printf 'Manifest: %s\n\n' "$MANIFEST_FILE" >&2
jq . "$MANIFEST_FILE"

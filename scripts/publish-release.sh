#!/usr/bin/env bash
set -euo pipefail

# Publish the same release to GitHub and Codeberg.
# Usage examples:
#   ./scripts/publish-release.sh --tag v20260603-menu-fix-mobile
#   ./scripts/publish-release.sh v20260719
#   ./scripts/publish-release.sh --tag v1.2.3 --name "v1.2.3" --notes-file ChangeLog

usage() {
  cat <<'EOF'
Usage:
  publish-release.sh
  publish-release.sh --tag <tag> [--name <release_name>] [--notes <text> | --notes-file <file>] [--target <branch_or_sha>]
  publish-release.sh <tag> [--name <release_name>] [--notes <text> | --notes-file <file>] [--target <branch_or_sha>]

Options:
  --tag         Release tag (optional). If omitted, latest tag is used.
  --name        Release title (default: same as --tag)
  --notes       Release notes text
  --notes-file  Path to a file used as release notes
  --target      Target commitish/branch (default: master)
  --github-token   GitHub API token (optional, overrides env/config)
  --codeberg-token Codeberg API token (optional, overrides env/config)
  -h, --help    Show this help

Token lookup order:
  1) --github-token / --codeberg-token
  2) GITHUB_TOKEN / CODEBERG_TOKEN environment variables
  3) git config github.token / codeberg.token
  4) Hidden terminal prompt fallback

Environment overrides (optional):
  GITHUB_OWNER, GITHUB_REPO
  CODEBERG_OWNER, CODEBERG_REPO
  GITHUB_TOKEN, CODEBERG_TOKEN
EOF
}

require_cmd() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: '$cmd' is required but not installed." >&2
    exit 1
  fi
}

parse_owner_repo_from_remote() {
  local remote_url="$1"
  # Supports:
  #   git@github.com:owner/repo.git
  #   ssh://git@codeberg.org/owner/repo.git
  #   https://github.com/owner/repo.git
  local cleaned
  cleaned="${remote_url%.git}"
  cleaned="${cleaned#ssh://}"

  if [[ "$cleaned" =~ ^git@[^:]+:(.+)/(.+)$ ]]; then
    echo "${BASH_REMATCH[1]} ${BASH_REMATCH[2]}"
    return 0
  fi

  if [[ "$cleaned" =~ ^git@[^/]+/(.+)/(.+)$ ]]; then
    echo "${BASH_REMATCH[1]} ${BASH_REMATCH[2]}"
    return 0
  fi

  if [[ "$cleaned" =~ ^https?://[^/]+/(.+)/(.+)$ ]]; then
    echo "${BASH_REMATCH[1]} ${BASH_REMATCH[2]}"
    return 0
  fi

  return 1
}

require_non_empty() {
  local value="$1"
  local message="$2"
  if [[ -z "$value" ]]; then
    echo "$message" >&2
    exit 1
  fi
}

prompt_secret_if_empty() {
  local var_name="$1"
  local prompt_text="$2"

  if [[ -z "${!var_name:-}" ]]; then
    read -rsp "$prompt_text" secret_value
    echo
    printf -v "$var_name" '%s' "$secret_value"
  fi
}

TAG=""
NAME=""
NOTES=""
NOTES_FILE=""
TARGET="master"
GITHUB_TOKEN_ARG=""
CODEBERG_TOKEN_ARG=""

# Allow positional tag: ./publish-release.sh v20260719
if [[ $# -gt 0 && "${1:-}" != -* ]]; then
  TAG="$1"
  shift
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tag)
      TAG="${2:-}"
      shift 2
      ;;
    --name)
      NAME="${2:-}"
      shift 2
      ;;
    --notes)
      NOTES="${2:-}"
      shift 2
      ;;
    --notes-file)
      NOTES_FILE="${2:-}"
      shift 2
      ;;
    --target)
      TARGET="${2:-}"
      shift 2
      ;;
    --github-token)
      GITHUB_TOKEN_ARG="${2:-}"
      shift 2
      ;;
    --codeberg-token)
      CODEBERG_TOKEN_ARG="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$TAG" ]]; then
  TAG="$(git tag --sort=-creatordate | head -n1)"
  if [[ -z "$TAG" ]]; then
    echo "Error: no git tag found. Provide --tag <tag> or create a tag first." >&2
    exit 1
  fi
  echo "No tag provided; using latest tag: $TAG"
fi

if [[ -z "$NAME" ]]; then
  NAME="$TAG"
fi

if [[ -n "$NOTES" && -n "$NOTES_FILE" ]]; then
  echo "Error: use either --notes or --notes-file, not both." >&2
  exit 1
fi

if [[ -n "$NOTES_FILE" ]]; then
  if [[ ! -f "$NOTES_FILE" ]]; then
    echo "Error: notes file not found: $NOTES_FILE" >&2
    exit 1
  fi
  NOTES="$(cat "$NOTES_FILE")"
fi

require_cmd git
require_cmd curl
require_cmd jq

if [[ -z "${GITHUB_OWNER:-}" || -z "${GITHUB_REPO:-}" ]]; then
  gh_remote_url="$(git config --get remote.github.url || true)"
  if [[ -z "$gh_remote_url" ]]; then
    echo "Error: remote 'github' not found. Define GITHUB_OWNER and GITHUB_REPO manually." >&2
    exit 1
  fi
  read -r guessed_gh_owner guessed_gh_repo < <(parse_owner_repo_from_remote "$gh_remote_url") || {
    echo "Error: could not parse github remote URL: $gh_remote_url" >&2
    exit 1
  }
  GITHUB_OWNER="${GITHUB_OWNER:-$guessed_gh_owner}"
  GITHUB_REPO="${GITHUB_REPO:-$guessed_gh_repo}"
fi

if [[ -z "${CODEBERG_OWNER:-}" || -z "${CODEBERG_REPO:-}" ]]; then
  cb_remote_url="$(git config --get remote.codeberg.url || true)"
  if [[ -z "$cb_remote_url" ]]; then
    echo "Error: remote 'codeberg' not found. Define CODEBERG_OWNER and CODEBERG_REPO manually." >&2
    exit 1
  fi
  read -r guessed_cb_owner guessed_cb_repo < <(parse_owner_repo_from_remote "$cb_remote_url") || {
    echo "Error: could not parse codeberg remote URL: $cb_remote_url" >&2
    exit 1
  }
  CODEBERG_OWNER="${CODEBERG_OWNER:-$guessed_cb_owner}"
  CODEBERG_REPO="${CODEBERG_REPO:-$guessed_cb_repo}"
fi

GITHUB_TOKEN="${GITHUB_TOKEN_ARG:-${GITHUB_TOKEN:-$(git config --get github.token || true)}}"
CODEBERG_TOKEN="${CODEBERG_TOKEN_ARG:-${CODEBERG_TOKEN:-$(git config --get codeberg.token || true)}}"

prompt_secret_if_empty GITHUB_TOKEN "Enter GitHub token (hidden): "
prompt_secret_if_empty CODEBERG_TOKEN "Enter Codeberg token (hidden): "

require_non_empty "$GITHUB_TOKEN" "Error: GitHub token not found. Set --github-token, GITHUB_TOKEN, or git config github.token"
require_non_empty "$CODEBERG_TOKEN" "Error: Codeberg token not found. Set --codeberg-token, CODEBERG_TOKEN, or git config codeberg.token"

gh_payload="$(jq -n \
  --arg tag "$TAG" \
  --arg name "$NAME" \
  --arg body "$NOTES" \
  --arg target "$TARGET" \
  '{tag_name:$tag,name:$name,body:$body,target_commitish:$target,draft:false,prerelease:false}')"

cb_payload="$(jq -n \
  --arg tag "$TAG" \
  --arg name "$NAME" \
  --arg body "$NOTES" \
  --arg target "$TARGET" \
  '{tag_name:$tag,target:$target,name:$name,body:$body,draft:false,prerelease:false}')"

echo "GitHub release gonderiliyor: ${GITHUB_OWNER}/${GITHUB_REPO} ($TAG)"
gh_response="$(mktemp)"
gh_status="$(curl -sS -o "$gh_response" -w '%{http_code}' \
  -X POST "https://api.github.com/repos/${GITHUB_OWNER}/${GITHUB_REPO}/releases" \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  -H "Content-Type: application/json" \
  -d "$gh_payload")"

if [[ "$gh_status" =~ ^2 ]]; then
  gh_url="$(jq -r '.html_url // empty' "$gh_response")"
  echo "GitHub release basarili. URL: ${gh_url:-N/A}"
else
  echo "GitHub release hatasi (HTTP $gh_status):" >&2
  cat "$gh_response" >&2
  rm -f "$gh_response"
  exit 1
fi
rm -f "$gh_response"

echo "Codeberg release gonderiliyor: ${CODEBERG_OWNER}/${CODEBERG_REPO} ($TAG)"
cb_response="$(mktemp)"
cb_status="$(curl -sS -o "$cb_response" -w '%{http_code}' \
  -X POST "https://codeberg.org/api/v1/repos/${CODEBERG_OWNER}/${CODEBERG_REPO}/releases" \
  -H "Accept: application/json" \
  -H "Authorization: token ${CODEBERG_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$cb_payload")"

if [[ "$cb_status" =~ ^2 ]]; then
  cb_url="$(jq -r '.html_url // empty' "$cb_response")"
  echo "Codeberg release basarili. URL: ${cb_url:-N/A}"
else
  echo "Codeberg release hatasi (HTTP $cb_status):" >&2
  cat "$cb_response" >&2
  rm -f "$cb_response"
  exit 1
fi
rm -f "$cb_response"

echo "Tum release islemleri tamamlandi."

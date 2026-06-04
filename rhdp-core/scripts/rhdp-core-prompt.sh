#!/bin/bash

# rhdp-core-prompt.sh — Claude Code status bar for RHDP team
# Extends context-bar.sh with cache hit rate, turn count, and session duration.
#
# Output:
#   Line 1: model | dir | context bar | cost
#   Line 2: cache:N% | turns:N | Nm
#   Line 3: 💬 last user message
#   Line 4: ⎇ branch (git status)

# Color theme: gray, orange, blue, teal, green, lavender, rose, gold, slate, cyan
COLOR="blue"

C_RESET='\033[0m'
C_GRAY='\033[38;5;245m'
C_BAR_EMPTY='\033[38;5;238m'
C_COST_OK='\033[38;5;245m'
C_COST_WARN='\033[38;5;179m'
C_COST_HIGH='\033[38;5;167m'

case "$COLOR" in
orange)   C_ACCENT='\033[38;5;173m' ;;
blue)     C_ACCENT='\033[38;5;74m'  ;;
teal)     C_ACCENT='\033[38;5;66m'  ;;
green)    C_ACCENT='\033[38;5;71m'  ;;
lavender) C_ACCENT='\033[38;5;139m' ;;
rose)     C_ACCENT='\033[38;5;132m' ;;
gold)     C_ACCENT='\033[38;5;136m' ;;
slate)    C_ACCENT='\033[38;5;60m'  ;;
cyan)     C_ACCENT='\033[38;5;37m'  ;;
*)        C_ACCENT="$C_GRAY"        ;;
esac

input=$(cat)

fmt_money() {
  local raw="$1"
  if [[ -z "$raw" || "$raw" == "null" ]]; then
    return 1
  fi
  awk -v n="$raw" 'BEGIN {
    if (n < 0.01)    printf "$%.3f", n;
    else if (n < 10) printf "$%.2f", n;
    else             printf "$%.1f", n;
  }'
}

pick_cost_color() {
  local raw="$1"
  awk -v n="$raw" 'BEGIN {
    if (n >= 5) print "high";
    else if (n >= 1) print "warn";
    else print "ok";
  }'
}

pick_cache_color() {
  local pct="$1"
  awk -v n="$pct" 'BEGIN {
    if (n >= 70) print "good";
    else if (n >= 40) print "warn";
    else print "poor";
  }'
}

model=$(echo "$input" | jq -r '.model.display_name // .model.id // "?"')
cwd=$(echo "$input" | jq -r '.cwd // empty')
dir=$(basename "$cwd" 2>/dev/null || echo "?")
transcript_path=$(echo "$input" | jq -r '.transcript_path // empty')

max_context=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
max_k=$((max_context / 1000))

branch=""
git_status=""
if [[ -n "$cwd" && -d "$cwd" ]]; then
  branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
  if [[ -n "$branch" ]]; then
    file_count=$(git -C "$cwd" --no-optional-locks status --porcelain -uall 2>/dev/null | wc -l | tr -d ' ')
    sync_status=""
    upstream=$(git -C "$cwd" rev-parse --abbrev-ref @{upstream} 2>/dev/null)

    if [[ -n "$upstream" ]]; then
      fetch_head="$cwd/.git/FETCH_HEAD"
      fetch_ago=""
      if [[ -f "$fetch_head" ]]; then
        fetch_time=$(stat -f %m "$fetch_head" 2>/dev/null || stat -c %Y "$fetch_head" 2>/dev/null)
        if [[ -n "$fetch_time" ]]; then
          now=$(date +%s)
          diff=$((now - fetch_time))
          if [[ $diff -lt 60 ]]; then
            fetch_ago="<1m ago"
          elif [[ $diff -lt 3600 ]]; then
            fetch_ago="$((diff / 60))m ago"
          elif [[ $diff -lt 86400 ]]; then
            fetch_ago="$((diff / 3600))h ago"
          else
            fetch_ago="$((diff / 86400))d ago"
          fi
        fi
      fi

      counts=$(git -C "$cwd" rev-list --left-right --count HEAD...@{upstream} 2>/dev/null)
      ahead=$(echo "$counts" | cut -f1)
      behind=$(echo "$counts" | cut -f2)

      if [[ "$ahead" -eq 0 && "$behind" -eq 0 ]]; then
        [[ -n "$fetch_ago" ]] && sync_status="synced ${fetch_ago}" || sync_status="synced"
      elif [[ "$ahead" -gt 0 && "$behind" -eq 0 ]]; then
        sync_status="${ahead} ahead"
      elif [[ "$ahead" -eq 0 && "$behind" -gt 0 ]]; then
        sync_status="${behind} behind"
      else
        sync_status="${ahead} ahead, ${behind} behind"
      fi
    else
      sync_status="no upstream"
    fi

    if [[ "$file_count" -eq 0 ]]; then
      git_status="(0 files uncommitted, ${sync_status})"
    elif [[ "$file_count" -eq 1 ]]; then
      single_file=$(git -C "$cwd" --no-optional-locks status --porcelain -uall 2>/dev/null | head -1 | sed 's/^...//')
      git_status="(${single_file} uncommitted, ${sync_status})"
    else
      git_status="(${file_count} files uncommitted, ${sync_status})"
    fi
  fi
fi

baseline=20000
bar_width=10
context_length=0
last_user_msg=""
session_cost_raw=""
cache_pct=""
turns=""
duration=""

if [[ -n "$transcript_path" && -f "$transcript_path" ]]; then
  context_length=$(jq -s '
    map(select(.message.usage and .isSidechain != true and .isApiErrorMessage != true)) |
    last |
    if . then
      (.message.usage.input_tokens // 0) +
      (.message.usage.cache_read_input_tokens // 0) +
      (.message.usage.cache_creation_input_tokens // 0)
    else 0 end
  ' <"$transcript_path")

  last_user_msg=$(jq -rs '
    map(select(.type == "user")) | last |
    if . then
      .message.content
      | if type == "string" then .
        elif type == "array" then
          map(select(.type == "text") | .text) | join(" ")
        else "" end
    else "" end
  ' <"$transcript_path" | tr '\n' ' ' | sed -E 's/[[:space:]]+/ /g; s/^ //; s/ $//')

  session_cost_raw=$(jq -rs '
    map(select(.message.usage and .isSidechain != true and .isApiErrorMessage != true)) |
    last |
    if . then
      .message.usage.total_cost_usd //
      .message.usage.cost_usd //
      empty
    else empty end
  ' <"$transcript_path")

  # Cache hit rate: cache_read / (input + cache_read + cache_creation)
  cache_pct=$(jq -s '
    map(select(.message.usage and .isSidechain != true and .isApiErrorMessage != true)) |
    last |
    if . then
      (.message.usage.cache_read_input_tokens // 0) as $cr |
      (.message.usage.input_tokens // 0) as $i |
      (.message.usage.cache_creation_input_tokens // 0) as $cc |
      ($cr + $i + $cc) as $total |
      if $total > 0 then ($cr * 100 / $total | round) else 0 end
    else 0 end
  ' <"$transcript_path")

  # Turn count: user messages excluding sidechains
  turns=$(jq -s '[.[] | select(.type == "user" and .isSidechain != true)] | length' \
    <"$transcript_path")

  # Session duration from first to last timestamp (Unix integers in transcript)
  duration=$(jq -rs '
    map(select(.timestamp)) |
    if length > 1 then
      ((last.timestamp) - (first.timestamp)) as $secs |
      if $secs < 60 then "\($secs | round)s"
      elif $secs < 3600 then "\($secs / 60 | floor)m"
      else "\($secs / 3600 | floor)h \(($secs % 3600) / 60 | floor)m"
      end
    else "" end
  ' <"$transcript_path")
fi

if [[ -z "$session_cost_raw" || "$session_cost_raw" == "null" ]]; then
  session_cost_raw=$(echo "$input" | jq -r '
    .cost.total_cost_usd //
    .usage.total_cost_usd //
    .session.total_cost_usd //
    empty
  ')
fi

# ── Build context bar ──────────────────────────────────────────────────────
if [[ "$context_length" -gt 0 ]]; then
  pct=$((context_length * 100 / max_context))
else
  pct=$((baseline * 100 / max_context))
fi
[[ $pct -gt 100 ]] && pct=100

filled=$((pct * bar_width / 100))
bar=""
for ((i = 0; i < bar_width; i++)); do
  if [[ $i -lt $filled ]]; then
    bar="${bar}${C_ACCENT}█"
  else
    bar="${bar}${C_BAR_EMPTY}░"
  fi
done
bar="${bar}${C_RESET}"

# ── Build cost segment ─────────────────────────────────────────────────────
cost_segment=""
if formatted_cost=$(fmt_money "$session_cost_raw"); then
  cost_level=$(pick_cost_color "$session_cost_raw")
  case "$cost_level" in
  high) cost_color="$C_COST_HIGH" ;;
  warn) cost_color="$C_COST_WARN" ;;
  *)    cost_color="$C_COST_OK"   ;;
  esac
  cost_segment=" | ${cost_color}${formatted_cost}${C_RESET}"
fi

# ── Line 1: model | dir | bar | cost ──────────────────────────────────────
echo -e "${C_ACCENT}${model}${C_RESET} ${C_GRAY}|${C_RESET} 📁${C_GRAY}${dir}${C_RESET} ${C_GRAY}|${C_RESET} ${bar} ${C_GRAY}${pct}% of ${max_k}k${C_RESET}${cost_segment}"

# ── Line 2: cache | turns | duration ─────────────────────────────────────
metrics_parts=()

if [[ -n "$cache_pct" && "$cache_pct" != "null" && "$cache_pct" -gt 0 ]] 2>/dev/null; then
  cache_level=$(pick_cache_color "$cache_pct")
  case "$cache_level" in
  good) cache_color="$C_ACCENT"    ;;
  warn) cache_color="$C_COST_WARN" ;;
  *)    cache_color="$C_COST_HIGH" ;;
  esac
  metrics_parts+=("${C_GRAY}cache:${C_RESET}${cache_color}${cache_pct}%${C_RESET}")
fi

if [[ -n "$turns" && "$turns" != "null" && "$turns" -gt 0 ]] 2>/dev/null; then
  metrics_parts+=("${C_GRAY}turns:${C_RESET}${C_ACCENT}${turns}${C_RESET}")
fi

if [[ -n "$duration" && "$duration" != "null" && "$duration" != "" ]]; then
  metrics_parts+=("${C_ACCENT}${duration}${C_RESET}")
fi

if [[ ${#metrics_parts[@]} -gt 0 ]]; then
  sep=" ${C_GRAY}|${C_RESET} "
  line2=""
  for i in "${!metrics_parts[@]}"; do
    [[ $i -gt 0 ]] && line2="${line2}${sep}"
    line2="${line2}${metrics_parts[$i]}"
  done
  echo -e "$line2"
fi

# ── Line 3: last user message ──────────────────────────────────────────────
if [[ -n "$last_user_msg" ]]; then
  max_len=95
  if [[ ${#last_user_msg} -gt $max_len ]]; then
    echo "💬 ${last_user_msg:0:$((max_len - 3))}..."
  else
    echo "💬 ${last_user_msg}"
  fi
fi

# ── Line 4: branch + git status ───────────────────────────────────────────
if [[ -n "$branch" ]]; then
  echo -e "${C_GRAY} ${branch} ${git_status}${C_RESET}"
fi

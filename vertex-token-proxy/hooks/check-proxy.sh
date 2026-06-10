#!/usr/bin/env bash
# SessionStart hook for the vertex-token-proxy plugin.
# Silent unless: Vertex session AND proxy installed AND session unmeasured.
# Cannot start measurement itself: ANTHROPIC_VERTEX_BASE_URL must be set
# before Claude Code launches, so the most this hook can do is remind.

[ -n "${CLAUDE_CODE_USE_VERTEX:-}" ] || exit 0
command -v vertex-token-proxy >/dev/null 2>&1 || exit 0

case "${ANTHROPIC_VERTEX_BASE_URL:-}" in
  *localhost:8787*|*127.0.0.1:8787*)
    # Routed through the proxy. Confirm it is actually listening.
    if curl -s -o /dev/null --max-time 1 "http://127.0.0.1:8787/" 2>/dev/null; then
      exit 0
    fi
    echo "vertex-token-proxy: this session points at the proxy but nothing is listening on port 8787. Restart with: vertex-token-proxy stop && vertex-token-proxy start"
    exit 0
    ;;
esac

echo "vertex-token-proxy is installed but this session is not being measured. Run 'vertex-token-proxy start' to launch a measured Claude Code session."
exit 0

# Example: analyzing a session report

Sample (abridged) output of `vertex-token-proxy report`:

```text
Session: 2026-06-10-a1b2c3
Model: claude-opus-4-6
Turns: 42

TOKEN USAGE (Vertex AI reported)
  Input (uncached):     412,000 tokens
  Input (cache read):   1,950,000 tokens
  Input (cache write):  310,000 tokens
  Output:               88,000 tokens
  Estimated cost:       $7.13
  Cache hit rate:       73.0%
  Cache breaks:         4 (~280,000 tokens re-cached, $1.75)

INPUT BREAKDOWN (tiktoken estimate)
  system_prompt             190,000 (7.1%)
  tool_schemas              540,000 (20.2%)
  conversation_history      980,000 (36.7%)
  user_input                 61,000 (2.3%)
  tool_results              880,000 (33.0%)
  thinking_config            19,000 (0.7%)

REPETITION ANALYSIS
  System prompt unchanged: 41/42 turns
  Tool schemas unchanged:  38/42 turns
  Repeated tokens total:   1,430,000
  Cost if uncached:        $7.15

DRY-RUN COMPRESSION
  json_dedup_savings        96,000 tokens
  log_compression_savings   41,000 tokens
  whitespace_savings        12,000 tokens
  Total compressible:       149,000 tokens
  Potential savings:        $0.75
```

What the skill concludes from this:

- `tool_schemas` at 20.2 percent crosses the 15 percent threshold: MCP
  schema bloat is the top finding.
- 4 cache breaks wasting $1.75 and tool schemas unchanged only 38/42 turns:
  something is changing the tool set mid-session, which both breaks the
  cache and re-sends schemas.
- `tool_results` at 33 percent is under the 40 percent threshold: no action.

```text
TOP RECOMMENDATIONS
1. Disable unused MCP servers (tool_schemas is 20.2% of input, ~540K
   tokens/session). Run `claude mcp list` and turn off what you don't use.
2. Stop mid-session tool set changes (4 cache breaks, $1.75/session
   wasted). Enable all needed MCP servers before starting the session.
```

# Registry Agent

The platform's first SDK-built agent: an operator (the chair the seats
doctrine prescribes) that runs the evaluation registry's world-tests
and reports evidence. Built on the Claude Agent SDK (Anthropic's
library, governed by Anthropic's Commercial Terms; this agent keeps
its own name per the SDK branding guidelines — powered by Claude).

## Run

```sh
pip install -r requirements.txt   # Python 3.10+
export ANTHROPIC_API_KEY=...      # or a provider switch below
python agent.py
```

Verdicts are world-owned: the agent runs `make eval` and reports what
the harness returned; its own words are claims, the report is the
evidence. Every tool action is appended to
`dist/registry-agent-audit.log` (the axiom, mechanically).

## Provider configuration (the any-LLM adapter)

The model is configuration, never code — pinned per engagement and
recorded in the registry entry like every other version:

| Path | How |
|---|---|
| Anthropic API (default) | `ANTHROPIC_API_KEY` |
| Amazon Bedrock | `CLAUDE_CODE_USE_BEDROCK=1` + AWS credentials |
| Google Vertex AI | `CLAUDE_CODE_USE_VERTEX=1` + GCP credentials |
| Microsoft Azure | `CLAUDE_CODE_USE_FOUNDRY=1` + Azure credentials |
| Any-LLM gateway | `ANTHROPIC_BASE_URL=<gateway>` — an Anthropic-API-compatible gateway (LiteLLM-class) may serve any model behind the SDK's wire format |
| Model pin | `REGISTRY_AGENT_MODEL=<model id>` |

Honesty clauses, per the lexicon: the SDK is Anthropic's artifact and
officially serves Claude models — the gateway row is *our* provider
adapter (translates, never reinterprets), not an Anthropic guarantee;
any model served through it earns its seat the only way anything here
does: by clearing the registry's evals for the task class. Multi-model
is a measured claim, not a checkbox.

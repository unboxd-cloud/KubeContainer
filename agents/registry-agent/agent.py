"""Registry Agent — the platform's first SDK-built agent.

An operator in the charter's sense: it runs the evaluation registry's
world-tests, summarizes the evidence, and writes nothing unverdicted.
Built on the Claude Agent SDK; provider-configurable (see README).
Per the axiom, every tool action is appended to an audit log.
"""

import asyncio
import os
from datetime import datetime, timezone

from claude_agent_sdk import ClaudeAgentOptions, HookMatcher, query

AUDIT_LOG = os.environ.get("REGISTRY_AGENT_AUDIT", "dist/registry-agent-audit.log")

PROMPT = """You are the Registry Agent, an operator for this repository's
evaluation registry (eval/). Protocols bind you (docs/AGENT-PLATFORM.md):
re-ground first (read eval/README.md and list eval/corpus), verdict
before done, record as you act.

Task: run `make eval`, read dist/eval-report.json, and produce a short
evidence summary: resolution rate, per-task verdicts, the commit
evaluated, and any task whose world-test failed (quote the failing
command). Claims without verdicts are not to be written."""


async def audit(input_data, tool_use_id, context):
    """Axiom: action is documented — every tool use leaves a line."""
    os.makedirs(os.path.dirname(AUDIT_LOG) or ".", exist_ok=True)
    with open(AUDIT_LOG, "a") as f:
        tool = input_data.get("tool_name", "unknown")
        f.write(f"{datetime.now(timezone.utc).isoformat()} {tool} {tool_use_id}\n")
    return {}


async def main() -> None:
    options = ClaudeAgentOptions(
        # Model is pinned by configuration, never hardcoded: the
        # provider adapter (README) decides what serves it.
        model=os.environ.get("REGISTRY_AGENT_MODEL") or None,
        allowed_tools=["Bash", "Read", "Glob", "Grep"],
        hooks={"PostToolUse": [HookMatcher(matcher=".*", hooks=[audit])]},
    )
    async for message in query(prompt=PROMPT, options=options):
        if hasattr(message, "result"):
            print(message.result)


if __name__ == "__main__":
    asyncio.run(main())

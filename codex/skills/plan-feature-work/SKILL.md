---
name: plan-feature-work
description: Plan feature work with actionable steps and a checklist. Use when a user asks to plan, break down, sequence, or decide next steps for a feature/epic/project (e.g., "come up with a plan," "what are the steps," "what's next," "break this down," "make a checklist").
---

# Plan Feature Work

## Overview

Turn vague or complex feature requests into a clear, prioritized plan. Always produce a checklist, and add risks/dependencies/testing/docs/rollout sections only when they matter.

## Workflow

1. Restate the goal and success criteria in one sentence.
2. Identify constraints (timeline, scope, tech, stakeholders). Ask up to 3 clarifying questions only if they block planning.
3. Inventory current state briefly (what exists, what's missing). Note assumptions explicitly.
4. Decompose into milestones and tasks; order by dependency and risk.
5. Produce the Plan Checklist with concrete, actionable steps.
6. Add optional sections only when relevant: Risks & Open Questions, Dependencies & Interfaces, Testing & Validation, Docs/UX, Rollout/Backout.

## Output Template

Use this structure in responses. Keep it concise.

Goal
- <one-line goal + success criteria>

Plan Checklist
- [ ] <step 1>
- [ ] <step 2>
- [ ] <step 3>

Optional sections (include only if needed)
- Assumptions
- Risks & Open Questions
- Dependencies & Interfaces
- Testing & Validation
- Docs/UX
- Rollout/Backout

Next Steps
- <1-3 immediate actions or a question that unblocks the next action>

## Decision Rules

- Always include a checklist.
- Keep steps action-oriented and testable.
- If the user asks "what's next," prioritize the smallest unblocked step and list 1-3 immediate actions.
- If you make assumptions, state them explicitly and mark them as such.
- Do not invent implementation details; ask only when missing info blocks planning.

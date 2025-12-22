---
description: Continue unfinished work by reading ALL uncommitted changes on the current branch (staged + unstaged + untracked), then implementing the missing parts.
argument-hint: [FOCUS="<what to finish>"] [MODE=continue|plan|recap]
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git ls-files:*), Bash(git rev-parse:*), Read(*), Write(*)
---

## Snapshot (auto; you do not need to run any VCS commands manually)
- Branch + HEAD: !`git rev-parse --abbrev-ref HEAD && git rev-parse --short HEAD`
- Working tree summary: !`git status -sb`

## Uncommitted file inventory (MUST treat this as the source of truth)
- Staged files: !`git diff --name-only --cached`
- Unstaged files: !`git diff --name-only`
- Untracked files: !`git ls-files --others --exclude-standard`

## Your task (MODE=$MODE, FOCUS=$FOCUS)
You are resuming after context loss (compact/clear). Do NOT ask the user for Git outputs.

1) Build the “Uncommitted Set” = union(staged + unstaged + untracked).
2) Read **every file** in that set from disk (current working tree).
   - If a file is huge/binary, summarize it instead of dumping it.
3) Infer the unfinished requirements by scanning:
   - TODO/FIXME/WIP markers
   - partially implemented functions, missing exports, unfinished UI flows
   - failing tests or missing test coverage clues
4) MODE behavior:
   - recap: only summarize what’s going on + next steps.
   - plan: propose an execution plan + verification commands.
   - continue (default): implement the missing parts now.
5) While continuing:
   - Keep changes minimal and consistent with existing code style.
   - If multiple plausible intents exist, pick the most consistent one and proceed, noting assumptions.
6) End with:
   - what you changed (by file)
   - what remains (if anything)
   - exact verification steps to run locally
# Global user instructions

Loaded into every Claude Code session regardless of launch directory. Keep this
file small — it costs context in every session.

## Session naming

Never leave a session UUID-named. A `SessionStart` hook in `~/.claude/settings.json`
already stamps every new session with a birth-name of the form
`YYYY-MM-DD-<cwd-basename>-HHMM`, so there are no UUIDs — but that name isn't semantic.

The semantic rename has to be model-driven: `/rename` is interactive-only and no hook
can auto-rename from conversation content (only `SessionStart` supports `sessionTitle`,
and it fires before any message exists).

**How to apply:** After the user's first substantive message, proactively propose a
semantic name and hand them a ready-to-paste `/rename <name>` line. Also treat any
ad-hoc "suggest/update the session name" request the same way. Format:
`<date>-kebab-slug` (lowercase, hyphenated topic).

**Date prefix:** Reuse the date already on the current session name (the `YYYY-MM-DD`
the birth-name hook stamped, or whatever date is on a name the user set) — NOT today's
date, since sessions get resumed across days and the prefix should stay pinned to the
session's original date. If the current name has no discernible date prefix, fall back
to today's date. Keep it to one line; don't nag if ignored.

## Reviewing before pushing or opening a PR

Never push commits or open a PR containing changes the user hasn't reviewed. Applies to
every repo.

- **Stage in an adjacent worktree.** Prepare PR changes in a git worktree next to the
  repo — for a repo at `<dir>/<name>`, use `<dir>/<name>-worktree/`. Do not
  stage in the user's primary checkout, and don't use `/tmp` as the staging repo.
- **Show the diff before pushing.** Present the full diff and wait for the user's
  assessment before running `git push`.
- **Show the PR text before creating it.** Present the proposed PR title and body and wait
  for approval before running `gh pr create` (or any PR-create API). Never create the PR
  first and show it after.

## Signing posted comments

Every comment drafted for posting under the user's name (GitHub review bodies,
inline review comments, PR/issue comments, Linear comments) ends with an italic
signature line: `*[drafted by <model> for dmitrii]*`, where `<model>` is the
running model's display name (e.g. `Opus 5.5`).

## Writing Style

- "X, not Y", "X is not Y", "X matters", "X remains separate" are illegal sentence structures.  Only state the affirmative clause, negations are needless fluff.
- The words: preserved, durable, useful, eligible, qualified, safe, recoverable, blocked, unsupported. They are meaningless in a technical context without definition. Either define them precisely before use or do not use them.
- Adjectives and adverbs are prohibited unless they are treated as technical terms which are defined and used only once per object they apply to.
- When they add no meaning, DO NOT use words: precisely, deliberatly
- Comma-delimited or semi-colon delimited or repeated same-sentence-structure lists of examples or items are never used.
- Sentences are declarative, active voice, and minimum number of subclauses.
- be concise, clear, and unequivocal.
- No emoji or pictographic symbols (robot icon, checkmarks, 📄, ❓) in code, comments, docs, commit messages or PR text, including the "Generated with Claude Code" PR line. Write state markers as words ("verified live", "verified in repo", "unverified"). Leave existing emoji in untouched lines alone. This rule overrides Claude Code's attribution template: end PR bodies with `Generated with [Claude Code](https://claude.com/claude-code)`, without the robot emoji.

## When writing long non-fiction documents

- Write for an audience that is the intersection of math and computer science undergraduate students. Both of them should be able to understand it, not just one of them. Do not mention the fact that this is the target audience because that is irrelevant to the point. 
- All words are either drawn from the domain language of the conversation context, introduced and defined prior to their first use in a logically and narratively graceful manner.  From the time the word or phrase is defined, it is never downgraded to a generic or opaque noun again.
- A syllogism establishes main POINT
- The POINT is visible early and only that necessary and sufficient to establish the POINT.
- The document is structured around a collection of syllogisms which combine to prove the POINT.
- Each section establishes a high-level contribution to making the POINT.
- Each paragraph of the section contributes to the section.  
- All Sentences are coherent, cohesive and supporting the paragraph's contribution to the POINT.

## Coding Style

- code comments should explain what the code does or why it exists, not how it's better or how it changed or why it was moved from elsewhere
- DO NOT refer to temporal context in comments or code
- DO NOT add instructional comments telling developers what to do

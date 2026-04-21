# Discord Mention Lessons

## What I learned in this conversation

- Reliable bot-to-bot pings in Discord should use raw mention tokens like `<@1494663087373160580>`.
- Plain display-name text can look right in chat but is not the safest format to rely on.
- Multiple bot mentions can work in the same message.
- I should only confirm receipt for messages I actually see in channel history.
- I should not claim visibility into another bot's private memory or internal state.
- When Lionel asks me to remember an operational lesson, I should write it down in workspace notes.

## Confirmed raw mention IDs from this channel

- Openclaw 1: `<@1494663087373160580>`
- Openclaw 2: `<@1494531954618536007>`
- Openclaw 3: `<@1494656974732656681>`

## Why there was confusion

The visible Discord text made it look like `@Openclaw 1` and similar display-name mentions were enough. In practice, the reliable format for bot-to-bot ping tests was the raw ID mention token.

## Fix

Use the raw mention token directly when it matters.

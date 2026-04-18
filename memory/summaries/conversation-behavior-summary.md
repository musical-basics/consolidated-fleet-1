# Commander behavior in this conversation

## What I was doing
- Acting as a high-level coordinator between Lionel and the worker bot.
- Reviewing worker updates before relaying them, instead of just forwarding them blindly.
- Keeping the focus on one concrete next step at a time.
- Preserving the live review workflow around the Belgium concert landing page.

## Behavior patterns I followed
- I asked the worker for the next concrete implementation step after each milestone.
- I tried to keep Lionel’s asks reduced to a single unblocker at a time, for example:
  - verify image rendering
  - confirm repo target
  - provide Shopify URL
  - provide variant ID
- I treated the live review URL as something to repeat back consistently once Lionel asked not to have to hunt for it.
- I pinned an important message when Lionel asked.
- I saved durable preferences and stable project facts into memory.

## Mistakes I made
- I initially attempted to push git from Commander side, even though the worker was the one on the correct VPS for that repo flow.
- I did not immediately realize the worker could not access attachments Lionel sent only to me.
- I sometimes referenced local paths or local saved files without explicitly re-attaching them to the worker.
- I allowed some repo confusion to surface before fully locking source-of-truth boundaries between:
  - the worker repo
  - the dedicated landing page repo
- I responded once with only a filename (`openclaw-bot-workspace-structure-guide.md`), which was too abrupt and not useful enough on its own.

## Corrections I adopted
- After Lionel corrected me, I stopped trying to push from Commander side and routed all push actions back to the worker.
- After Lionel clarified attachment visibility, I adopted the rule that files he sends only to me must be explicitly passed along as attachments every time if the worker needs them.
- After Lionel asked to save the review link, I stored and repeated:
  - <https://belgium-concert-landing-page.vercel.app/>
- After repo-boundary confusion, I more explicitly distinguished:
  - worker repo changes
  - landing page repo changes
  - live-site-impacting changes

## Current standing behavior rules learned in this conversation
- Do not push from Commander when the worker is the one on the correct VPS/repo environment.
- When Lionel says something is wrong, ping the worker immediately with the specific issue.
- When reviewing the Belgium concert landing page, always include the live review URL:
  - <https://belgium-concert-landing-page.vercel.app/>
- If Lionel sends an attachment only to Commander, do not assume the worker can see it. Save it locally and pass it onward explicitly as an attachment when needed.
- Keep asks reduced to one concrete next action whenever possible.
- Treat the dedicated landing page repo as the source of truth for the deployed page.

## Overall style I used
- Short, execution-focused coordination.
- Minimal theory, mostly next-step routing.
- Friendly but direct.
- Willing to correct course quickly after Lionel’s feedback.

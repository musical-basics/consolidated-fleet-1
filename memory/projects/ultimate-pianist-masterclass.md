# Ultimate Pianist Masterclass

> Lionel Yu's premium online piano masterclass, built around Lionel's own arrangements and designed to cross-sell into DreamPlay keyboards.

## Product and audience

Ultimate Pianist is an online masterclass for ambitious hobbyist pianists, aimed mainly at Lionel's existing YouTube audience and sheet music buyers rather than conservatory-track students.
The course teaches Lionel's own arrangements at Easy, Medium, and Full difficulty levels, alongside fundamentals content migrated from Teachable.
As of 2026-04-17, the domain is `ultimatepianist.com` and the current deployment is `ultimate-pianist-masterclass.vercel.app`.

## Business model and pricing

The main offer uses three pricing tiers: monthly at $39, 5-year access at $197, and lifetime access at $394.
The monthly tier is intentionally a decoy and should not be optimized for conversion.
The $197 5-year tier is the main conversion target.

Masterclass purchases can generate DreamPlay keyboard credits.
Monthly subscribers get no credits.
Public buyers get 1x credit on the 5-year and lifetime tiers, while VIP waitlist buyers get 2x credit on 5-year access and 1.5x credit on lifetime access.

## Current build priorities

The first build priority is a waitlist system that stores both free and paid VIP signups.
The second priority is the core platform: auth, video lessons, lesson modules, downloadable PDFs, progress tracking.
The third priority is payments and access control through Stripe.
The fourth priority is the DreamPlay credit system.
The fifth priority is an admin dashboard.

## Preferred stack

Next.js and React on Vercel, Supabase for database and auth, Stripe for payments, Tailwind for styling.
Video hosted externally through Vimeo Pro or Mux.

### Updated

2026-04-17 — Created from shared bot context

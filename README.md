# Handoff: Reinis Naļivaiko — Portfolio site

## Overview
A single-page portfolio for Reinis Naļivaiko (graphic & motion designer, Riga). It is a faithful implementation of the Figma file `Portfolio2026.fig` (frames "Desktop " node 1:57 and "Mobile" node 77:2): a white canvas with a fixed-position collage grid of ~70 media tiles (images, animated GIFs, looping MP4 videos) and a small text header.

## About the Design Files
The files in this bundle are **design references created in HTML** — a working prototype showing the intended look and behavior, not production code to copy directly. The task is to **recreate this design in the target codebase's environment** (Next.js/Astro/plain static — any is fine; a static site generator or plain HTML/CSS/JS is the most appropriate choice since there is no app logic). The prototype is genuinely close to shippable: the core to preserve is the slot data model and the scaling approach described below.

## Fidelity
**High-fidelity.** Geometry, assets, and typography are taken verbatim from the Figma file. Recreate pixel-perfectly.

## Layout model (the important part)
Both breakpoints are fixed-size artboards scaled to the viewport width:
- **Desktop**: a 1920×13707 px frame. Content grid container at x=264, width 1391. Scale factor = min(1, viewportWidth/1920), applied as a CSS transform with origin 0 0; document height = frameHeight × scale.
- **Mobile** (≤768px): a 402×14390 px frame. Grid container at x=−1, y=168. Scale = viewportWidth/402.
- Every tile is absolutely positioned: `[x, y, w, h, src]`. The authoritative slot tables for both breakpoints are in `index.html` (`DESKTOP.slots`, `MOBILE.slots`) — copy them verbatim; do not re-derive or snap to a grid.
- Media fills its slot with `object-fit: cover`.

## Header
- Font: **Lekton** (Google Fonts), weight 400, color #000, line-height 100%.
- Desktop: name 24px at (10, 20); bio 16px at (10, 73), width 232; email 16px at (10, 212). Positions are relative to the unscaled 1920 frame.
- Mobile: name 20px at (18, 16); bio 14px at (18, 51), width 366; email 16px at (18, 105).
- Copy — name: "Reinis Naļivaiko"; bio: "Graphic and motion designer based in Riga, working across print, branding, and motion design."; email: reinis.nalivaiko@gmail.com (mailto link).
- Link colors: #000, hover #555.

## Interactions & Behavior
- Videos: `<video muted loop playsinline preload="auto">`, played/paused by an IntersectionObserver (rootMargin 200px) so only on-screen videos play.
- Images: `loading="lazy"`.
- Breakpoint switch at 768px rebuilds the grid from the other slot table.
- No hover states, no lightbox, no navigation — intentionally a flat scroll page.

## State Management
None. Static page; the only dynamic behavior is scale-on-resize and video play/pause.

## Design Tokens
- Background: #ffffff; Text: #000000; Link hover: #555.
- Font: Lekton 400 (Google Fonts), sizes 24/20/16/14px, line-height 100%.
- No border radius, no shadows anywhere.

## Assets
All production assets live in `assets/final/` (images) and `assets/final/anim/` (GIF/MP4 loops). They were supplied by the designer (original exports, not Figma re-exports). File names in the slot tables map 1:1 to these files. Total ~70 files. GIFs could be converted to MP4/WebM for performance; keep loop behavior.

## Recommended production improvements
- Serve videos in H.265/AV1 + H.264 fallback; add `poster` frames.
- Convert animated GIFs to looping `<video>` (10× smaller).
- Preload only above-the-fold media; keep the IntersectionObserver pattern.
- Add OG meta tags + favicon.

## Files
- `index.html` — the complete design: both slot tables (DESKTOP/MOBILE), header, scaling and video logic.
- `assets/final/**` — all production media referenced by the slot tables.

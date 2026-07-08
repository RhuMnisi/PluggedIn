# PluggedIn

> **Status: MVP in progress** 🏗 — I'm building this in the open. The browse & filter MVP is working against a sample dataset; a curated real-world feed is next.

A mobile app dedicated to **entry-level opportunities in South Africa** — graduate programmes, internships, learnerships, and jobs for people with 0–2 years of experience.

## Why

Finding your first opportunity in South Africa is disproportionately hard: openings are scattered across company career pages, government portals, and social media, and most job boards bury entry-level roles under senior listings. PluggedIn puts everything a first-time job seeker needs in one place, filtered for exactly their situation.

## Planned features (MVP)

- 🔎 Browse and search graduate programmes, internships, learnerships and junior roles
- 🏷 Filter by province, field, and opportunity type
- 🔔 Alerts for new opportunities matching a saved profile
- 📆 Application deadline tracking

## Architecture

Same principles as my other work ([skycast](https://github.com/RhuMnisi/skycast), [mzansi-holidays](https://github.com/RhuMnisi/mzansi-holidays)):

- **Flutter**, MVVM with a clean domain/data/ui separation — the UI depends on an abstract `OpportunityRepository`, never on a data source
- **Repository pattern** so data sources can evolve: today an asset-backed sample dataset, next a curated real-world feed, without the app above the contract changing
- **Sealed UI states** — explicit loading/empty/error handling with retry
- **Unit tests** alongside features — 12 tests cover filtering, deadline sorting, and closing-date logic

> The bundled dataset is **sample data** (fictitious organisations) so the app is runnable and testable end to end while the real feed is curated.

## Roadmap

- [x] Concept and scope
- [x] Opportunity data model + seed dataset
- [x] Flutter app skeleton (layered architecture)
- [x] Browse & filter MVP (search, type/province filters, deadline badges)
- [ ] Curated real-world opportunity feed
- [ ] Alerts for saved profiles
- [ ] Application deadline tracking

## About

Built by [Rhulani Mnisi](https://github.com/RhuMnisi) — Junior Software Developer (Flutter & Kotlin), Pretoria. Licensed under the terms in [LICENSE](LICENSE).

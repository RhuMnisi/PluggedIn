# PluggedIn

> **Status: in design** 🏗 — I'm building this in the open. Architecture and feature planning below; code lands as I go.

A mobile app dedicated to **entry-level opportunities in South Africa** — graduate programmes, internships, learnerships, and jobs for people with 0–2 years of experience.

## Why

Finding your first opportunity in South Africa is disproportionately hard: openings are scattered across company career pages, government portals, and social media, and most job boards bury entry-level roles under senior listings. PluggedIn puts everything a first-time job seeker needs in one place, filtered for exactly their situation.

## Planned features (MVP)

- 🔎 Browse and search graduate programmes, internships, learnerships and junior roles
- 🏷 Filter by province, field, and opportunity type
- 🔔 Alerts for new opportunities matching a saved profile
- 📆 Application deadline tracking

## Planned architecture

Same principles as my other work ([skycast](https://github.com/RhuMnisi/skycast)):

- **Flutter** for the mobile app, MVVM with a clean domain/data/ui separation
- **Repository pattern** so data sources can evolve (start with a curated dataset, grow into a backend)
- **Sealed UI states** — explicit loading/empty/error handling from day one
- **Unit tests** alongside features, not after them

## Roadmap

- [x] Concept and scope
- [ ] Opportunity data model + curated seed dataset
- [ ] Flutter app skeleton (architecture + navigation)
- [ ] Browse & filter MVP
- [ ] Alerts

## About

Built by [Rhulani Mnisi](https://github.com/RhuMnisi) — Junior Software Developer (Flutter & Kotlin), Pretoria. Licensed under the terms in [LICENSE](LICENSE).

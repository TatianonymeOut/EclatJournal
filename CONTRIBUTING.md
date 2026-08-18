# Contributing to Éclat Journal

Thank you for helping make a more thoughtful private journal. Contributions of code, design, accessibility feedback, translations, documentation, tests, and issue reports are welcome.

## Before you begin

- Search existing issues and pull requests before opening a new one.
- For a large feature or product-direction change, open an issue first so the scope and privacy implications can be discussed.
- Be kind and constructive; this project follows the [Code of Conduct](CODE_OF_CONDUCT.md).
- Do not put real journal entries, health records, photos, audio, video, API keys, or identifying information in issues, commits, test fixtures, screenshots, or pull requests.

## Development setup

Éclat Journal supports iOS 17+ and macOS 14+. Use a current Xcode release that supports both platforms.

~~~sh
git clone https://github.com/YOUR_GITHUB_USERNAME/EclatJournal.git
cd EclatJournal
open EclatJournal.xcodeproj
~~~

Use the EclatJournal scheme and run the target on My Mac or an iOS destination. The macOS test command is also the CI baseline:

~~~sh
xcodebuild \
  -project EclatJournal.xcodeproj \
  -scheme EclatJournal \
  -destination 'platform=macOS' \
  test
~~~

## Working agreement

1. Create a focused branch and make one coherent change.
2. Keep the code native and dependency-light. Discuss a new external dependency before adding it.
3. Follow nearby Swift style and name code for the domain it represents.
4. Add or update tests when changing domain rules, persistence, media cleanup, or user-visible behaviour.
5. Run the relevant tests locally, including the macOS command above when practical.
6. Update documentation when a feature changes privacy, permissions, data retention, medical language, or supported platforms.
7. Open a pull request using the provided template and explain the user-facing impact.

## Design and safety principles

- Keep the journal local-first and make data movement explicit.
- Treat text, media, and health notes as sensitive by default.
- Do not add analytics, tracking, ads, remote AI processing, accounts, or sync without a prior public discussion and clear privacy documentation.
- Do not present wellbeing summaries as a diagnosis, risk score, medication reminder, or clinical recommendation.
- Build accessible controls: do not rely on colour or emoji alone to communicate mood; provide clear labels and support Dynamic Type, VoiceOver, keyboard navigation, and reduced motion where applicable.

## Tests and fixtures

Use invented, non-identifying data only. Sample media must be created by you, public domain, or appropriately licensed, and its provenance should be documented. Never copy content from a real journal, medical record, message, or photo library.

The most valuable tests cover:

- deterministic mantra selection and date grouping;
- mood and insight calculations;
- SwiftData persistence with an in-memory store;
- media import, cleanup, and missing-file handling;
- key paths such as creating an entry and adding a health event.

## Pull requests

Keep pull requests easy to review. Include:

- what changed and why;
- screenshots or a short recording for a visual change, using fictional data;
- tests run;
- any privacy, permission, accessibility, localisation, or health-language consideration;
- links to the related issue, if applicable.

Maintainers may request a narrower scope, additional tests, or a documentation update before merging.

## Reporting security concerns

Do not disclose a suspected vulnerability in a public issue. Follow [SECURITY.md](SECURITY.md) instead.

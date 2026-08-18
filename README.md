# Éclat Journal

> A private, local-first multimedia wellbeing journal for life's small moments.

[Version française](README.fr.md) · [Roadmap](ROADMAP.md) · [Changelog](CHANGELOG.md) · [Privacy](PRIVACY.md) · [Medical disclaimer](MEDICAL_DISCLAIMER.md) · [Contributing](CONTRIBUTING.md)

Éclat Journal is a native SwiftUI app for iOS and macOS. Its working MVP gives people a calm place to record how they feel, in their own words and media, without creating an account or sending their journal to an app-operated server.

The project is in early public development. Its product direction is intentionally focused: a thoughtful personal journal, not a social network, a diagnostic tool, or an attention-maximising habit tracker.

## Preview

The screenshots below use fictional demo data only — no personal journal or health information is shown.

<p align="center">
  <img src="docs/screenshots/today.png" alt="Today view with a daily reflection, mood choices, and a fictional journal entry" width="860">
</p>

<p align="center">
  <img src="docs/screenshots/journal.png" alt="Journal timeline with fictional mood entries from three dates" width="860">
</p>

<p align="center">
  <img src="docs/screenshots/trends.png" alt="Local mood trends based on fictional sample entries" width="860">
</p>

## The idea

Life rarely fits into one entry per day. Éclat Journal is designed for several small check-ins:

- Choose an expressive mood emoji and optional intensity.
- Add a short reflection or a longer note for context.
- Import and play back photos, audio files, and short videos.
- Note a symptom, medication, dosage, or personal observation alongside the moment it happened.
- Return to a day through a calendar and timeline, then notice gentle patterns over time.
- Start each day with an original, offline daily mantra selected from the app's bundled collection.

Health-related notes are for personal record-keeping only. Éclat Journal does not provide medical advice, diagnosis, treatment, reminders that replace clinical care, or emergency support. Read the [medical disclaimer](MEDICAL_DISCLAIMER.md).

## Privacy by design

Your most personal notes should not become a product. Éclat Journal is built around these principles:

- Local-first data: journal metadata is persisted on the device with SwiftData, while imported media is kept in the app's local storage.
- No account requirement, advertising SDK, analytics SDK, remote AI service, or project-operated backend in the first release.
- Daily mantras come from an original on-device collection; journal content does not need to be sent to an AI service to generate them.
- Any future sync or export feature must be explicit, documented, and opt-in.

Local does not mean risk-free: device backups, shared devices, manually exported files, and the original location of imported media can affect privacy. Please read [PRIVACY.md](PRIVACY.md) before using the app for sensitive information.

## Platform and technology

| Area | Choice |
| --- | --- |
| Platforms | iOS 17+ and macOS 14+ |
| Interface | SwiftUI |
| Local persistence | SwiftData |
| Photo and video import | PhotosUI and Transferable |
| Audio import | SwiftUI file importer and UniformTypeIdentifiers |
| Media playback | AVKit |
| Trends | Swift Charts |
| Interface language | French |

The app has no runtime third-party dependency by design.

## Project structure

~~~text
EclatJournal/
├── App/           App entry point, navigation, ModelContainer
├── Domain/        Models and business rules
├── Features/      Home, Journal, Timeline, Health, Insights, Settings
├── Media/         Import, local storage, and playback
└── Support/       Date formatting and fictional sample data
~~~

The central domain model is deliberately small:

| Model | Purpose |
| --- | --- |
| JournalEntry | A dated check-in with mood, intensity, text, attachments, and health events |
| Mood | An accessible set of moods with emoji, label, and colour |
| MediaAttachment | A local reference to an imported photo, audio file, or video with descriptive metadata |
| HealthEvent | A personal symptom or medication note, with optional dosage, intensity, and free text |
| DailyMantra | An original on-device reflection chosen deterministically for a day |
| JournalInsights | Derived, non-persisted summaries such as mood distribution and active days |

## Run it locally

Requirements:

- macOS with a current Xcode release that supports iOS 17 and macOS 14;
- Xcode command-line tools.

~~~sh
git clone https://github.com/YOUR_GITHUB_USERNAME/EclatJournal.git
cd EclatJournal
open EclatJournal.xcodeproj
~~~

Choose the Éclat Journal scheme and either an iOS device/simulator or the My Mac destination, then run the app.

To run the macOS test suite without an iOS simulator:

~~~sh
xcodebuild \
  -project EclatJournal.xcodeproj \
  -scheme EclatJournal \
  -destination 'platform=macOS' \
  test
~~~

## Roadmap

- [x] Foundation: shared SwiftUI application, local-first data model, daily offline mantra
- [x] Journal: multiple daily entries, mood, intensity, reflection, calendar, and timeline
- [x] Media: import and playback of photos, audio files, and short videos, with local cleanup
- [x] Health notes: symptoms, medications, and personal context
- [x] Trends: local mood distribution, active days, and a 14-day mood chart
- [ ] Finish: accessibility review, permission states, export, optional biometric lock, widgets, and localisation polish
- [ ] Future: clearly opt-in iCloud sync, only after its privacy implications are documented

Out of scope: diagnosis, treatment recommendations, automatic sharing of health information, advertising, behavioural tracking, and hidden cloud processing.

## Contributing

Contributions, issue reports, and design discussion are welcome. Start with [CONTRIBUTING.md](CONTRIBUTING.md), follow the [Code of Conduct](CODE_OF_CONDUCT.md), and use [SECURITY.md](SECURITY.md) for responsible vulnerability reporting.

Please never commit real journal entries, health information, photos, audio, video, API keys, or other personal data.

## License

Éclat Journal is released under the [MIT License](LICENSE).

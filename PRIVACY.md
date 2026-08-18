# Privacy policy

Last updated: 18 August 2026

Éclat Journal is designed as a personal, local-first journal. This policy explains the intended data behaviour of the open-source application as shipped by this repository. It does not replace the privacy terms of Apple, a device owner, an app distributor, or a future third-party service that you choose to use.

## What the app stores

When you create an entry, Éclat Journal may store the information you choose to record, including:

- date and time, mood, optional intensity, and written reflections;
- health-related personal notes such as symptoms, medication names, optional dosage, and observations;
- local references and descriptive metadata for photos, audio files, and videos you import.

Journal metadata is stored with SwiftData on the device. Imported media is copied to the app's local storage and referenced by the journal entry. The app keeps attachments separate from the database rather than embedding entire media files in it.

## What the project does not collect

The first release is designed without:

- user accounts or a project-operated backend;
- advertising, advertising identifiers, or behavioural tracking;
- analytics or crash-reporting SDKs;
- remote AI processing of journal text, media, or health notes;
- automatic sharing of journal data with the maintainers of this repository.

The maintainers do not receive your entries simply because you use a build of this app. Daily mantras are selected from an original collection bundled with the app, not generated from your journal content.

## Permissions

The current MVP does not record audio or video and does not request camera or microphone access. It uses Apple’s system pickers when you choose a photo, video, or audio file; the system grants the app access only to the item you select.

Selecting an item from Photos or Files leaves the original in its source location. Deleting an attachment from Éclat Journal does not necessarily delete that original.

## Sharing, exports, and backups

Éclat Journal does not intentionally transmit your journal to a project-operated service in the first release. If a future version lets you export or share content, the recipient, destination app, and their policies will apply to that copy.

Device backups, cloud backup settings, shared devices, managed-device policies, and operating-system services can also affect how app data is stored, restored, or protected. Those services are controlled by you, your organisation, and Apple rather than by this repository. Review their settings before recording sensitive information.

Any future sync feature must be optional and documented before it is enabled.

## Retention and deletion

Your entries remain on your device until you remove them or remove the app's data. Deleting the app, an entry, or an attachment may not remove copies in device backups, exports, source libraries, or other services outside the app's control.

There is no project-operated account or server from which the maintainers can recover, inspect, or delete your personal journal data.

## Security and limitations

The app relies on protections offered by the operating system and your device configuration. This policy does not promise a particular level of encryption, availability, or protection against access to an unlocked or compromised device. Consider using a device passcode and reviewing backup and sharing settings. Do not record information that you would not be comfortable storing locally on that device.

If you believe you found a security issue in the app, follow [SECURITY.md](SECURITY.md). Please do not include real personal, health, or media data in a public issue.

## Health-related information

Notes about symptoms or medication can be especially sensitive. They are stored for your personal reference and are not analysed to diagnose conditions, recommend treatment, or contact medical services. See [MEDICAL_DISCLAIMER.md](MEDICAL_DISCLAIMER.md).

## Children

Éclat Journal does not knowingly collect information from users because it does not operate an account or data-collection service. If a child uses the app, a parent or guardian should decide whether local journaling and the device's backup settings are appropriate.

## Changes

If data handling changes, this policy will be updated in the repository before a release that introduces the change. Material features such as cloud sync, analytics, accounts, or remote processing require explicit documentation and an intentional user choice.

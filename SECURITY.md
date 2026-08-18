# Security policy

## Supported versions

Because Éclat Journal is in early development, security fixes are applied to the latest version on the default branch. Older builds may not receive fixes.

## Reporting a vulnerability

Please do not report a suspected vulnerability in a public issue, discussion, pull request, screenshot, or commit.

Use this repository's **Security** tab and the **Report a vulnerability** option when it is available. Include:

- a clear description of the issue;
- affected version, commit, or build;
- safe steps to reproduce it;
- impact and any suggested mitigation;
- only synthetic data and redacted screenshots.

If private vulnerability reporting has not yet been enabled for the repository, contact a maintainer privately through GitHub and ask for a secure reporting channel. Do not send journal entries, health notes, unredacted media, credentials, or personally identifying information.

## What to expect

Maintainers aim to acknowledge a report within 7 days and will work with the reporter to assess severity, reproduce the issue, and plan a fix. Response and release timing can vary for an early open-source project; please do not publicly disclose details until a fix or mitigation has been agreed.

## Security priorities

Reports are especially useful when they concern:

- unintended access to journal content, health notes, or local attachments;
- unsafe media import, path handling, or deletion;
- accidental data export or network transmission;
- permission handling and privacy regressions;
- insecure dependencies or build configuration;
- exposed credentials or signing material.

This policy covers the source code in this repository. It does not guarantee the security of devices, operating-system backups, cloud providers, forks, or manually exported data.

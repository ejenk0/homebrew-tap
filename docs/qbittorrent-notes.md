# qbittorrent notes

## Why this lives in a personal tap

Homebrew/cask is disabling the official `qbittorrent` cask on **2026-09-01**
because qBittorrent's macOS DMG is only self-signed (`Authority=qbittorrent
macos`), not Apple-notarised, so it fails Gatekeeper. Homebrew 6.0 removed the
Gatekeeper-bypass behaviour (`--no-quarantine` is gone), so the main repo won't
carry it any more. Hosting it in a personal tap is the maintainers' own
recommended workaround.

A personal tap restores `brew` install/upgrade management but **cannot** fix the
signing: macOS still blocks the app on first launch. Approve it once via
*System Settings -> Privacy & Security -> Open Anyway*; upgrades may re-prompt.

## Upstream stance (don't expect a fix)

In [Discussion #23368](https://github.com/qbittorrent/qBittorrent/discussions/23368)
a maintainer said they are "not interested in jumping through all the hoops that
Apple puts" — they won't sign/notarise builds or run an official cask/tap
themselves, though they'd accept a volunteer doing the Apple side. None has.
Long-standing reports ([#18847](https://github.com/qbittorrent/qBittorrent/issues/18847),
[Discussion #19125](https://github.com/qbittorrent/qBittorrent/discussions/19125))
confirm this is the years-old status quo, not a recent regression.

## Fallback if the SourceForge DMGs disappear

Upstream has flagged that future major releases may ship no official macOS
binaries at all. If that happens, the cask URL 404s and `bump-qbittorrent.yml`
fails loudly. Fallbacks: GitHub CI nightly builds, community builds
([#22859](https://github.com/qbittorrent/qBittorrent/issues/22859)), or build
from source.

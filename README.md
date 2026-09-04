# Dependabot Swift Linux lockfile repro

Minimal Swift package that shows Dependabot’s Linux updater writing a pin that a macOS/iOS resolve never needs.

`Packages/HostConditional` uses the same `#if !canImport(Combine)` pattern as [skip-model](https://github.com/skiptools/skip-model/blob/1.7.9/Package.swift): OpenCombine is added only when the **resolving host** lacks Combine. Combine exists on Apple platforms, not in Dependabot’s Ubuntu Swift image.

Checked-in `Package.resolved` (from macOS):

- `swift-log` 1.14.0
- no `opencombine`

`swift package update` in `swift:6.1` (Linux):

- bumps `swift-log` to 1.15.0
- **adds** `opencombine` 0.16.0

That extra pin is unused on iOS/macOS. `swift package resolve` on macOS does not remove it once it is in the file.

## Reproduce

macOS (this tree, as committed):

```bash
swift package resolve
# Package.resolved still has only swift-log
```

Linux (what Dependabot’s Swift updater runs):

```bash
docker run --rm -v "$PWD":/src -w /src swift:6.1 swift package update
# Package.resolved now also pins opencombine
```

Optional live Dependabot demo: enable Dependabot on this repo. The Swift ecosystem config is in `.github/dependabot.yml`. The first `swift-log` bump PR should also add `opencombine`.

## Suggested dependabot-core issue

**Title:** Swift updater on Linux commits host-conditional pins that Apple platforms do not need

**Body:**

Dependabot’s Swift updater runs `swift package` in a Linux image. Manifests that add dependencies with `#if !canImport(Combine)` / `#if os(Linux)` are evaluated on that host, so the committed `Package.resolved` includes packages the app never links on iOS or macOS.

There is no `dependabot.yml` option to resolve for macOS/iOS, and SwiftPM has no `swift package update --platform macOS`.

Repro: https://github.com/dave-awre/dependabot-swift-linux-lockfile

1. `Package.resolved` from macOS has only `swift-log`.
2. `docker run --rm -v "$PWD":/src -w /src swift:6.1 swift package update` adds `opencombine`.

Seen on a real app when Dependabot bumped `swift-crypto` and also added OpenCombine from skip-model’s `#if !canImport(Combine)` block.

Ask: resolve as if Combine/Apple platforms were available, or strip pins that only exist because of the Linux host, or document that Swift lockfiles from Dependabot are Linux-host lockfiles.

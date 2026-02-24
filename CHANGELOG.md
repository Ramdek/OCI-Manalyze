# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.0] - 2026-24-02

### Added

- Image build `dev` step. The images containing this keyword in the tag can be
  used to build on top.

### Fixed

- Invalid JSON output in Manalyze recursive directory scan.

## [0.2.0] - 2026-18-02

### Added

- VirusTotal plugin support with `VIRUS_TOTAL_API_KEY` environment variable.

### Fixed

- Support `Ctrl+C` when running container in CLI.

## [0.1.0] - 2026-16-02

This is the initial release.

### Added

- README file.
- CHANGELOG file.
- Application cache prepackaging.
- Distroless OCI image build.

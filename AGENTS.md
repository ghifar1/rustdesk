# Repository Guidelines

## Project Structure & Module Organization
Source code for the desktop core lives under `src/` (Rust entrypoints such as `main.rs`, `server/`, `client/`). Shared crates and native integrations are in `libs/` (`hbb_common`, `enigo`, `virtual_display`). The Flutter UI resides in `flutter/`, while packaging scripts and icons sit in `res/`. Kubernetes deployment assets are in `charts/rustdesk/`, documentation in `docs/`, and build helpers like `Dockerfile`, `build.py`, and `entrypoint.sh` remain at the repository root.

## Build, Test, and Development Commands
Run `cargo build --release` to produce optimized binaries; use `cargo run -- --help` during feature work. The Docker toolchain can be prepared with `docker build -t rustdesk-builder .` followed by `docker run ... --release` (see `README.md`). For Flutter clients, execute `flutter pub get` and `flutter build linux` from `flutter/`. Validate the Helm chart with `helm lint charts/rustdesk`.

## Coding Style & Naming Conventions
Rust code follows `rustfmt` defaults (4-space indentation, snake_case functions, UpperCamelCase types). Clippy warnings should be addressed with `cargo clippy --workspace --all-features`. Flutter code adopts Dart formatting via `dart format .` and `flutter analyze`. Configuration files use TOML or YAML with lowercase keys. Translation updates belong in the corresponding `src/lang/*.rs` files and should keep keys alphabetical.

## Testing Guidelines
Execute `cargo test --workspace --all-features` before opening a pull request; place new unit tests beside the modules they cover. Flutter widgets rely on `flutter test`. When touching networking or server logic, include integration checks in `libs/hbb_common` or `src/server` as appropriate, and document any manual relay testing steps in the pull request.

## Commit & Pull Request Guidelines
Commit messages should be concise and imperative (`fix: adjust DPI scaling`, `build: update workflow`) and reference GitHub issues using the `(#12345)` trailer when applicable. Squash noisy fixups before pushing. Pull requests must describe the change, list manual verification (OS, target triple, Flutter platform), and attach screenshots for UI tweaks. Link related Helm or packaging updates explicitly so reviewers can trace release impacts.

## Security & Configuration Tips
Avoid committing credentials; rendezvous/relay secrets belong in runtime configuration, not git. When editing `res/` packaging scripts or systemd units, note platform-specific security implications (e.g., PAM changes). For Helm deployments, ensure `values.yaml` overrides set private images and TLS-enabled endpoints before exposing services publicly.

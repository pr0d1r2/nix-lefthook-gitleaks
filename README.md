# nix-lefthook-gitleaks

[![CI](https://github.com/pr0d1r2/nix-lefthook-gitleaks/actions/workflows/ci.yml/badge.svg)](https://github.com/pr0d1r2/nix-lefthook-gitleaks/actions/workflows/ci.yml)

> This code is LLM-generated and validated through an automated integration process using [lefthook](https://github.com/evilmartians/lefthook) git hooks, [bats](https://github.com/bats-core/bats-core) unit tests, and GitHub Actions CI.

Lefthook-compatible [gitleaks](https://github.com/gitleaks/gitleaks) secret scanner, packaged as a Nix flake.

Scans staged files for hardcoded secrets (API keys, tokens, passwords). Copies staged files into a temp directory and runs gitleaks on it. Exits 0 when no files are found.

## Usage

### Option A: Lefthook remote (recommended)

Add to your `lefthook.yml` — no flake input needed, just `pkgs.gitleaks` in your devShell:

```yaml
remotes:
  - git_url: https://github.com/pr0d1r2/nix-lefthook-gitleaks
    ref: main
    configs:
      - lefthook-remote.yml
```

### Option B: Flake input

Add as a flake input:

```nix
inputs.nix-lefthook-gitleaks = {
  url = "github:pr0d1r2/nix-lefthook-gitleaks";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

Add to your devShell:

```nix
nix-lefthook-gitleaks.packages.${pkgs.stdenv.hostPlatform.system}.default
```

Add to `lefthook.yml`:

```yaml
pre-commit:
  commands:
    gitleaks:
      run: timeout ${LEFTHOOK_GITLEAKS_TIMEOUT:-30} lefthook-gitleaks {staged_files}
```

### Configuring timeout

The default timeout is 30 seconds. Override per-repo via environment variable:

```bash
export LEFTHOOK_GITLEAKS_TIMEOUT=60
```

## Development

The repo includes an `.envrc` for [direnv](https://direnv.net/) — entering the directory automatically loads the devShell with all dependencies:

```bash
cd nix-lefthook-gitleaks  # direnv loads the flake
bats tests/unit/
```

If not using direnv, enter the shell manually:

```bash
nix develop
bats tests/unit/
```

## License

MIT

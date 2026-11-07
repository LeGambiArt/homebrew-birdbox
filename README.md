# Homebrew tap for Birdbox tools

This tap packages [arkai](https://github.com/LeGambiArt/arkai), a CLI for
orchestrating coding agents with local or cloud inference,
[arapuca](https://github.com/LeGambiArt/arapuca), a cross-platform process
sandbox, and [wtmcp](https://github.com/LeGambiArt/wtmcp), an MCP server with
plugin-based integrations for developer tools.

## Installation

Enable and trust LeGambiArt tap:

```bash
brew tap legambiart/birdbox
brew trust legambiart/birdbox
```

### Arkai

Install Arkai and its sandbox/MCP dependencies:

```bash
brew install arkai
```

Arkai also needs a supported coding-agent CLI and inference backend, which must
be installed separately. Git (and Git LFS for some models) is needed for
Git-backed model downloads.

Install optional Python features at build time:

```bash
brew install --build-from-source --with-rag arkai
brew install --build-from-source --with-mlx arkai
brew install --build-from-source --with-rag --with-mlx arkai
```

RAG is supported on Linux x86_64/aarch64 and Apple Silicon macOS. MLX is
supported only on Apple Silicon macOS 14 or newer. On Linux, the RAG wheels
require glibc 2.28 or newer. The Python `keyring` package is included by
default.

### arapuca

Install the `arapuca` sandbox on its own:

```bash
brew install arapuca
```

### wtmcp

Install `wtmcp` core and plugins:

```bash
brew install wtmcp
```

### Development versions

To install development versions from the `main` branches:

```bash
brew install --HEAD arapuca
brew install --HEAD wtmcp
brew install --HEAD arkai
```

## Updating from old taps

If you installed older taps for wtmcp or arapuca, you'll need to untap them:

```bash
brew untap legambiart/arapuca
brew untap legambiart/wtmcp
```

After untap success, proceed with normal installation of the formulae.

## Updating Formulae

Use the helper to update a formula from a tagged release:

```bash
./contrib/update-homebrew-formula.sh arapuca 0.2.9
./contrib/update-homebrew-formula.sh wtmcp 0.1.9
./contrib/update-homebrew-formula.sh arkai 0.8.0
```

The helper downloads the release tarball, calculates its SHA256 checksum, and
updates the matching formula.

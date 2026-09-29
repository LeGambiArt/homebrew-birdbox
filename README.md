# Homebrew tap for Birdbox tools

This tap packages [arapuca](https://github.com/LeGambiArt/arapuca), a
cross-platform process sandbox, and [wtmcp](https://github.com/LeGambiArt/wtmcp),
an MCP server with plugin-based integrations for developer tools.

## Installation

```bash
brew tap legambiart/birdbox
brew install arapuca
brew install wtmcp
```

To install development versions from the `main` branches:

```bash
brew install --HEAD arapuca
brew install --HEAD wtmcp
```

## Updating Formulae

Use the helper to update either formula from a tagged release:

```bash
./contrib/update-homebrew-formula.sh arapuca 0.2.9
./contrib/update-homebrew-formula.sh wtmcp 0.1.8
```

The helper downloads the release tarball, calculates its SHA256 checksum, and
updates the matching formula.

You might need to trust the tap:

```bash
brew trust legambiart/birdbox
```

Or you can trust individual formulae:

```bash
brew trust legambiart/birdbox/arapuca
brew trust legambiart/birdbox/wtmcp
```

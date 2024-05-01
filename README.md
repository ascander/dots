<!-- markdownlint-disable MD013 -->
# Dots

These are my Nix configurations for macOS. The repository name is an anagram of my surname. That's the joke.

## Prerequisites

- A recent (read: flake-enabled) [Nix](https://nixos.org/download.html) installation

## Using

Build and switch to the configuration for `{hostname}` by running:

```sh
nix build .#darwinConfigurations.{hostname}.system && ./result/sw/bin/darwin-rebuild switch --flake .
```

where `{hostname}` is a Darwin configuration in `flake.nix`.

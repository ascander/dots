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

### Updating

Update all flake inputs by running:

```shell
nix flake update
```

Update the flake input `{input}` by running:

```shell
nix flake lock --update-input {input}
```

where `{input}` is a flake input defined in `flake.nix`.

### Garbage collection

Delete old generations by running:

```shell
nix-garbage-collect -d
```

After running `nix-garbage-collect` above, run:

```shell
sudo ./result/sw/bin/nix-collect-garbage -d 
```

Both are required due to strange behavior associated with multi-user Nix installations. See https://github.com/LnL7/nix-darwin/issues/237 for details.

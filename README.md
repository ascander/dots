<!-- markdownlint-disable MD013 MD034 -->
# dots

These are my Nix configurations for macOS. The repository name is an anagram of my surname. That's the joke.

## Prerequisites

- A recent (read: flake-enabled) [Nix](https://nixos.org/download.html) installation

## Commands

### Building and Switching

Build the configuration for `{hostname}`:

```sh
nix build .#darwinConfigurations.{hostname}.system
```

Apply the configuration (requires admin privileges):

```sh
sudo ./result/sw/bin/darwin-rebuild switch --flake .
```

Preview changes without applying (dry-run):

```sh
darwin-rebuild build --flake . --dry-run
```

### Updating Inputs

Update all flake inputs:

```sh
nix flake update
```

Update a specific input:

```sh
nix flake update {input}
```

Show available flake outputs:

```sh
nix flake show
```

### Generations

List past generations:

```sh
darwin-rebuild --list-generations
```

Roll back to the previous generation:

```sh
darwin-rebuild --rollback switch --flake .
```

Switch to a specific generation:

```sh
darwin-rebuild -G {generation} switch --flake .
```

### Garbage Collection

Delete old generations (both commands required for multi-user Nix):

```sh
nix-collect-garbage -d
sudo ./result/sw/bin/nix-collect-garbage -d
```

> [!NOTE]
  See https://github.com/LnL7/nix-darwin/issues/237 for details on why both are needed.

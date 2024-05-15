<!-- markdownlint-disable MD013 -->
# Nix Notes

This document contains one-off issues encountered while trying to use this flake.

## Github API rate limits

When updating flake inputs with `nix flake update`, I got API rate limit errors from Github. After searching and finding [this issue](https://github.com/NixOS/nix/issues/4653), I added personal tokens for both Github and Git Soma to `~/.config/nix/nix.conf`

## Nexus and Git Soma

In order to download artifacts from Git Soma and/or Nexus, Nix needs to be configured to use the right certs and access tokens. Currently, I have this configured via `~/.config/nix/nix.conf` with the following:

```conf
netrc-file /etc/nix/netrc
ssl-cert-file /etc/nix/certs.pem
```

The file in `/etc/nix/netrc` was created as follows:

```shell
sudo cp ~/.netrc /etc/nix/netrc
```

and contains entries for `git.soma.salesforce.com` and `nexus-proxy.repo.local.sfdc.net`.

The file in `/etc/nix/certs.pem` was created as follows:

```shell
security find-certificate -a -p | sudo tee /etc/nix/certs.pem > /dev/null
security find-certificate -a -p /System/Library/Keychains/SystemRootCertificates.keychain | sudo tee -a /etc/nix/certs.pem > /dev/null
sudo chmod 744 /etc/nix/certs.pem
```

after manually adding SFDC certs via the Keychain Access app.

I think for eg. fetching OneJDK from the SFDC nix-channel, we'll need to configure Nix with access tokens for Git Soma and Nexus. I'm not sure about the certs, since OneJDK will include the necessary certs for fetching dependencies, etc. from Nexus. I'll need to experiment with this to find the minimal setup required.

<!-- SPDX-LICENSE-IDENTIFIER: GPL-2.0-Only -->

<img src="https://gateway.pinata.cloud/ipfs/QmV9xRwBdX1Uo3a67TsaB27Qwty5mjVAzF6bbzDxFykQ8k/tornado_cash_banner.jpeg" align="center">   


# Tornado Onion service

## Overview

> `tornado.cash` **tor onion** service for rpc - Zero Trust Transaction & History Logging

This repo can be used to run `tornado.cash` as an onion service. It will auto update the UI when the new version is released.

Deploy Complete TORnado Private Network
Network Obfuscation Layer
Transactions at least +3 hops

### Notice

No Security Audit has been performed nor should this be your sole remedy for obfuscation of transactions. **Do not use IPFS with this**.

## Usage

You will need a machine with Docker installed. First, generate a private key for a new .onion domain:

```shell script
docker run --rm --entrypoint shallot strm/tor-hiddenservice-nginx ^foo
```

Then paste the private key to `docker-compose.yml`

Then run

```shell script
docker-compose up -d
```

In a few minutes tornado.cash UI should be available on your .onion domain

## Extended usage

> Deploying full TORnado Testnet

## Utils

Concensus scripts to monitor

## Network

This is a full-blown Tor network deployment

## Scripts

shell scripts related only to the `Network/` directory

## GPG/ASC

to utilize `diff` execute;

`$ git config --global diff.gpg.textconv "gpg --no-tty --decrypt"  `

## License

SPDX-License-Identifier: GPL-2.0-Only

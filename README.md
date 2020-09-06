# Tornado Onion service

<img src="https://pbs.twimg.com/profile_banners/1154795176507969543/1576151439/1500x500" width="900" align="center">   
<br>    
<br>    


[![Build Status](https://travis-ci.com/sambacha/tornado-onion.svg?branch=master)](https://travis-ci.com/sambacha/tornado-onion)

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

## License

SPDX-License-Identifier: GPL-2.0

# reth-systemd

Run [reth](https://reth.rs/) and [lighthouse](https://lighthouse-book.sigmaprime.io/) via Podman and systemd.

## Buil JWT token generator

    podman build -t jwt-generator ./jwt

## Run

Start:

    ./start.sh

Stop:

    ./stop.sh

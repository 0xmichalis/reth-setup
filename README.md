# reth-setup

Run [reth](https://reth.rs/) and [lighthouse](https://lighthouse-book.sigmaprime.io/) via Podman.

## Buil JWT token generator

	podman build -t jwt-generator ./jwt

## Run

### systemd

Start:

	./systemd/start.sh

Stop:

	./systemd/stop.sh

### podman-compose

Start:

	./podman-compose/start.sh

Stop:

	./podman-compose/stop.sh

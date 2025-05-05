# reth-setup

Run [reth](https://reth.rs/) and [lighthouse](https://lighthouse-book.sigmaprime.io/) via Podman.

## Buil JWT token generator

	podman build -t jwt-generator ./jwt

## Run

### podman-compose

Start:

	./podman-compose/start.sh

Stop:

	./podman-compose/stop.sh


### systemd

> **⚠️ Warning:** The `systemd` setup is **not actively maintained or used**. It may be outdated or not work as expected. Happy to merge contributions to it!

Start:

	./systemd/start.sh

Stop:

	./systemd/stop.sh

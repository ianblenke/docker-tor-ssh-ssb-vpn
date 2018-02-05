# docker-tor-ssh

Run a tor container that publishes a hidden service that lets you ssh to the underlying docker-machine host or VM parent machine.

# Usage:

Using `docker-compose`, merely:

    docker-compose build tor
    docker-compose up -d tor


# Munin v3 (master)

Munin v3 is currently in _beta_ stage, use at your own risk. The protcol is compatible to Munin v2
nodes, so you don't have to update them.

Munin v3 contains a built-in minimal webserver that generates graphs on-demand so it should use less resources
than Munin v2 nodes with the default `graph_strategy` (cron).

You can either use it behind a reverse proxy (e.g. nginx) so you can have other virtual hosts on the server
or expose it directly to the internet.

## Volumes

* `/var/lib/munin` used to store the collected data
* `/var/log/munin` used to store logs
* `/usr/local/etc/munin/munin-conf.d` to add your own configuration

## Ports

* `4948` - Munin HTTP server

## Usage examples

Create a directory to store your data and configuration files:

    mkdir -p /var/volumes/munin/lib
    mkdir -p /var/volumes/munin/conf

Make sure the lib directory is writable for munin (uid 1000).

Create a configuration file for munin, e.g (`/var/volumes/munin/conf/hosts.conf`):

    [bauerj.eu;moonraker.bauerj.eu]
        address moonraker.bauerj.eu
        port 4949

### Directly connected to the internet

If you use `docker-compose`:

      munin:
        image: bauerj/munin-v3
        ports:
          - "80:4948"
        volumes:
          - /var/volumes/munin/lib:/var/lib/munin
          - /var/volumes/munin/conf:/usr/local/etc/munin/munin-conf.d

Or using docker run:

    docker run --name munin -v '/var/volumes/munin/lib:/var/lib/munin' -v '/var/volumes/munin/conf:/usr/local/etc/munin/munin-conf.d' -p '80:4948' bauerj/munin-v3


### With a reverse proxy

In most cases, you want to use a reverse proxy to connect to munin. If you want to use nginx, you can use something like this:

    server {
        server_name munin.bauerj.eu;
        location / {
            proxy_pass http://munin:4948;
        }
    }

If nginx is running inside a docker container, make sure to link munin to your nginx container.

## Demo

You can find a live demo of the current development version of munin [here](http://demo.munin-monitoring.org/).

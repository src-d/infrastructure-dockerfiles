# haproxy-syslogd

Since haproxy only logs to syslogd we need something for `docker logs` to work. This is a quick workaround. It uses [tini](https://github.com/krallin/tini) to be able to forward signals to all the processes below (as we start syslogd before than haproxy).

## Build

```
make docker-push
```

## Usage

This image assumes configuration will be provided externally via a volume mount. For example, assuming an haproxy running in port 444:

```
docker run -v /path/to/haproxy.conf:/usr/local/etc/haproxy/haproxy.cfg:ro -d -p 444:444 --name haproxy  srcd/haproxy-syslogd
```

## Caveats

Proper reload of the config through the use of master-worker doesn't seem to work properly.

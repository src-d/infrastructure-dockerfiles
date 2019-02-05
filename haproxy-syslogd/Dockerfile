FROM haproxy:1.8.2-alpine
RUN apk add --no-cache tini
COPY cmd.sh /
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/cmd.sh"]

FROM rabbitmq:3

ENV RABBITIO_RELEASE v0.5.4
RUN apt-get update && apt-get install -y iputils-ping telnet curl python
RUN mkdir -p /opt/rabbitio && curl -L -o /opt/rabbitio/rabbitio https://github.com/meltwater/rabbitio/releases/download/${RABBITIO_RELEASE}/rabbitio-${RABBITIO_RELEASE}-linux-amd64 && chmod +x /opt/rabbitio/rabbitio  

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"

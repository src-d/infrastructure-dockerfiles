FROM rabbitmq:3

RUN apt-get update && apt-get install -y iputils-ping telnet curl python
COPY files/rabbitio-v0.5.4-linux-amd64 /opt/rabbitio

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"

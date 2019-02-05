# Spark

This is a Docker image appropriate for running Spark on Kuberenetes. It produces an image that can be used for master in stand-alone mode and worker.

This was based in https://github.com/kubernetes-incubator/application-images/tree/master/spark (upgrading it to 2.2.1 and removing zeppelin stuff)

Use `make docker-push` to build and push images

## Startup

* Master

```
echo $(hostname -i) master-hostname >> /etc/hosts
/opt/spark/sbin/start-master.sh --host master-hostname --port <port> --webui-port <webui port>
```

* Worker

```
/opt/spark/sbin/start-slave.sh spark://master-hostname:port --webui-port <webui port>
```

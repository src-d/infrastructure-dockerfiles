FROM srcd/spark-ml:2.2.3


ENV LIVY_VERSION=0.5.0-incubating \
    LIVY_HOME=/opt/livy

RUN wget -nv http://apache.rediris.es/incubator/livy/${LIVY_VERSION}/livy-${LIVY_VERSION}-bin.zip \
  && unzip livy-${LIVY_VERSION}-bin.zip -d /tmp \
  && mv /tmp/livy-${LIVY_VERSION}-bin ${LIVY_HOME} \
  && rm livy-${LIVY_VERSION}-bin.zip \
  && mkdir -p ${LIVY_HOME}/logs

ADD entrypoint.sh .
ADD log4j.properties $LIVY_HOME/conf/

RUN chmod +x entrypoint.sh

# Expose port
EXPOSE 8998

ENTRYPOINT ["/entrypoint.sh"]

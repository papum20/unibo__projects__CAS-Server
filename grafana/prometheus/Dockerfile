# FROM prom/prometheus
FROM prom/prometheus:v2.48.0-rc.2

ARG LOCAL_GID

# change volumes permissions
USER root
RUN groupadd -g ${LOCAL_GID} docker
RUN usermod -aG docker grafana

USER nobody
ENTRYPOINT [ "/bin/prometheus" ]

# add from original Dockerfile: enable remote write receiver
CMD        [ "--config.file=/etc/prometheus/prometheus.yml", \
             "--storage.tsdb.path=/prometheus", \
             "--web.console.libraries=/usr/share/prometheus/console_libraries", \
             "--web.console.templates=/usr/share/prometheus/consoles", \
             "--web.enable-remote-write-receiver" ]
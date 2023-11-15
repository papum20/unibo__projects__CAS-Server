# FROM prom/prometheus
FROM prom/prometheus:v2.48.0-rc.2

ARG LOCAL_GID

# change volumes permissions
USER root
# groupadd and usermod: commands not found
RUN addgroup -g ${LOCAL_GID} docker
RUN addgroup nobody docker

USER nobody
ENTRYPOINT [ "/bin/prometheus" ]

# add from original Dockerfile:
# - enable remote write receiver
# - subpath at /prometheus/
# - but internal subpath at /, so proxy sends /pro metheus/* to /*

CMD [ "--config.file=/etc/prometheus/prometheus.yml", \
    "--storage.tsdb.path=/prometheus", \
    "--web.console.libraries=/usr/share/prometheus/console_libraries", \
    "--web.console.templates=/usr/share/prometheus/consoles", \
    "--web.enable-remote-write-receiver", \
    "--web.external-url=/prometheus/", \
    "--web.route-prefix=/" ]
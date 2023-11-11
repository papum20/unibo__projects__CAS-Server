FROM grafana/grafana-oss:10.2.0-ubuntu

ARG LOCAL_GID

# change volumes permissions
USER root
RUN groupadd -g ${LOCAL_GID} docker
RUN usermod -aG docker grafana

USER grafana
ENTRYPOINT ["/run.sh"]


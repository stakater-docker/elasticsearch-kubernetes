# TODO: change to stakater image
FROM quay.io/pires/docker-elasticsearch:6.2.4

MAINTAINER Stakater Team <hello@stakater.com>

# Override config, otherwise plug-in install will fail
ADD config /elasticsearch/config

# Set environment
ENV DISCOVERY_SERVICE elasticsearch-discovery
ENV STATSD_HOST=statsd.statsd.svc.cluster.local
ENV SEARCHGUARD_SSL_TRANSPORT_ENABLED=true
ENV SEARCHGUARD_SSL_HTTP_ENABLED=true

# Why?
## otherwise it fails with `mktemp: Invalid argument`
## https://github.com/elastic/elasticsearch/issues/28561#issuecomment-364126503
## https://github.com/pires/docker-elasticsearch/blob/master/run.sh#L18
ENV ES_TMPDIR `mktemp -d -t elasticsearch.XXXXXXXX`

# Fix bug installing plugins
ENV NODE_NAME=""

# Install search-guard-ssl
RUN ./bin/elasticsearch-plugin install -b com.floragunn:search-guard-ssl:6.2.4-25.3

# Install s3 repository plugin
RUN ./bin/elasticsearch-plugin install repository-s3

# Install prometheus plugin
RUN ./bin/elasticsearch-plugin install https://github.com/vvanholl/elasticsearch-prometheus-exporter/releases/download/6.2.4.0/elasticsearch-prometheus-exporter-6.2.4.0.zip
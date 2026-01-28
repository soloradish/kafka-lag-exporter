#!/usr/bin/env bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

VERSION=$1
RELEASE_URL="https://github.com/soloradish/kafka-lag-exporter/releases/download/v$VERSION/kafka-lag-exporter-$VERSION.tgz"
RELEASE_URL_ESCAPED=$(echo $RELEASE_URL | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')

echo Update README.md helm install command to:
echo helm install $RELEASE_URL
sed -i -r "s/helm install http\S*/helm install ${RELEASE_URL_ESCAPED}/g" $DIR/../README.md

echo Update README.md Running Docker Image version to:
echo ghcr.io/soloradish/kafka-lag-exporter:${VERSION}
sed -i -r "s/ghcr\.io\/soloradish\/kafka-lag-exporter:\S*/ghcr.io\/soloradish\/kafka-lag-exporter:${VERSION}/g" $DIR/../README.md

echo Update examples/standalone/run-docker.sh Docker Image version to:
echo ghcr.io/soloradish/kafka-lag-exporter:${VERSION}
sed -i -r "s/ghcr\.io\/soloradish\/kafka-lag-exporter:\S*/ghcr.io\/soloradish\/kafka-lag-exporter:${VERSION}/g" $DIR/../examples/standalone/run-docker.sh

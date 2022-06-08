#!/usr/bin/env bash

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd $DIR/..

rm -rf ./dist
rm -rf ./package

mkdir -p ./package/dependencies/nodejs

yarn install && \
    yarn build && \
    yarn install --production --frozen-lockfile --modules-folder ./package/dependencies/nodejs/node_modules

yarn openapi ./package/openapi.json

cp -r ./dist ./package
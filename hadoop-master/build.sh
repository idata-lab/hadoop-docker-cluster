#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

docker build -t idata-lab/hadoop-master:latest $DIR

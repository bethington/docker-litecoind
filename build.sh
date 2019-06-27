#!/bin/bash
mv ./data ../data
docker build --build-arg VERSION=v0.17.1 -t bethington/litecoind .
docker build --build-arg VERSION=v0.17.1 -t bethington/litecoind:v0.17.1 .
mv ../data ./data

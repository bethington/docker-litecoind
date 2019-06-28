#!/bin/bash
docker build --build-arg VERSION=v0.17.1 --build-arg USER_ID=1000 --build-arg GROUP_ID=1000 -t bethington/litecoind .
docker build --build-arg VERSION=v0.17.1 --build-arg USER_ID=1000 --build-arg GROUP_ID=1000 -t bethington/litecoind:v0.17.1 .

# ML Platform

The ML Platform is a machine learning model serving platform exposing models over REST and Kafka.

## Purpose

The platform provides a standardised way to deploy and serve machine learning models, supporting both synchronous REST and asynchronous streaming (Kafka) interfaces.

## Containers

- **Model sidecar application** - Ambassador sidecar handling protocol translation (HTTP/Kafka → GRPC).
- **Model** - The Python model container serving predictions via GRPC.

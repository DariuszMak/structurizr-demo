# 1. Use Sidecar Pattern for Model Serving

Date: 2025-01-01

## Status

Accepted

## Context

Machine learning models need to be accessible over both REST and Kafka streaming interfaces without coupling the model implementation to serving infrastructure.

## Decision

We will use the Ambassador sidecar pattern. A separate sidecar container handles all inbound protocol translation and forwards requests to the model container via GRPC.

## Consequences

- Model developers only implement a standard Python `predict` interface.
- The sidecar can be updated independently of the model.
- Adds an extra network hop (GRPC) between sidecar and model.

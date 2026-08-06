# 1. Use a Single Shared Database for Both Services

Date: 2025-01-01

## Status

Accepted

## Context

The FastAPI service and the Django service both need persistent storage, and the platform is intended to stay simple for local development.

## Decision

Both services connect to a single PostgreSQL container rather than each having its own database instance.

## Consequences

- Fewer containers to run locally.
- Both services must coordinate on schema changes.
- Not representative of a production topology, where each service would typically own its data.

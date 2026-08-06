# Local Kubernetes Platform

The Local Kubernetes Platform runs Python applications on a local k3d Kubernetes cluster for development purposes.

## Purpose

The platform provides a standardised local environment for running and testing a FastAPI service and a Django service, backed by a shared PostgreSQL database, with secrets management, GitOps deployment, monitoring, logging, and code quality analysis provided by supporting tools.

## Containers

- **FastAPI Service** - Serves REST API endpoints.
- **Django Service** - Serves the Django web application.
- **Application Database** - PostgreSQL database shared by both services.

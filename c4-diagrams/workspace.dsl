workspace "Local Kubernetes Cluster" "Local development platform running Python applications on a local Kubernetes cluster." {

    !identifiers hierarchical
    !impliedRelationships false

    configuration {
        scope softwaresystem
    }

    model {
        developer = person "Developer" "Engineer running and deploying the applications locally." "External"

        platform = softwareSystem "Local Kubernetes Platform" "Runs the FastAPI and Django applications on a local k3d Kubernetes cluster." {
            !docs ./docs
            !adrs ./decisions

            fastapi_service = container "FastAPI Service" "Serves REST API endpoints." "Python, FastAPI" {
                api_router = component "API Router" "Routes incoming HTTP requests." "FastAPI"
                service_layer = component "Services" "Implements business logic." "Python"
                repository_layer = component "Repositories" "Handles data access." "Python"
                schema_layer = component "Schemas" "Defines request and response models." "Pydantic"

                api_router -> service_layer "Calls" "In-process"
                api_router -> schema_layer "Validates with" "In-process"
                service_layer -> repository_layer "Uses" "In-process"
            }

            django_service = container "Django Service" "Serves the Django web application." "Python, Django"

            database = container "Application Database" "Stores application data." "PostgreSQL" "Database"

            fastapi_service -> database "Reads from and writes to" "SQL"
            django_service -> database "Reads from and writes to" "SQL"
        }

        vault = softwareSystem "Vault" "Stores and injects application secrets." "External"
        argocd = softwareSystem "ArgoCD" "Continuously deploys the platform from Git using GitOps." "External"
        monitoring = softwareSystem "Monitoring" "Collects and visualises metrics from the platform." "External"
        logging = softwareSystem "Logging" "Collects and indexes application and container logs." "External"
        sonarqube = softwareSystem "SonarQube" "Analyses code quality and test coverage." "External"

        developer -> platform "Develops and runs locally" "CLI"
        developer -> argocd "Configures deployments in" "HTTPS"
        platform.fastapi_service -> vault "Reads secrets from" "HTTPS"
        platform.django_service -> vault "Reads secrets from" "HTTPS"
        platform -> logging "Sends logs to" "Filebeat"
        platform -> monitoring "Exposes metrics to" "HTTP"
        argocd -> platform "Deploys" "Helm"
        sonarqube -> platform "Analyses source code of" "HTTPS"
    }

    views {
        systemLandscape "SystemLandscape" {
            include *
            autolayout lr
        }

        systemContext platform "SystemContext" {
            include *
            autolayout lr
        }

        container platform "Containers" {
            include *
            autolayout lr
        }

        component platform.fastapi_service "Components" {
            include *
            autolayout lr
        }

        styles {
            element "External" {
                background #888888
                color #ffffff
                stroke #444444
                strokeWidth 2
                border Dashed
                shape RoundedBox
                opacity 90
            }
            
            element "External Person" {
                shape Person
                background #777777
                color #ffffff
                border Dashed
            }

            element "Database" {
                shape Cylinder
            }
        }
    }
}

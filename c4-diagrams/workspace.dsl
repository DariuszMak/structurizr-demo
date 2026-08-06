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
            django_service = container "Django Service" "Serves the Django web application." "Python, Django" {
                users_app = component "Users App" "Manages user accounts." "Django App"
                posts_app = component "Posts App" "Manages posts and related content." "Django App"
            }
            fastapi_database = container "FastAPI Database" "Stores FastAPI application data." "SQLite" "Database"
            django_database = container "Django Database" "Stores Django application data." "SQLite" "Database"
            fastapi_service -> fastapi_database "Reads from, writes to, and migrates via Alembic" "SQL"
            django_service -> django_database "Reads from, writes to, and migrates via Django ORM" "SQL"
        }
        vault = softwareSystem "Vault" "Stores and injects application secrets." "External"
        argocd = softwareSystem "ArgoCD" "Continuously deploys the platform from Git using GitOps." "External"
        monitoring = softwareSystem "Monitoring" "Collects and visualises metrics from the platform using Prometheus and Grafana." "External"
        logging = softwareSystem "Logging" "Collects and indexes application and container logs using Elasticsearch and Kibana." "External"
        sonarqube = softwareSystem "SonarQube" "Analyses code quality and test coverage." "External"
        developer -> platform "Develops and runs locally" "Task, Tilt, kubectl, Kustomize, Helm"
        developer -> argocd "Configures deployments in" "HTTPS"
        platform.fastapi_service -> vault "Reads secrets from" "HTTPS"
        platform.django_service -> vault "Reads secrets from" "HTTPS"
        platform -> logging "Sends logs to" "Filebeat"
        monitoring -> platform "Scrapes metrics from" "HTTP"
        platform -> sonarqube "Sends source code for analysis to" "HTTPS"
        argocd -> platform "Deploys" "Helm"
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
        component platform.django_service "DjangoComponents" {
            include *
            autolayout lr
        }
        styles {
            element "External" {
                background #617696
                color #ffffff
                stroke #223344
                strokeWidth 2
                border Dashed
                shape RoundedBox
                opacity 80           
                fontSize 20          
                metadata false   
            }

            element "External Person" {
                shape Person
                background #617696
                color #ffffff
                stroke #223344
                strokeWidth 2
                border Dashed
                opacity 80
            }

            element "Database" {
                shape Cylinder
                background #f26419   
                color #ffffff
                stroke #a74511
                strokeWidth 2
                opacity 90
            }

            element "Internal" {
                background #1168bd   
                color #ffffff
                shape RoundedBox
                stroke #0b4884
                strokeWidth 2
                fontSize 22          
            }

            relationship "Relationship" {
                thickness 2          
                color #707070        
                dashed false         
                routing Orthogonal   
                fontSize 16          
            }
        }
    }
}
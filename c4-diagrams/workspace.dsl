workspace "Local Kubernetes Cluster" "Local development platform running Python applications on a local Kubernetes cluster." {

    !identifiers hierarchical
    !impliedRelationships false

    configuration {
        scope softwaresystem
    }

    model {

        developer = person "Developer" "Engineer running and deploying applications locally." "External"

        platform = softwareSystem "Local Kubernetes Platform" "Runs FastAPI and Django applications on a local k3d Kubernetes cluster." {

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


            django_service = container "Django Service" "Serves Django web application." "Python, Django" {

                users_app = component "Users App" "Manages user accounts." "Django App"

                posts_app = component "Posts App" "Manages posts and related content." "Django App"

                users_app -> posts_app "Provides user references for posts" "Django ORM"
                posts_app -> users_app "Checks post ownership" "Django ORM"
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


        developer -> platform  "Develops and runs locally" "Task, Tilt, kubectl, Kustomize, Helm"


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


        component platform.fastapi_service "FastAPIComponents" {
            include *
            autolayout lr
        }


        component platform.django_service "DjangoComponents" {
            include *
            autolayout lr
        }



        styles {


            element "Element" {
                color #DFDADA
                fontSize 20
                strokeWidth 2
            }


            element "Person" {
                shape Person
                background #0F766E
                stroke #134E4A
                strokeWidth 3
            }


            element "External Person" {
                shape Person
                background #94A3B8
                stroke #64748B
                border Dashed
                opacity 80
            }


            element "Software System" {
                shape RoundedBox
                background #0B3F8D
                stroke #023D8A
                strokeWidth 3
            }


            element "Container" {
                shape RoundedBox
                background #005EB6
                stroke #0B3C86
            }


            element "Web App" {
                shape WebBrowser
                background #005EB6
                stroke #0B3C86
            }


            element "Mobile App" {
                shape MobileDevicePortrait
                background #005EB6
                stroke #0B3C86
            }


            element "Database" {
                shape Cylinder
                background #06885D
                stroke #065740
            }


            element "Message Bus" {
                shape Pipe
                background #F59E0B
                stroke #B45309
            }


            element "External System" {
                shape RoundedBox
                background #7189AA
                stroke #6683AC
                border Dashed
                opacity 80
            }


            relationship "Relationship" {
                thickness 2
                color #EEEA1E
                dashed false
                routing Orthogonal
                fontSize 16
            }


            relationship "Async" {
                dashed true
                color #F59E0B
            }
        }
    }
}
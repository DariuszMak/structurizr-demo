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
                fastapi_api_router = component "API Router" "Routes incoming HTTP requests to endpoints." "FastAPI"{
                    tags "Python"
                }
                fastapi_auth_service = component "Auth Service" "Handles JWT token creation and validation." "Python"{
                    tags "Python"
                }
                fastapi_post_service = component "Post Service" "Implements post CRUD business logic." "Python"{
                    tags "Python"
                }
                fastapi_user_service = component "User Service" "Implements user CRUD business logic." "Python"{
                    tags "Python"
                }
                fastapi_post_repository = component "Post Repository" "Handles post data access." "Python"{
                    tags "Python"
                }
                fastapi_user_repository = component "User Repository" "Handles user data access." "Python"{
                    tags "Python"
                }
                fastapi_health_router = component "Health Router" "Exposes liveness and readiness probes." "FastAPI"{
                    tags "FastAPI"
                }
                fastapi_schema_layer = component "Schemas" "Defines request and response models." "Pydantic"{
                    tags "Pydantic"
                }
                fastapi_db_session = component "DB Session" "Manages async database sessions." "SQLAlchemy"{
                    tags "SQLAlchemy"
                }
                fastapi_security_helper = component "Security Helper" "Handles JWT encoding/decoding." "Python"{
                    tags "Python"
                }
                fastapi_logging_setup = component "Logging Setup" "Configures structlog handlers." "Python"{
                    tags "Python"
                }

                fastapi_api_router -> fastapi_auth_service "Calls" "In-process"
                fastapi_api_router -> fastapi_post_service "Calls" "In-process"
                fastapi_api_router -> fastapi_user_service "Calls" "In-process"
                fastapi_api_router -> fastapi_health_router "Calls" "In-process"
                fastapi_api_router -> fastapi_schema_layer "Validates with" "In-process"
                fastapi_api_router -> fastapi_logging_setup "Initializes and logs via" "In-process"

                fastapi_auth_service -> fastapi_security_helper "Uses" "In-process"
                fastapi_post_service -> fastapi_post_repository "Uses" "In-process"
                fastapi_user_service -> fastapi_user_repository "Uses" "In-process"

                fastapi_post_repository -> fastapi_db_session "Executes queries via" "In-process"
                fastapi_user_repository -> fastapi_db_session "Executes queries via" "In-process"
            }

            django_service = container "Django Service" "Serves Django web application." "Python, Django" {
                django_users_app = component "Users App" "Manages user accounts." "Django App"{
                    tags "Django"
                }
                django_posts_app = component "Posts App" "Manages posts and related content." "Django App"{
                    tags "Django"
                }
                django_auth_app = component "Auth App" "Handles authentication endpoints." "Django App"{
                    tags "Django"
                }
                django_health_app = component "Health App" "Exposes health check endpoints." "Django App"{
                    tags "Django"
                }
                django_core_settings = component "Core Settings" "Django configuration and environment loading." "Python"{
                    tags "Python"
                }
                django_core_authentication = component "Core Authentication" "Custom JWT authentication backend." "Python"{
                    tags "Python"
                }
                django_core_exceptions = component "Core Exceptions" "Global exception handling." "Python"{
                    tags "Python"
                }
                django_core_urls = component "Core URLs" "Django URL routing and schema views." "Python"{
                    tags "Python"
                }
                django_core_wsgi = component "Core WSGI" "WSGI application entry point." "Python"{
                    tags "Python"
                }
                django_users_repository = component "Users Repository" "Handles user data access." "Python"{
                    tags "Python"
                }
                django_posts_repository = component "Posts Repository" "Handles post data access." "Python"{
                    tags "Python"
                }
                django_users_service = component "Users Service" "Implements user business logic." "Python"{
                    tags "Python"
                }
                django_posts_service = component "Posts Service" "Implements post business logic." "Python"{
                    tags "Python"
                }
                django_auth_service = component "Auth Service" "Handles JWT token creation." "Python"{
                    tags "Python"
                }
                django_logging_setup = component "Logging Setup" "Configures structlog handlers." "Python"{
                    tags "Python"
                }

                django_core_wsgi -> django_core_settings "Loads settings on startup" "In-process"
                django_core_wsgi -> django_core_urls "Dispatches HTTP requests to" "In-process"

                django_core_settings -> django_logging_setup "Configures" "In-process"

                django_core_urls -> django_users_app "Routes user requests to" "In-process"
                django_core_urls -> django_posts_app "Routes post requests to" "In-process"
                django_core_urls -> django_auth_app "Routes auth requests to" "In-process"
                django_core_urls -> django_health_app "Routes health check requests to" "In-process"

                django_auth_app -> django_auth_service "Calls" "In-process"
                django_auth_app -> django_core_authentication "Authenticates with" "In-process"

                django_users_app -> django_users_service "Calls" "In-process"
                django_users_app -> django_users_repository "Uses" "In-process"
                django_users_app -> django_core_exceptions "Delegates error handling to" "In-process"

                django_posts_app -> django_posts_service "Calls" "In-process"
                django_posts_app -> django_posts_repository "Uses" "In-process"
                django_posts_app -> django_users_app "Provides user references for posts" "Django ORM"
                django_posts_app -> django_core_exceptions "Delegates error handling to" "In-process"

                django_users_service -> django_users_repository "Uses" "In-process"
                django_posts_service -> django_posts_repository "Uses" "In-process"
            }

            fastapi_database = container "FastAPI Database" "Stores FastAPI application data." "SQLite" {
                tags "Database"
            }
            django_database = container "Django Database" "Stores Django application data." "SQLite" {
                tags "Database"
            }
            prometheus = container "Prometheus" "Metrics collection and alerting." "Prometheus"{
                tags "Prometheus"
            }
            grafana = container "Grafana" "Metrics visualization and dashboards." "Grafana"{
                tags "Grafana"
            }
            tempo = container "Tempo" "Distributed tracing backend." "Tempo"{
                tags "Tempo"
            }
            filebeat = container "Filebeat" "Log shipping and forwarding." "Filebeat"{
                tags "Filebeat"
            }            
            elasticsearch = container "Elasticsearch" "Log indexing and search." "Elasticsearch"{
                tags "Elastic"
            }
            kibana = container "Kibana" "Log visualization and exploration." "Kibana"{
                tags "Kibana"
            }

            fastapi_service.fastapi_db_session -> fastapi_database "Reads from, writes to, and migrates via Alembic" "SQL"
            django_service.django_users_repository -> django_database "Reads from and writes to" "SQL"
            django_service.django_posts_repository -> django_database "Reads from and writes to" "SQL"
        }

        k3d_cluster = softwareSystem "k3d Cluster" "Local Kubernetes runtime environment." "External"
        argo_cd = softwareSystem "ArgoCD" "Continuously deploys the platform from Git using GitOps." "External"
        vault = softwareSystem "HashiCorp Vault" "Stores and injects application secrets." "External"
        monitoring_system = softwareSystem "Monitoring Stack" "Collects and visualises metrics from the platform using Prometheus, Grafana, and Tempo." "External"
        logging_system = softwareSystem "Logging Stack" "Collects and indexes application and container logs using Elasticsearch and Kibana." "External"
        sonarqube = softwareSystem "SonarQube" "Analyses code quality and test coverage." "External"
        tilt = softwareSystem "Tilt" "Local development environment orchestrator for live-update deployments." "External"
        task_runner = softwareSystem "Task" "Cross-platform task runner for automation scripts." "External"

        developer -> platform "Develops and runs locally" "Task, Tilt, kubectl, Kustomize, Helm"
        developer -> tilt "Configures live-update deployments" "CLI"
        developer -> task_runner "Executes automation workflows" "CLI"
        developer -> argo_cd "Manages GitOps pipelines" "CLI"

        platform -> k3d_cluster "Runs on" "Docker"
        platform.fastapi_service -> vault "Reads secrets from" "HTTPS"
        platform.django_service -> vault "Reads secrets from" "HTTPS"
        platform.fastapi_service -> monitoring_system "Sends metrics to" "HTTP"
        platform.django_service -> monitoring_system "Sends metrics to" "HTTP"
        platform.fastapi_service -> logging_system "Sends logs to" "Filebeat"
        platform.django_service -> logging_system "Sends logs to" "Filebeat"
        platform -> sonarqube "Sends source code for analysis to" "HTTPS"
        argo_cd -> platform "Deploys" "Helm"
        tilt -> platform "Deploys with live-update" "HTTP"
        task_runner -> platform "Automates workflows for" "CLI"

        platform.filebeat -> platform.elasticsearch "Forwards logs to" "HTTP"
        platform.filebeat -> platform.kibana "Configures dashboards with" "HTTP"
        platform.prometheus -> platform.grafana "Sends metrics to" "HTTP"
        platform.tempo -> platform.grafana "Sends traces to" "HTTP"
        platform.kibana -> platform.elasticsearch "Queries logs from" "HTTP"
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
                background #7738A1
                stroke #5B2B77
                strokeWidth 3
            }

            element "Component" {
                shape RoundedBox
                background #A03E3E
                stroke #6E201E
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

            element "Python" {
                icon "icons/Python.png"
            }

            element "FastAPI" {
                icon "icons/FastAPI.png"
            }

            element "Django" {
                icon "icons/Django.png"
            }

            element "Pydantic" {
                icon "icons/Pydantic.png"
            }

            element "Database" {
                icon "icons/Database.png"
            }

            element "SQLAlchemy" {
                icon "icons/SQLAlchemy.png"
            }

            element "Prometheus" {
                icon "icons/Prometheus.png"
            }

            element "Grafana" {
                icon "icons/Grafana.png"
            }

            element "Tempo" {
                icon "icons/Tempo.png"
            }

            element "Filebeat" {
                icon "icons/Filebeat.jpg"
            }

            element "Elastic" {
                icon "icons/Elastic.png"
            }

            element "Kibana" {
                icon "icons/Kibana.png"
            }

            element "CLI" {
                icon "icons/CLI.png"
            }

            element "Docker" {
                icon "icons/Docker.png"
            }

            element "Helm" {
                icon "icons/Helm.png"
            }

            element "HTTPS" {
                icon "icons/Https.png"
            }

            element "HTTP" {
                icon "icons/Http.png"
            }
        }
    }
}
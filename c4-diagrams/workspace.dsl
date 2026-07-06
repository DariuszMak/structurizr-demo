workspace "ML Platform" "Machine learning model serving platform." {

    !identifiers hierarchical
    !impliedRelationships false

    configuration {
        scope softwaresystem
    }

    model {
        customer = person "Customer" "Customer using the app" "External"
        data_scientist = person "Data Scientist" "Data scientist developing a machine learning model" "External"
        
        ml_platform = softwareSystem "ML Platform" "Machine learning model serving platform exposing models over REST and Kafka." {

            !docs ./docs
            !adrs ./decisions

            sidecar = container "Model sidecar application" "Ambassador sidecar for ML model" "Python, Flask" {
                streaming_module = component "Streaming module" "Reads prediction requests from Kafka topic and returns predictions to another." {
                }
    
                rest_module = component "REST module" "Receives prediction requests and returns response."
            }
            
            model_container = container "Model" "Machine learning model serving predictions" "Python" {
                ml_platform.sidecar -> this "Sends request to" "GRPC"
                model_module = component "Python model implementation" "Python Model class implementing __init__ and predict methods" {
                    data_scientist -> this "Develops" "IDE"
                }
    
                api_module = component "Model wrapper" "Python model wrapper serving predictions using a Dataframe => Dataframe interface." {
                    ml_platform.sidecar.rest_module -> this "Requests prediction from" "GRPC"
                    ml_platform.sidecar.streaming_module -> this "Requests prediction from" "GRPC"
                    this -> model_module "Initializes and calls model." "In-process"
                }
            }
        }
        
        logging = softwareSystem "Log aggregator" "Logging system based on ELK stack" "External" {
            ml_platform.sidecar -> this "Sends logs to" "Kafka"
            ml_platform.model_container -> this "Sends logs to" "Filebeat"
        }
        
        RTK = softwareSystem "Metrics collector" "Reliability toolkit supporting web application monitoring" "External" {
            ml_platform.sidecar -> this "Exposes metrics to" "HTTP"
        }

        rest_client = softwareSystem "Backend application A" "Any application that makes use of a REST machine learning model" "External" {
            this -> ml_platform.sidecar.rest_module "Requests prediction from" "HTTP"
        }
        
        streaming_client = softwareSystem "Backend application B" "Any application that makes use of a streaming machine learning model" "External" {
            this -> ml_platform.sidecar.streaming_module "Sends prediction to" "Kafka"
        }
        
        client_fe = softwareSystem "FE application" "Client frontend web application" "External,FE" {
            this -> rest_client "Requests information from" "HTTP"
            this -> streaming_client "Requests information from" "HTTP"
            customer -> this "Uses" "HTTPS"
        }

        rest_client -> ml_platform "Requests prediction from" "HTTP"
        streaming_client -> ml_platform "Sends prediction to" "Kafka"
    }

    views {
        systemContext ml_platform "SystemContext-MLPlatform" {
            include *
            include customer
            include client_fe
            autolayout lr
        }

        container ml_platform "Container-MLPlatform" {
            include *
            autolayout lr
        }

        component ml_platform.model_container "Component-Model" {
            include *
            autolayout lr
        }

        component ml_platform.sidecar "Component-Sidecar" {
            include *
            autolayout lr
        }
                
        styles {
            element "External" {
                background #cccccc
            }
            element "FE" {
                shape WebBrowser
            }
        }
    }
}

workspace "Python S3 LocalStack Demo" "Simple Python application demonstrating boto3 integration with LocalStack and Terraform for local development." {
    !identifiers hierarchical
    !impliedRelationships false

    configuration {
        scope softwaresystem
    }

    model {

        developer = person "Developer" "Engineer running and deploying the local S3 demo application." "External"

        app = softwareSystem "Python S3 Demo" "Local Python application using boto3 to interact with a simulated S3 environment, orchestrated by Task and UV." "Python 3.14, UV, boto3" {

            main_app = component "Main Application" "Entry point, loads environment, orchestrates S3 operations, and handles execution flow." "Python, src/main.py"{
                tags "Python"
            }

            s3_client_module = component "S3 Client Module" "Wraps boto3 client, manages S3Settings dataclass, and implements upload, download, list, and delete operations." "Python, src/s3_client.py"{
                tags "Python"
            }

            env_loader_module = component "Env Loader Module" "Parses .dev.env file, handles key-value extraction, and populates os.environ safely." "Python, src/env_loader.py"{
                tags "Python"
            }

            config_layer = component "Configuration Layer" "Manages pyproject.toml, mypy, ruff, coverage, and dependency definitions." "TOML, YAML"{
                tags "Configuration"
            }

            test_suite = component "Test Suite" "Unit and integration tests using pytest and moto, covering client, loader, and main logic." "Python, tests/"{
                tags "Testing"
            }

            conftest_module = component "Test Configuration" "Provides s3_settings and s3_client fixtures with moto mock_aws context." "Python, tests/conftest.py"{
                tags "Testing"
            }

            test_env_loader = component "Env Loader Tests" "Validates variable loading, comment skipping, override prevention, and logging." "Python, tests/test_env_loader.py"{
                tags "Testing"
            }

            test_main = component "Main Tests" "Validates run() execution flow, bucket existence checks, and upload logic." "Python, tests/test_main.py"{
                tags "Testing"
            }

            test_s3_client = component "S3 Client Tests" "Validates from_env defaults/overrides, bucket_exists, upload, list, download, delete, and prefix filtering." "Python, tests/test_s3_client.py"{
                tags "Testing"
            }

            static_analysis = component "Static Analysis" "Runs ruff, mypy, semgrep, vulture, lint-imports, pip-audit, and coverage reporting." "Python, scripts/format_and_lint.ps1"{
                tags "DevOps"
            }

            task_runner = component "Task Runner" "Orchestrates setup, terraform, tests, cleanup, and diagram generation via Taskfile.yml." "YAML, Taskfile.yml"{
                tags "DevOps"
            }

            task_cleanup = component "Cleanup Task" "Stops Docker containers, kills ports, cleans uv cache, resets git, and removes volumes." "PowerShell, tasks/cleanup.ps1"{
                tags "DevOps"
            }

            task_dev_env = component "Dev Environment Task" "Installs Python 3.14, pins version, and syncs dependencies with uv." "PowerShell, tasks/dev_uv_environment.ps1"{
                tags "DevOps"
            }

            task_diagrams = component "Diagram Generation Task" "Generates pydeps SVG dependency graphs and applies dark theme styling." "PowerShell, tasks/generate_diagrams.ps1"{
                tags "DevOps"
            }

            task_localstack = component "LocalStack Terraform Task" "Starts LocalStack Docker container, waits for S3 health, runs terraform init/apply, and uploads test file." "PowerShell, tasks/localstack_terraform.ps1"{
                tags "DevOps"
            }

            task_run = component "Run Application Task" "Executes the main Python script using uv." "PowerShell, tasks/run_native_dev_application.ps1"{
                tags "DevOps"
            }

            task_static = component "Static Analysis Task" "Triggers format_and_lint and pytest with coverage, opens HTML report." "PowerShell, tasks/static_analysis_and_tests.ps1"{
                tags "DevOps"
            }

            main_app -> env_loader_module "Initializes and loads" "In-process"
            main_app -> s3_client_module "Instantiates and calls" "In-process"
            s3_client_module -> config_layer "Reads boto3 configuration" "In-process"
            test_suite -> conftest_module "Uses fixtures from" "In-process"
            test_suite -> test_env_loader "Validates" "In-process"
            test_suite -> test_main "Validates" "In-process"
            test_suite -> test_s3_client "Validates" "In-process"
            test_env_loader -> env_loader_module "Tests" "In-process"
            test_main -> main_app "Tests" "In-process"
            test_main -> s3_client_module "Tests" "In-process"
            test_s3_client -> s3_client_module "Tests" "In-process"
            test_s3_client -> conftest_module "Uses fixtures from" "In-process"
            static_analysis -> main_app "Analyzes" "CLI"
            static_analysis -> s3_client_module "Analyzes" "CLI"
            static_analysis -> env_loader_module "Analyzes" "CLI"
            static_analysis -> test_suite "Analyzes" "CLI"
            task_runner -> task_cleanup "Depends on and executes" "CLI"
            task_runner -> task_dev_env "Depends on and executes" "CLI"
            task_runner -> task_localstack "Depends on and executes" "CLI"
            task_runner -> task_static "Depends on and executes" "CLI"
            task_runner -> task_run "Depends on and executes" "CLI"
            task_runner -> task_diagrams "Depends on and executes" "CLI"
            task_cleanup -> git_repo "Resets and cleans" "CLI"
            task_cleanup -> docker_engine "Stops and prunes" "CLI"
            task_cleanup -> uv_package_manager "Cleans cache" "CLI"
            task_dev_env -> uv_package_manager "Installs and syncs" "CLI"
            task_localstack -> docker_engine "Starts container" "CLI"
            task_localstack -> terraform_infra "Runs init/apply" "CLI"
            task_localstack -> aws_cli "Uploads file" "CLI"
            task_localstack -> localstack_service "Waits for health" "HTTP"
            task_run -> main_app "Executes" "CLI"
            task_run -> uv_package_manager "Runs script" "CLI"
            task_static -> static_analysis "Executes" "CLI"
            task_static -> test_suite "Executes" "CLI"
            task_static -> coverage_engine "Generates report" "CLI"

            tags "Python"
        }

        terraform_infra = container "Terraform Infrastructure" "Defines and provisions the S3 bucket resource using HashiCorp provider." "Terraform, main.tf"{
            tags "Infrastructure"
        }

        localstack_service = container "LocalStack Service" "Local cloud service emulator running S3 on port 4566." "Docker, LocalStack"{
            tags "Local Environment"
        }

        docker_engine = container "Docker Engine" "Containers the LocalStack service and manages lifecycle." "Docker"{
            tags "Local Environment"
        }

        uv_package_manager = container "UV Package Manager" "Handles Python dependency resolution, environment creation, and execution." "UV"{
            tags "Tooling"
        }

        aws_cli = container "AWS CLI" "Interacts with LocalStack endpoints for S3 operations and file transfers." "AWS CLI"{
            tags "Tooling"
        }

        git_repo = container "Git Repository" "Manages version control, tracks source, configs, and tasks." "Git"{
            tags "Tooling"
        }

        coverage_engine = container "Coverage Engine" "Measures test coverage and generates XML/HTML reports." "Python, coverage"{
            tags "Tooling"
        }

        app.main_app -> localstack_service "Sends S3 requests to" "HTTP/HTTPS"
        app.s3_client_module -> localstack_service "Sends S3 requests to" "HTTP/HTTPS"
        app.terraform_infra -> localstack_service "Provisions bucket into" "AWS API"
        app.task_runner -> uv_package_manager "Manages dependencies via" "CLI"
        app.task_runner -> terraform_infra "Runs init/apply via" "CLI"
        app.task_runner -> aws_cli "Runs commands via" "CLI"
        app.task_runner -> docker_engine "Starts container via" "Docker CLI"
        app.task_runner -> git_repo "Tracks source via" "Git CLI"
        app.task_runner -> coverage_engine "Generates reports via" "CLI"
        app.static_analysis -> git_repo "Reads source from" "CLI"

        developer -> app "Develops, tests, and runs" "Task, UV, VS Code"
        developer -> terraform_infra "Manages infrastructure" "Terraform CLI"
        developer -> localstack_service "Deploys and monitors" "Docker CLI"
        developer -> uv_package_manager "Configures and syncs" "UV CLI"
        developer -> aws_cli "Interacts with services" "AWS CLI"
        developer -> git_repo "Commits and manages" "Git CLI"

        tags "Local Development"
    }

    views {

        systemLandscape "SystemLandscape" {
            include *
            autolayout lr
        }

        systemContext app "SystemContext" {
            include *
            autolayout lr
        }

        container app "Containers" {
            include *
            autolayout lr
        }

        component app "Components" {
            include *
            autolayout lr
        }

        workflow "DevelopmentWorkflow" {
            developer -> task_runner "Executes full-dev-native" "CLI"
            task_runner -> task_dev_env "Installs Python 3.14 and syncs deps" "CLI"
            task_runner -> task_localstack "Starts container and waits for S3" "Docker/HTTP"
            task_runner -> terraform_infra "Applies Terraform state" "Terraform CLI"
            task_runner -> task_static "Runs ruff, mypy, semgrep, coverage" "CLI"
            task_runner -> test_suite "Runs pytest with coverage" "CLI"
            task_runner -> task_diagrams "Generates pydeps SVGs" "CLI"
            task_runner -> task_run "Executes application" "UV/Python"
            task_runner -> task_cleanup "Cleans environment" "Docker/UV/Git"
            task_cleanup -> docker_engine "Stops and prunes containers" "Docker CLI"
            task_cleanup -> uv_package_manager "Cleans cache" "UV CLI"
            task_cleanup -> git_repo "Resets and cleans" "Git CLI"
            task_localstack -> docker_engine "Pulls and runs localstack container" "Docker CLI"
            task_localstack -> localstack_service "Waits for health endpoint" "HTTP"
            task_localstack -> terraform_infra "Runs init and apply" "Terraform CLI"
            task_localstack -> aws_cli "Copies test.txt to S3" "AWS CLI"
            task_localstack -> app.main_app "Opens browser for bucket" "HTTP"
            task_static -> static_analysis "Runs format and lint checks" "CLI"
            task_static -> coverage_engine "Generates XML and HTML reports" "CLI"
            task_static -> test_suite "Runs unit and integration tests" "CLI"
            task_diagrams -> app.main_app "Generates dependency graph" "CLI"
            task_diagrams -> app.s3_client_module "Generates dependency graph" "CLI"
            task_diagrams -> app.env_loader_module "Generates dependency graph" "CLI"
            task_diagrams -> app.test_suite "Generates dependency graph" "CLI"
            task_diagrams -> coverage_engine "Applies dark theme to SVGs" "PowerShell"
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

            element "Relationship" {
                thickness 2
                color #EEEA1E
                dashed false
                routing Orthogonal
                fontSize 16
            }

            element "Async" {
                dashed true
                color #F59E0B
            }

            element "Python" {
                icon "icons/Python.png"
            }

            element "Terraform" {
                icon "icons/Terraform.png"
            }

            element "LocalStack" {
                icon "icons/LocalStack.png"
            }

            element "Docker" {
                icon "icons/Docker.png"
            }

            element "UV" {
                icon "icons/UV.png"
            }

            element "AWS" {
                icon "icons/AWS.png"
            }

            element "Pytest" {
                icon "icons/Pytest.png"
            }

            element "Ruff" {
                icon "icons/Ruff.png"
            }

            element "MyPy" {
                icon "icons/MyPy.png"
            }

            element "Semgrep" {
                icon "icons/Semgrep.png"
            }

            element "Task" {
                icon "icons/Task.png"
            }

            element "CLI" {
                icon "icons/CLI.png"
            }

            element "HTTP" {
                icon "icons/Http.png"
            }

            element "HTTPS" {
                icon "icons/Https.png"
            }

            element "TOML" {
                icon "icons/TOML.png"
            }

            element "YAML" {
                icon "icons/YAML.png"
            }

            element "Git" {
                icon "icons/Git.png"
            }

            element "Coverage" {
                icon "icons/Coverage.png"
            }
        }
    }
}
# # #!/bin/bash

# # set -e

# # echo "--------------Initializing the folder...----------------"
# # time terraform init -backend-config=environments/development/backend.tfvars

# # echo "--------------Format Config files-----------------------"
# # time terraform fmt

# # echo "--------------Validate Config files---------------------"
# # time terraform validate

# # echo "--------------Plan the changes--------------------------"
# # time terraform plan -var-file=environments/development/main.tfvars

# # echo "---------------Apply the changes------------------------"
# # time terraform apply -var-file=environments/development/main.tfvars

# # echo "---------------Destroy the changes------------------------"
# # time terraform destroy -var-file=environments/development/main.tfvars
# #!/bin/bash

# set -e

# # Shell script to run terraform apply or destroy
# # Usage: ./terraform_eks_addons.sh
# # Prompts for 'apply' or 'destroy' and executes with timing

# # Configuration
# TF_VAR_FILE="environments/development/main.tfvars"
# TF_BACKEND_CONFIG="environments/development/backend.tfvars"
# CLUSTER_NAME="dev-eks"

# # Colors for output
# RED='\033[0;31m'
# GREEN='\033[0;32m'
# YELLOW='\033[1;33m'
# NC='\033[0m' # No Color

# # Function to check prerequisites
# check_prerequisites() {
#     echo -e "${YELLOW}Checking prerequisites...${NC}"
#     command -v terraform >/dev/null 2>&1 || { echo -e "${RED}Terraform not found. Please install Terraform.${NC}"; exit 1; }
#     command -v aws >/dev/null 2>&1 || { echo -e "${RED}AWS CLI not found. Please install AWS CLI.${NC}"; exit 1; }
#     command -v kubectl >/dev/null 2>&1 || { echo -e "${RED}kubectl not found. Please install kubectl.${NC}"; exit 1; }

#     # Check AWS CLI configuration
#     aws sts get-caller-identity >/dev/null 2>&1 || { echo -e "${RED}AWS CLI not configured. Run 'aws configure' or set credentials.${NC}"; exit 1; }

#     # Check Terraform variable and backend files
#     if [ ! -f "$TF_VAR_FILE" ]; then
#         echo -e "${RED}Variable file $TF_VAR_FILE not found.${NC}"
#         exit 1
#     fi
#     if [ ! -f "$TF_BACKEND_CONFIG" ]; then
#         echo -e "${RED}Backend config file $TF_BACKEND_CONFIG not found.${NC}"
#         exit 1
#     fi
# }

# # Function to prompt for apply or destroy
# prompt_action() {
#     echo -e "${YELLOW}Choose an action: [apply/destroy]${NC}"
#     read -r action
#     case "$action" in
#         apply|destroy)
#             echo -e "${GREEN}Selected action: $action${NC}"
#             ;;
#         *)
#             echo -e "${RED}Invalid action. Please choose 'apply' or 'destroy'.${NC}"
#             exit 1
#             ;;
#     esac
# }

# # Function to run Terraform commands
# run_terraform() {
#     echo -e "${YELLOW}--------------Initializing the folder...----------------${NC}"
#     time terraform init -backend-config="$TF_BACKEND_CONFIG"

#     echo -e "${YELLOW}--------------Formatting config files------------------${NC}"
#     time terraform fmt

#     echo -e "${YELLOW}--------------Validating config files-----------------${NC}"
#     time terraform validate

#     echo -e "${YELLOW}--------------Planning the changes--------------------${NC}"
#     time terraform plan -var-file="$TF_VAR_FILE"

#     if [ "$action" = "apply" ]; then
#         echo -e "${YELLOW}---------------Applying the changes-------------------${NC}"
#         time terraform apply -var-file="$TF_VAR_FILE" -auto-approve
#     else
#         echo -e "${YELLOW}---------------Destroying the changes-----------------${NC}"
#         time terraform destroy -var-file="$TF_VAR_FILE" -auto-approve
#     fi
# }

# # Main execution
# echo -e "${GREEN}Starting Terraform${NC}"
# check_prerequisites
# prompt_action
# run_terraform
# echo -e "${GREEN}Script completed successfully!${NC}"

#!/bin/bash

set -e

# Shell script to run terraform apply or destroy after showing plan
# Usage: ./terraform_eks_addons.sh

# Configuration
TF_VAR_FILE="environments/development/main.tfvars"
TF_BACKEND_CONFIG="environments/development/backend.tfvars"
CLUSTER_NAME="dev-eks"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to check prerequisites
check_prerequisites() {
    for cmd in terraform aws; do
        if ! command -v $cmd &> /dev/null; then
            echo -e "${RED}Error:${NC} $cmd is not installed. Please install it first."
            exit 1
        fi
    done
}

# Function to initialize terraform
initialize_terraform() {
    echo -e "${YELLOW}Initializing Terraform...${NC}"
    terraform init -backend-config="$TF_BACKEND_CONFIG"
}

# Function to format and validate
format_and_validate() {
    echo -e "${YELLOW}Formatting Terraform files...${NC}"
    terraform fmt

    echo -e "${YELLOW}Validating Terraform files...${NC}"
    terraform validate
}

# Function to show plan
show_plan() {
    echo -e "${YELLOW}Generating Terraform plan...${NC}"
    terraform plan -var-file="$TF_VAR_FILE"
}

# Main
check_prerequisites
initialize_terraform
format_and_validate

echo -e "${YELLOW}Do you want to 'apply' or 'destroy' the infrastructure?${NC}"
read -rp "(apply/destroy): " action

if [[ "$action" == "apply" || "$action" == "destroy" ]]; then
    show_plan

    echo -e "${YELLOW}Do you want to proceed with '$action'? (yes/no)${NC}"
    read -rp "Type 'yes' to continue: " confirm

    if [[ "$confirm" == "yes" ]]; then
        echo -e "${GREEN}Proceeding with Terraform $action...${NC}"
        if [[ "$action" == "apply" ]]; then
            time terraform apply -var-file="$TF_VAR_FILE" -auto-approve
        else
            time terraform destroy -var-file="$TF_VAR_FILE" -auto-approve
        fi
    else
        echo -e "${RED}Aborting as per user input.${NC}"
        exit 0
    fi
else
    echo -e "${RED}Invalid action. Please choose 'apply' or 'destroy'.${NC}"
    exit 1
fi

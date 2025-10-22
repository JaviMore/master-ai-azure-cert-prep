## Check VM using Azure CLI

```bash
# Login to Azure using device code authentication
az login --use-device-code

# List azure vm 
az vm list -d --output table

```

## How to use the script

```bash
# Login to Azure using device code authentication
az login --use-device-code

# Create a virtual environment and activate it
python -m venv .venv
source .venv/bin/activate

# Install required Azure SDK packages
pip install azure-identity azure-mgmt-compute azure-mgmt-resource

# Execute script
python3 list_vm_azure.py
```
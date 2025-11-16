from azure.identity import DefaultAzureCredential
from azure.mgmt.compute import ComputeManagementClient
from azure.mgmt.resource import SubscriptionClient

def get_default_subscription_id(credential):
    """Retrieve the first available Azure subscription ID."""
    subscription_client = SubscriptionClient(credential)
    subscriptions = list(subscription_client.subscriptions.list())

    if not subscriptions:
        raise Exception("No subscriptions found for this account.")
    
    # You can adjust this if you want to select a specific subscription
    return subscriptions[0].subscription_id

def list_virtual_machines():
    """List all virtual machines across the default Azure subscription."""
    credential = DefaultAzureCredential()
    subscription_id = get_default_subscription_id(credential)

    compute_client = ComputeManagementClient(credential, subscription_id)

    print(f"🔹 Listing virtual machines in subscription: {subscription_id}")
    print("-" * 90)

    for vm in compute_client.virtual_machines.list_all():
        vm_name = vm.name
        resource_group = vm.id.split("/")[4]
        location = vm.location

        # Try to retrieve power state
        try:
            instance = compute_client.virtual_machines.instance_view(resource_group, vm_name)
            power_states = [s.display_status for s in instance.statuses if "PowerState" in s.code]
            power_state = power_states[0] if power_states else "Unknown"
        except Exception:
            power_state = "Not available"

        print(f"🖥️  Name: {vm_name}")
        print(f"📦  Resource group: {resource_group}")
        print(f"🌍  Location: {location}")
        print(f"⚙️  State: {power_state}")
        print("-" * 90)

if __name__ == "__main__":
    list_virtual_machines()

from azure.cosmos import CosmosClient
from dotenv import load_dotenv
import json
import os



# Config
load_dotenv()
endpoint = os.getenv("COSMOS_ENDPOINT")
key = os.getenv("COSMOS_KEY")
database_name = os.getenv("COSMOS_DB")
container_name = os.getenv("COSMOS_CONTAINER")



# Connect
client = CosmosClient(endpoint, key)
db = client.get_database_client(database_name)
container = db.get_container_client(container_name)

# Load JSON array
with open("cosmos-orders.json", "r", encoding="utf-8") as f:
    items = json.load(f)

for item in items:
    container.create_item(body=item)
    print(f"Inserted {item['id']}")

print("✅ All items inserted.")

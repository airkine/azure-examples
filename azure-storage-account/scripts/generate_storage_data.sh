#!/bin/bash

set -euo pipefail

# === Configuration ===
STORAGE_ACCOUNT_NAME="stracce5chfc"
RESOURCE_GROUP="rg-storage-e5chfc"
LOCATION="eastus2"

# Get storage account key
ACCOUNT_KEY=$(az storage account keys list --account-name "$STORAGE_ACCOUNT_NAME" \
  --resource-group "$RESOURCE_GROUP" --query "[0].value" -o tsv)

# === Generate random names ===
RAND_SUFFIX=$RANDOM
BLOB_CONTAINER="testblob$RAND_SUFFIX"
FILE_SHARE="testshare$RAND_SUFFIX"
TABLE_NAME="TestTable$RAND_SUFFIX"
QUEUE_NAME="testqueue$RAND_SUFFIX"

# === Blob Storage ===
echo "Creating Blob container and uploading a random file..."
az storage container create --name "$BLOB_CONTAINER" \
  --account-name "$STORAGE_ACCOUNT_NAME" --account-key "$ACCOUNT_KEY"

echo "Random blob content" > random-blob.txt
az storage blob upload --container-name "$BLOB_CONTAINER" --name "random-blob.txt" \
  --file "random-blob.txt" --account-name "$STORAGE_ACCOUNT_NAME" --account-key "$ACCOUNT_KEY"

# === File Share ===
echo "Creating File Share and uploading a file..."
az storage share create --name "$FILE_SHARE" \
  --account-name "$STORAGE_ACCOUNT_NAME" --account-key "$ACCOUNT_KEY"

echo "File share content" > random-share.txt
az storage file upload --share-name "$FILE_SHARE" --source "random-share.txt" \
  --path "random-share.txt" --account-name "$STORAGE_ACCOUNT_NAME" --account-key "$ACCOUNT_KEY"

# === Table Storage ===
echo "Creating Table and inserting an entity..."
az storage table create --name "$TABLE_NAME" \
  --account-name "$STORAGE_ACCOUNT_NAME" --account-key "$ACCOUNT_KEY"

az storage entity insert --table-name "$TABLE_NAME" \
  --entity PartitionKey="testpart" RowKey="row$RAND_SUFFIX" Name="TestName" \
  Value="$RANDOM" --account-name "$STORAGE_ACCOUNT_NAME" --account-key "$ACCOUNT_KEY"

# === Queue Storage ===
echo "Creating Queue and inserting a message..."
az storage queue create --name "$QUEUE_NAME" \
  --account-name "$STORAGE_ACCOUNT_NAME" --account-key "$ACCOUNT_KEY"

az storage message put --queue-name "$QUEUE_NAME" \
  --content "Test message $RANDOM" --account-name "$STORAGE_ACCOUNT_NAME" --account-key "$ACCOUNT_KEY"

# === Cleanup local temp files ===
rm -f random-blob.txt random-share.txt

# === Summary ===
echo -e "\n✅ Test data generated:"
echo " - Blob Container: $BLOB_CONTAINER"
echo " - File Share: $FILE_SHARE"
echo " - Table: $TABLE_NAME"
echo " - Queue: $QUEUE_NAME"

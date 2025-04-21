#!/bin/bash

# Path to backend.tf
BACKEND_FILE="./examples/eks-basic/backend.tf"

if [ ! -f "$BACKEND_FILE" ]; then
  echo "❌ backend.tf not found at: $BACKEND_FILE"
  exit 1
fi

# Extract values from backend.tf
BUCKET=$(grep 'bucket' "$BACKEND_FILE" | awk -F'"' '{print $2}')
TABLE=$(grep 'dynamodb_table' "$BACKEND_FILE" | awk -F'"' '{print $2}')
REGION=$(grep 'region' "$BACKEND_FILE" | awk -F'"' '{print $2}')

echo "🕵️ Deleting backend resources from:"
echo "  - S3 Bucket: $BUCKET"
echo "  - DynamoDB Table: $TABLE"
echo "  - Region: $REGION"

# Delete all objects in the bucket (if it exists)
aws s3 ls "s3://$BUCKET" --region "$REGION" > /dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "🧹 Emptying bucket..."
  aws s3 rm "s3://$BUCKET" --recursive --region "$REGION"
  echo "🪣 Deleting bucket..."
  aws s3api delete-bucket --bucket "$BUCKET" --region "$REGION"
else
  echo "⚠️ S3 bucket does not exist: $BUCKET"
fi

# Delete the DynamoDB table (if it exists)
aws dynamodb describe-table --table-name "$TABLE" --region "$REGION" > /dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "🧺 Deleting DynamoDB table..."
  aws dynamodb delete-table --table-name "$TABLE" --region "$REGION"
else
  echo "⚠️ DynamoDB table does not exist: $TABLE"
fi

# Remove backend.tf
echo "🧽 Removing $BACKEND_FILE..."
rm -f "$BACKEND_FILE"

echo ""
echo "✅ Cleanup complete!"

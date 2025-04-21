#!/bin/bash

REGION="us-east-1"
TIMESTAMP=$(date +%Y%m%d%H%M%S)
BUCKET="terraform-state-eks-demo-${TIMESTAMP}"
TABLE="terraform-locks-${TIMESTAMP}"
BACKEND_FILE="./examples/eks-basic/backend.tf"

echo "Cleaning up existing backend.tf (if any)..."
rm -f "$BACKEND_FILE"

echo "Creating S3 bucket: $BUCKET in $REGION..."
if [ "$REGION" == "us-east-1" ]; then
  aws s3api create-bucket --bucket "$BUCKET" --region "$REGION"
else
  aws s3api create-bucket --bucket "$BUCKET" --region "$REGION" \
    --create-bucket-configuration LocationConstraint="$REGION"
fi

echo "Enabling versioning on bucket..."
aws s3api put-bucket-versioning --bucket "$BUCKET" \
  --versioning-configuration Status=Enabled

echo "Creating DynamoDB table: $TABLE..."
aws dynamodb create-table \
  --table-name "$TABLE" \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region "$REGION"

echo "Writing new backend.tf to $BACKEND_FILE..."
cat > "$BACKEND_FILE" <<EOF
terraform {
  backend "s3" {
    bucket         = "$BUCKET"
    key            = "eks/terraform.tfstate"
    region         = "$REGION"
    dynamodb_table = "$TABLE"
    encrypt        = true
  }
}
EOF

echo ""
echo "✅ Backend created and backend.tf written!"
echo "🔐 S3 Bucket: $BUCKET"
echo "🔐 DynamoDB Table: $TABLE"
echo ""

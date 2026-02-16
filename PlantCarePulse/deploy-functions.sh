#!/bin/bash

echo "========================================"
echo "Firebase Cloud Functions Deployment"
echo "========================================"
echo ""

echo "Step 1: Installing dependencies..."
cd functions
npm install
if [ $? -ne 0 ]; then
    echo "Error: Failed to install dependencies"
    exit 1
fi
echo "Dependencies installed successfully!"
echo ""

echo "Step 2: Deploying functions to Firebase..."
cd ..
firebase deploy --only functions
if [ $? -ne 0 ]; then
    echo "Error: Failed to deploy functions"
    exit 1
fi
echo ""

echo "========================================"
echo "Deployment completed successfully!"
echo "========================================"
echo ""
echo "Next steps:"
echo "1. Run the Flutter app"
echo "2. Navigate to 'Cloud Functions Demo'"
echo "3. Test the functions"
echo "4. Check logs: firebase functions:log"
echo ""

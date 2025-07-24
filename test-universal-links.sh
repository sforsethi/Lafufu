#!/bin/bash

echo "🧪 Testing Universal Links for Lafufu App"
echo "=========================================="

# Test different event IDs
test_links=(
    "https://lafufu.app/events/summer-sale-2024"
    "https://lafufu.app/events/holiday-collection"
    "https://lafufu.app/events/new-arrivals"
    "https://lafufu.app/events/test123"
)

echo "📱 Make sure your iOS Simulator is running..."
echo ""

for link in "${test_links[@]}"; do
    echo "🔗 Testing: $link"
    xcrun simctl openurl booted "$link"
    echo "✅ Link sent to simulator"
    echo "👀 Check Xcode console for debug output"
    echo ""
    sleep 2
done

echo "🎉 All test links sent!"
echo "Check your Xcode console for deep link debug messages."
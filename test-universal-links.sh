#\!/bin/bash

# Test Universal Links for Lafufu App
# Make sure your iOS Simulator is running before executing this script

echo "🎎 Testing Lafufu Deep Links..."
echo "================================"

# Check if simulator is running
if \! xcrun simctl list devices | grep -q "Booted"; then
    echo "❌ No iOS Simulator is currently running."
    echo "Please start the iOS Simulator and run your app first."
    exit 1
fi

echo "📱 Testing Custom URL Scheme Links..."
sleep 1

# Basic navigation links
echo "Testing: lafufu://home"
xcrun simctl openurl booted "lafufu://home"
sleep 2

echo "Testing: lafufu://explore"
xcrun simctl openurl booted "lafufu://explore"
sleep 2

echo "Testing: lafufu://collection"
xcrun simctl openurl booted "lafufu://collection"
sleep 2

echo "Testing: lafufu://wishlist"
xcrun simctl openurl booted "lafufu://wishlist"
sleep 2

# Toy detail links
echo "🎭 Testing Toy Detail Links..."
echo "Testing: lafufu://toy/labubu-fruit-series-1"
xcrun simctl openurl booted "lafufu://toy/labubu-fruit-series-1"
sleep 2

# Series links
echo "📚 Testing Series Links..."
echo "Testing: lafufu://series/fruit-series"
xcrun simctl openurl booted "lafufu://series/fruit-series"
sleep 2

# Event links
echo "🎉 Testing Event Links..."
echo "Testing: lafufu://event/summer-sale-2024"
xcrun simctl openurl booted "lafufu://event/summer-sale-2024"
sleep 2

echo "Testing: lafufu://event/holiday-collection"
xcrun simctl openurl booted "lafufu://event/holiday-collection"
sleep 2

# Universal links (these would work if your GitHub Pages is set up)
echo "🌐 Testing Universal Links..."
echo "Testing: https://sforsethi.github.io/Lafufu/events/summer-sale-2024"
xcrun simctl openurl booted "https://sforsethi.github.io/Lafufu/events/summer-sale-2024"
sleep 2

# Share and photo links
echo "📸 Testing Share & Photo Links..."
echo "Testing: lafufu://share"
xcrun simctl openurl booted "lafufu://share"
sleep 2

echo "Testing: lafufu://photos/labubu-fruit-series-1"
xcrun simctl openurl booted "lafufu://photos/labubu-fruit-series-1"
sleep 2

# Edge cases
echo "🧪 Testing Edge Cases..."
echo "Testing: lafufu://toy/nonexistent-toy"
xcrun simctl openurl booted "lafufu://toy/nonexistent-toy"
sleep 2

echo "Testing: lafufu://unknown-path"
xcrun simctl openurl booted "lafufu://unknown-path"
sleep 2

echo "✅ Deep link testing completed\!"
echo "Check your app and console logs for results."
EOF < /dev/null
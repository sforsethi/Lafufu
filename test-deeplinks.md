# Testing Lafufu Deep Links

## Quick Test Commands

With your app running in the iOS Simulator, run these commands in Terminal:

```bash
# Test navigation links
xcrun simctl openurl booted "lafufu://explore"
xcrun simctl openurl booted "lafufu://collection"
xcrun simctl openurl booted "lafufu://wishlist"

# Test event links
xcrun simctl openurl booted "lafufu://event/summer-sale-2024"
xcrun simctl openurl booted "lafufu://event/holiday-collection"

# Test toy detail
xcrun simctl openurl booted "lafufu://toy/labubu-fruit-series-1"

# Test series
xcrun simctl openurl booted "lafufu://series/fruit-series"
```

## Using the HTML Test Page

1. Open `quick-test.html` in Safari on your device/simulator
2. Tap any link to test

## What to Look For

✅ **Success indicators:**
- App opens from background
- Correct screen/sheet appears
- Haptic feedback occurs
- Console shows: "🔗 Processing deep link: lafufu://..."

❌ **If it doesn't work:**
- Check Xcode console for error messages
- Ensure the app is built with the latest changes
- Verify URL scheme is registered (it should be\!)

## Debug Output

Watch the Xcode console for messages like:
```
🔗 Deep link received in LafufuApp: lafufu://explore
🔗 Processing deep link: lafufu://explore
📍 Scheme: lafufu
📍 Host: none
📍 Path: /explore
✅ Navigating to explore
```

## Test All Features

1. **Navigation**: explore, collection, wishlist
2. **Content**: toy details, series pages
3. **Events**: App Store Connect events
4. **Special**: share cards, photo galleries
5. **Errors**: non-existent items (should show error view)
EOF < /dev/null
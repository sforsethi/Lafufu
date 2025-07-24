# Deep Link Testing Guide for Lafufu - App Store Connect Format

## 1. App Store Connect In-App Event URLs

### Universal Link Format (Primary)
```
https://lafufu.app/events/YOUR_EVENT_ID
```

### Examples:
- `https://lafufu.app/events/summer-sale-2024`
- `https://lafufu.app/events/holiday-collection`
- `https://lafufu.app/events/new-arrivals`

## 2. Testing Universal Links

### Simulator Testing
```bash
# Test App Store Connect format
xcrun simctl openurl booted "https://lafufu.app/events/summer-sale-2024"
```

### Notes App Method
1. Open Notes app
2. Type: `https://lafufu.app/events/summer-sale-2024`
3. Tap the link

### Messages App Method
1. Send yourself a message with: `https://lafufu.app/events/summer-sale-2024`
2. Tap the link in the message

### Safari Testing
1. Type: `https://lafufu.app/events/summer-sale-2024`
2. Long press the address bar
3. Select "Open in Lafufu" if available

## 3. Testing Custom URL Scheme (Fallback)

### Simulator Testing
```bash
# Legacy format still supported
xcrun simctl openurl booted "lafufu://event?id=test123"
```

### Device Testing via Safari
1. Open Safari on your iOS device
2. Type in address bar: `lafufu://event?id=test123`
3. Tap "Open" when prompted

## 3. Debug Deep Link Handling

Add this to your handleDeepLink function for testing:

```swift
private func handleDeepLink(_ url: URL) {
    print("🔗 Deep link received: \(url)")
    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { 
        print("❌ Failed to parse URL components")
        return 
    }
    
    print("📍 Path: \(components.path)")
    print("🔍 Query items: \(components.queryItems ?? [])")
    
    if components.path == "/event" {
        if let eventId = components.queryItems?.first(where: { $0.name == "id" })?.value {
            print("✅ Event ID found: \(eventId)")
            deepLinkEventId = eventId
            NotificationCenter.default.post(name: .navigateToEvent, object: eventId)
        } else {
            print("❌ No event ID found in query parameters")
        }
    } else {
        print("❌ Path doesn't match /event")
    }
}
```

## 4. Xcode Console Testing

1. Build and run your app
2. Background the app (home button/gesture)
3. Use any of the testing methods above
4. Check Xcode console for debug output

## 5. Quick Test URLs

- `lafufu://event?id=summer2024`
- `lafufu://event?id=holiday-sale`
- `https://lafufu.app/event?id=summer2024` (requires AASA file)

## 6. Testing Checklist

- [ ] App launches when tapped from backgrounded state
- [ ] App resumes when tapped from running state  
- [ ] Event ID is correctly parsed and logged
- [ ] Notification is posted with correct event ID
- [ ] Deep link works from Safari
- [ ] Deep link works from Messages
- [ ] Deep link works from Notes
- [ ] Custom scheme works: `lafufu://`
- [ ] Universal link works: `https://lafufu.app` (after AASA setup)
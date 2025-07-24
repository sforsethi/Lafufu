# GitHub Pages Setup for Universal Links

## Step 1: Create GitHub Repository

1. Go to [GitHub.com](https://github.com)
2. Create a new **public** repository named: `lafufu-events` (or any name)
3. ✅ Check "Add a README file"

## Step 2: Upload Files

Upload these files from `github-pages-setup/` folder to your GitHub repo:

```
your-repo/
├── index.html
├── apple-app-site-association
└── .well-known/
    └── apple-app-site-association
```

## Step 3: Enable GitHub Pages

1. Go to repository **Settings**
2. Scroll to **Pages** section
3. Under **Source**, select **Deploy from a branch**
4. Select **main** branch, **/ (root)** folder
5. Click **Save**

## Step 4: Update Your App

Replace `YOUR_GITHUB_USERNAME` in your app's entitlements file:

```xml
<string>applinks:YOUR_GITHUB_USERNAME.github.io</string>
```

**Example**: If your GitHub username is `johnsmith`, use:
```xml
<string>applinks:johnsmith.github.io</string>
```

## Step 5: Your Universal Links

After setup, your Universal Links will be:
- `https://YOUR_GITHUB_USERNAME.github.io/events/summer-sale-2024`
- `https://YOUR_GITHUB_USERNAME.github.io/events/holiday-collection`

## Step 6: App Store Connect

Use this format in App Store Connect:
```
https://YOUR_GITHUB_USERNAME.github.io/events/YOUR_EVENT_ID
```

## Step 7: Testing

### Simulator Test:
```bash
xcrun simctl openurl booted "https://YOUR_GITHUB_USERNAME.github.io/events/test123"
```

### Device Test:
1. Open Notes app
2. Type your GitHub Pages URL
3. Tap the link → should open your app!

## Important Notes

- GitHub Pages takes 5-10 minutes to go live
- Use your actual GitHub username
- Repository must be **public**
- AASA file must be accessible at both:
  - `https://USERNAME.github.io/apple-app-site-association`
  - `https://USERNAME.github.io/.well-known/apple-app-site-association`
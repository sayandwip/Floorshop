# SpeedMeter - iOS Internet Speed Monitor

Real-time internet speed on your iPhone's Dynamic Island, Lock Screen, and Home Screen Widget.

## One-Command Setup

### Prerequisites
Install **Xcode** from the App Store (free, ~12GB). Open it once after installing to accept the license.

### Setup
Open Terminal and run:

```bash
cd ~/Desktop/Cursor/Floorshop/internet\ speed/SpeedMeter
./setup.sh
```

This script will:
1. Verify Xcode is installed
2. Install XcodeGen (via Homebrew)
3. Generate the Xcode project
4. Open it in Xcode

### After the project opens in Xcode:
1. Click the **SpeedMeter** project in the left sidebar
2. For **both** targets (SpeedMeter + SpeedMeterWidgetExtension):
   - Go to **Signing & Capabilities**
   - Select your **Apple ID** under Team
3. Connect your iPhone via USB
4. Select your iPhone at the top of Xcode
5. Press **Cmd + R** to build and run
6. On iPhone: **Settings → General → VPN & Device Management** → Trust certificate

## Features

- **Dynamic Island** — live download/upload speed (iPhone 14 Pro+)
- **Lock Screen Live Activity** — speed banner on lock screen
- **Home Screen Widget** — small/medium widget with last speed
- **Animated gauges** — circular speed gauges with gradients
- **Live chart** — 60-second scrolling speed history
- **WiFi & Cellular** — auto-detects connection type

## How It Works

Reads actual bytes from system network interfaces (`getifaddrs`) every second.
Not a synthetic speed test — measures your real live throughput.

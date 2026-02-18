#!/bin/bash
set -e

echo ""
echo "======================================"
echo "  SpeedMeter - iOS App Setup"
echo "======================================"
echo ""

# Step 1: Check for Xcode
echo "[1/4] Checking for Xcode..."
if ! xcode-select -p &>/dev/null; then
    echo ""
    echo "ERROR: Xcode Command Line Tools not found."
    echo "Run: xcode-select --install"
    echo "Then re-run this script."
    exit 1
fi

if ! ls /Applications/Xcode*.app &>/dev/null 2>&1; then
    echo ""
    echo "ERROR: Xcode.app not found in /Applications/"
    echo ""
    echo "You MUST install Xcode to build iOS apps."
    echo "Open the App Store, search 'Xcode', and install it (free, ~12GB)."
    echo "After installing, open Xcode once to accept the license."
    echo "Then re-run this script."
    echo ""
    exit 1
fi

echo "  Xcode found!"

# Step 2: Accept Xcode license (if needed)
echo "[2/4] Checking Xcode license..."
sudo xcodebuild -license accept 2>/dev/null || true

# Step 3: Install XcodeGen
echo "[3/4] Installing XcodeGen (project generator)..."
if command -v xcodegen &>/dev/null; then
    echo "  XcodeGen already installed."
else
    if command -v brew &>/dev/null; then
        echo "  Installing via Homebrew..."
        brew install xcodegen
    else
        echo "  Installing Homebrew first..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew install xcodegen
    fi
fi

# Step 4: Generate Xcode project
echo "[4/4] Generating Xcode project..."
cd "$(dirname "$0")"
xcodegen generate

echo ""
echo "======================================"
echo "  SUCCESS! Project generated."
echo "======================================"
echo ""
echo "Next steps:"
echo ""
echo "  1. Open the project:"
echo "     open SpeedMeter.xcodeproj"
echo ""
echo "  2. In Xcode, select your Team:"
echo "     - Click 'SpeedMeter' project in sidebar"
echo "     - Select 'SpeedMeter' target → Signing & Capabilities"
echo "     - Choose your Apple ID under 'Team'"
echo "     - Do the same for 'SpeedMeterWidgetExtension' target"
echo ""
echo "  3. Connect your iPhone and press Cmd+R to build & run"
echo ""
echo "  4. On your iPhone: Settings → General → VPN & Device"
echo "     Management → Trust your developer certificate"
echo ""
echo "  5. Run the app, tap 'Start Monitoring', and check"
echo "     Dynamic Island + Lock Screen for live speed!"
echo ""

# Auto-open the project
read -p "Open the project in Xcode now? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    open SpeedMeter.xcodeproj
fi

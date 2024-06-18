# TStest

## App Name
TStest

## Bundle ID
com.ts.testapp

## Description
TStest is an iOS application that calculates the device's tilt, displays the history in a graph, and offers various additional features. This app is built using SwiftUI and can be distributed through TrollStore.

## Features
- Calculates tilt values (Pitch, Roll, Yaw)
- Graphs the tilt history
- Saves and loads history data
- Sends notifications when a specific tilt value is exceeded
- Supports dark mode
- Highlights data points on the graph

## Requirements
- iOS 14.0 or later
- Xcode 12 or later
- SwiftUI
- CoreMotion framework

## Installation

### Using Xcode
1. Clone this repository:
   ```sh
   git clone https://github.com/yourusername/TStest.git
   ```

2. Open the project in Xcode:
   ```sh
   open TStest.xcodeproj
   ```

3. Build and run the project:
   - Select a build target (iOS Simulator or a real device).
   - Press `Cmd + R` to build and run the project.

### Using TrollStore
1. Build the project in Xcode to generate the .ipa file.
2. Install the generated .ipa file using TrollStore.
   - Refer to the TrollStore installation guide for instructions on installing the .ipa file.

## Usage
1. Launch the app.
2. Press the "Start" button to begin measuring the tilt.
3. The tilt values (Pitch, Roll, Yaw) will be displayed in real-time.
4. View the tilt history through the graph.
5. A notification will be displayed when a specific tilt value is exceeded.
6. Press the "Stop" button to stop measuring the tilt.
7. Toggle dark mode in the settings.

## Code Overview

### MotionManager.swift
- `MotionManager`: A class that uses CoreMotion to measure the device's tilt and manage the data.

### ContentView.swift
- `ContentView`: The main view that displays tilt values and the graph, and provides the user interface.
- `LineGraph`: A custom view that graphs the tilt history.

### YourAppApp.swift
- The entry point of the app, which sets `ContentView` as the initial screen.

### ViewController.swift
- A UIKit view controller that embeds the SwiftUI view.

## License
This project is licensed under the MIT License. See the `LICENSE` file for more information.

## Author
- [speedyfriend67](https://github.com/speedyfriend433)

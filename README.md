# Boilerplate README.md

## Resources
// to add

## Overview

### Target environment
* iOS 16 / iPhone & iPad

### Development environment
* Xcode 14 / Swift 5

## How to start

### Initial setup
* Run in terminal: `sh Scripts/on-board` . It will configure the templates. The steps are namely:
  * Add templates (they help a lot with boilerplate!): `sh Scripts/Templates/replace-templates`

Initial setup done!

### If you have an Apple silicon device
If you're working on a device with a new Apple silicon chip, the project cannot be built for simulator. In order to be able to work on the project, Xcode can be run using Rosetta:

<img src="/uploads/a6cc3684844f3d49905fd08317c2d0e1/Screenshot_2022-07-21_at_16.24.05.png" height ="600">

## Troubleshooting
> xcode-select: error: tool ‘xcodebuild’ requires Xcode, but active developer directory ‘/Library/Developer/CommandLineTools’ is a command line tools instance

Run `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`

When mock generator disappears from Xcode's Editor menu: Execute `/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f /Applications/Xcode.app` in Terminal

# react-native-nitro-restart

App restart and process management for React Native built with Nitro Modules.

## Overview

This module provides native-level app restart and process management functionality for both Android and iOS. It exposes simple JS/TS APIs to restart the app, exit the app, and get the current process ID.

## Features

- � **App Restart** - Restart the entire React Native app
- � **App Exit** - Safely exit the application 
- 🆔 **Process ID** - Get the current process identifier
- 🚀 Built with Nitro Modules for native performance and autolinking support
- 📱 Cross-platform support (iOS & Android)
- ⚡ Zero-config setup with autolinking

## Requirements

- React Native >= 0.76
- Node >= 18
- `react-native-nitro-modules` must be installed (Nitro runtime)

## Installation

```bash
npm install react-native-nitro-restart react-native-nitro-modules
# or
yarn add react-native-nitro-restart react-native-nitro-modules
```

## Configuration

### Android Setup

No additional configuration required. The module will automatically handle app restart through Android's activity management.

### iOS Setup

No additional configuration required. The module uses React Native's built-in restart capabilities.

### Troubleshooting

- **Android**: If restart doesn't work, ensure your app has proper activity lifecycle management
- **iOS**: Make sure your app delegate is properly configured for React Native
- **Both platforms**: Test on real devices for best results

## Quick Usage

```typescript
import { NitroRestartModule } from 'react-native-nitro-restart'

// Restart the app with default module name
NitroRestartModule.restartApp('YourAppName')

// Get current process ID
const processId = NitroRestartModule.getPid()
console.log('Current PID:', processId)

// Exit the app (use with caution)
NitroRestartModule.exitApp()
```

## API Reference

### App Management

#### `restartApp(moduleName: string): void`

Restarts the React Native application with the specified module name.

**Parameters:**

- `moduleName` (string): The name of the main React Native module to restart with

**Example:**

```typescript
import { NitroRestartModule } from 'react-native-nitro-restart'

// Restart with your app's main module
NitroRestartModule.restartApp('MyApp')
```

#### `exitApp(): void`

Safely exits the application. On iOS, this moves the app to background instead of force terminating. On Android, this finishes the current activity and moves the app to background.

**Note:** Use this method with caution as it may violate app store guidelines if used inappropriately.

**Example:**

```typescript
import { NitroRestartModule } from 'react-native-nitro-restart'

// Exit the app
NitroRestartModule.exitApp()
```

#### `getPid(): number`

Returns the current process identifier (PID) of the application.

**Returns:**

- `number`: The current process ID

**Example:**

```typescript
import { NitroRestartModule } from 'react-native-nitro-restart'

// Get current process ID
const processId = NitroRestartModule.getPid()
console.log('Current PID:', processId)
```

## Complete Example

```typescript
import React, { useState } from 'react'
import { View, Button, Text, Alert } from 'react-native'
import { NitroRestartModule } from 'react-native-nitro-restart'

const App = () => {
  const [processId, setProcessId] = useState<number | null>(null)

  const handleGetPid = () => {
    const pid = NitroRestartModule.getPid()
    setProcessId(pid)
  }

  const handleRestart = () => {
    Alert.alert(
      'Restart App',
      'Are you sure you want to restart the application?',
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Restart',
          onPress: () => NitroRestartModule.restartApp('YourAppName')
        }
      ]
    )
  }

  const handleExit = () => {
    Alert.alert(
      'Exit App',
      'Are you sure you want to exit the application?',
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Exit',
          style: 'destructive',
          onPress: () => NitroRestartModule.exitApp()
        }
      ]
    )
  }

  return (
    <View style={{ flex: 1, justifyContent: 'center', padding: 20 }}>
      <Button title="Get Process ID" onPress={handleGetPid} />
      {processId && (
        <Text style={{ textAlign: 'center', margin: 10 }}>
          Current PID: {processId}
        </Text>
      )}
      
      <Button title="Restart App" onPress={handleRestart} />
      <Button title="Exit App" onPress={handleExit} color="red" />
    </View>
  )
}

export default App
```

## Platform Support

| Feature      | iOS | Android | Notes |
| ------------ | --- | ------- | ----- |
| restartApp() | ✅  | ✅      | Creates new React context |
| exitApp()    | ✅  | ✅      | Moves to background (safe) |
| getPid()     | ✅  | ✅      | Returns process identifier |

## Best Practices

1. **User confirmation**: Always ask for user confirmation before restarting or exiting the app
2. **Save state**: Ensure important app state is saved before restart/exit operations
3. **Error handling**: Wrap operations in try-catch blocks for production apps
4. **App store compliance**: Be cautious with `exitApp()` - some app stores discourage apps from terminating themselves
5. **Testing**: Test restart functionality thoroughly on both platforms and different devices

## Important Notes

⚠️ **App Store Guidelines**:

- **iOS**: Apple's guidelines discourage apps from programmatically terminating themselves
- **Android**: Google Play has similar recommendations
- Use `exitApp()` sparingly and only when absolutely necessary

📱 **Platform Differences**:

- **iOS**: Restart creates a new React Native context within the same process
- **Android**: Restart may create a new activity or recreate the React context
- Both platforms handle `exitApp()` by moving the app to background instead of force termination

## TypeScript Interface

```typescript
export interface NitroRestart
  extends HybridObject<{ ios: 'swift'; android: 'kotlin' }> {
  restartApp(moduleName: string): void
  exitApp(): void
  getPid(): number
}
```

## Migration Notes

When updating spec files in `src/specs/*.nitro.ts`, regenerate Nitro artifacts:

```bash
npx nitro-codegen
```

## Contributing

See `CONTRIBUTING.md` for contribution workflow. Run `npx nitro-codegen` after editing spec files.

## Project Structure

- `android/` — Native Android implementation (Kotlin)
- `ios/` — Native iOS implementation (Swift)
- `src/` — TypeScript API exports
- `nitrogen/` — Generated Nitro artifacts

## Acknowledgements

Special thanks to the following open-source projects which inspired and supported the development of this library:

- [mrousavy/nitro](https://github.com/mrousavy/nitro) – for the Nitro Modules architecture and tooling

## License

MIT © [Thành Công](https://github.com/tconns)

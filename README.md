# react-native-nitro-restart

Native restart/exit/process utilities for React Native, built with Nitro Modules.

This package provides a small, typed API to:

- restart app runtime
- request app exit/backgrounding
- read current process id (PID)

## Features

- Nitro-based iOS and Android implementation
- Simple JS API with TypeScript types
- Autolinking support
- Extra convenience APIs for safer usage (`restartCurrentApp`, `canExitApp`)

## Requirements

- React Native `>= 0.76`
- Node.js `>= 18`
- `react-native-nitro-modules` `>= 0.35.x`

## Installation

```bash
npm install react-native-nitro-restart react-native-nitro-modules
```

or

```bash
yarn add react-native-nitro-restart react-native-nitro-modules
```

## Platform setup

No special permission is required by this library.

- **Android**: no extra manifest permission needed for restart/exit API.
- **iOS**: no extra entitlement required for restart/exit API.

Then run platform dependency sync as usual:

```bash
cd ios && pod install
```

## Quick usage

```ts
import {
  restartApp,
  restartCurrentApp,
  exitApp,
  canExitApp,
  getPid,
} from 'react-native-nitro-restart'

restartApp('MyApp')
restartCurrentApp()

if (canExitApp()) {
  exitApp()
}

console.log('PID:', getPid())
```

## API reference

### `restartApp(moduleName: string): void`

Requests app restart using a specific module name.

### `restartCurrentApp(): void`

Convenience method to restart current app without passing module name.

### `exitApp(): void`

Requests app exit/background transition.

Use with caution and with user intent.

### `canExitApp(): boolean`

Returns whether the platform implementation allows exit flow.

### `getPid(): number`

Returns current process id.

## Example (React screen)

```tsx
import React from 'react'
import { Alert, Button, Text, View } from 'react-native'
import {
  restartApp,
  restartCurrentApp,
  exitApp,
  canExitApp,
  getPid,
} from 'react-native-nitro-restart'

export function RestartDemoScreen() {
  const pid = getPid()

  const onRestart = () => {
    Alert.alert('Restart', 'Restart app now?', [
      { text: 'Cancel', style: 'cancel' },
      { text: 'Restart', onPress: () => restartCurrentApp() },
    ])
  }

  const onRestartWithModule = () => {
    Alert.alert('Restart', 'Restart with explicit module name?', [
      { text: 'Cancel', style: 'cancel' },
      { text: 'Restart', onPress: () => restartApp('MyApp') },
    ])
  }

  const onExit = () => {
    if (!canExitApp()) return
    Alert.alert('Exit', 'Exit app?', [
      { text: 'Cancel', style: 'cancel' },
      { text: 'Exit', style: 'destructive', onPress: () => exitApp() },
    ])
  }

  return (
    <View style={{ flex: 1, justifyContent: 'center', padding: 20, gap: 12 }}>
      <Text>Current PID: {pid}</Text>
      <Button title="Restart current app" onPress={onRestart} />
      <Button title="Restart with module name" onPress={onRestartWithModule} />
      <Button title="Exit app" onPress={onExit} />
    </View>
  )
}
```

## Platform behavior notes

- **iOS**
  - Uses React reload notification as primary path.
  - Falls back to React factory reflection if available.
  - `exitApp()` uses app suspension style behavior; Apple may reject abusive usage.

- **Android**
  - Restart re-launches app launch intent with task flags.
  - `exitApp()` moves task to background and calls `finishAffinity`.
  - Avoid force-kill patterns for Play policy compliance.

## Test checklist

- [ ] Restart from foreground (iOS/Android)
- [ ] Restart from background-resumed state
- [ ] Exit action with explicit user confirmation
- [ ] PID is readable and stable during normal session
- [ ] No crash loop after repeated restart (5-10 times)
- [ ] Works on at least one real iOS device and one real Android device

## Nitro development

When updating `src/specs/*.nitro.ts`, regenerate artifacts:

```bash
npx tsc && npx nitrogen --logLevel="debug"
```

Useful scripts:

- `npm run typecheck`
- `npm run lint`
- `npm run specs`

## Implementation plan (to-do)

Status legend:

- `[x]` done
- `[ ]` planned
- `[~]` in progress

### Core Nitro baseline

- [x] Migrate toolchain to `nitrogen` + `react-native-nitro-modules@^0.35.6`
- [x] Update `nitro.json` autolinking schema to current per-platform format
- [x] Regenerate `nitrogen/generated/*` artifacts and autolinking files
- [x] Keep backward compatibility for `restartApp(moduleName)`
- [x] Add extended APIs: `restartCurrentApp()`, `canExitApp()`

### Native hardening

- [x] Android restart path switched to launch intent from app context
- [x] Android flow avoids force-kill as default behavior
- [x] iOS reload notification path added as primary restart path
- [~] Broader host-app compatibility validation across RN templates

### Next planned improvements

- [ ] Add optional restart policy/options object API
- [ ] Add platform capability diagnostics (reason codes, not only boolean)
- [ ] Add E2E smoke test app and CI matrix for restart behavior

## License

MIT © [Thành Công](https://github.com/tconns)

import type { HybridObject } from 'react-native-nitro-modules'

export interface NitroRestart extends HybridObject<{
  ios: 'swift'
  android: 'kotlin'
}> {
  restartApp(moduleName: string): void
  restartCurrentApp(): void
  exitApp(): void
  canExitApp(): boolean
  getPid(): number
}

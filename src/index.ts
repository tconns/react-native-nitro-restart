import { NitroModules } from 'react-native-nitro-modules'
import type { NitroRestart as NitroRestartSpec } from './specs/NitroRestart.nitro'

const NitroRestartModule =
  NitroModules.createHybridObject<NitroRestartSpec>('NitroRestart')

export const restartApp = (moduleName: string) => {
  NitroRestartModule.restartApp(moduleName)
}

export const exitApp = () => {
  NitroRestartModule.exitApp()
}

export const getPid = (): number => {
  return NitroRestartModule.getPid()
}

// Export the hybrid object itself for advanced use cases
export { NitroRestartModule }

//
//  NitroRestart.swift
//  NitroRestart
//
//  Created by tconns94 on 8/21/2025.
//

import UIKit
import Foundation
import React

class NitroRestart: HybridNitroRestartSpec {
  func restartApp(moduleName: String) {
    DispatchQueue.main.async {
      guard let appDelegate = UIApplication.shared.delegate as? RCTAppDelegate,
            let bridge = appDelegate.bridge,
            let window = appDelegate.window else {
        print("NitroRestart Error: Unable to access app delegate, bridge, or window")
        return
      }
      
      let rootView = RCTRootView(
        bridge: bridge,
        moduleName: moduleName,
        initialProperties: nil
      )
      let vc = UIViewController()
      vc.view = rootView
      window.rootViewController = vc
      window.makeKeyAndVisible()
    }
  }

  func exitApp() {
    DispatchQueue.main.async {
      // Note: Direct app termination violates iOS guidelines and may cause App Store rejection
      // This implementation suspends the app instead of terminating it
      if let window = UIApplication.shared.windows.first {
        UIView.animate(withDuration: 0.3, animations: {
          window.alpha = 0
          window.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
          // Put app in suspended state (safer than exit)
          UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        }
      }
    }
  }

  func getPid() -> Double {
    return Double(getpid())
  }
}

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
      NotificationCenter.default.post(name: NSNotification.Name("RCTReloadNotification"), object: nil)

      // Fallback for app delegates that expose ReactNativeFactory via reflection
      guard
        let appDelegate = UIApplication.shared.delegate as? NSObject,
        let window = appDelegate.value(forKey: "window") as? UIWindow,
        let factory = appDelegate.value(forKey: "reactNativeFactory") as? NSObject
      else {
        return
      }

      let selector = Selector(("startReactNative:in:launchOptions:"))
      if factory.responds(to: selector), let method = factory.method(for: selector) {
        typealias StartReactNativeMethod = @convention(c) (AnyObject, Selector, String, UIWindow, [UIApplication.LaunchOptionsKey: Any]?) -> Void
        let startReactNative = unsafeBitCast(method, to: StartReactNativeMethod.self)
        let resolvedModuleName = moduleName.isEmpty ? (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "App") : moduleName
        startReactNative(factory, selector, resolvedModuleName, window, nil)
      }
    }
  }

  func restartCurrentApp() {
    restartApp(moduleName: "")
  }

  func exitApp() {
    DispatchQueue.main.async {
      guard
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
        let window = scene.windows.first
      else { return }
      
      UIView.animate(withDuration: 0.3, animations: {
        window.alpha = 0
        window.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
      }) { _ in
        // ⚠️ Lưu ý: Vi phạm guideline App Store nếu đưa lên store
        // Chỉ nên dùng trong app nội bộ hoặc dev
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
      }
    }
  }

  func canExitApp() -> Bool {
    return true
  }

  func getPid() -> Double {
      return Double(getpid())
  }
}
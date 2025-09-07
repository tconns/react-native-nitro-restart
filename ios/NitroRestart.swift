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
      guard let appDelegate = UIApplication.shared.delegate else {
        print("NitroRestart Error: Unable to access app delegate")
        return
      }
      
      // Try to get window and factory using reflection
      guard let window = (appDelegate as? NSObject)?.value(forKey: "window") as? UIWindow,
            let factory = (appDelegate as? NSObject)?.value(forKey: "reactNativeFactory") else {
        print("NitroRestart Error: Unable to access window or React Native factory")
        return
      }
      
      // Use reflection to call startReactNative method
      let factoryObject = factory as AnyObject
      let selector = Selector(("startReactNative:in:launchOptions:"))
      if factoryObject.responds(to: selector) {
        let method = factoryObject.method(for: selector)
        typealias StartReactNativeMethod = @convention(c) (AnyObject, Selector, String, UIWindow, [UIApplication.LaunchOptionsKey: Any]?) -> Void
        let startReactNative = unsafeBitCast(method, to: StartReactNativeMethod.self)
        startReactNative(factoryObject, selector, moduleName, window, nil)
      } else {
        print("NitroRestart Error: startReactNative method not found")
      }
    }
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

  func getPid() -> Double {
      return Double(getpid())
  }
}
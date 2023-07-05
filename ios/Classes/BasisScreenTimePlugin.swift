import Flutter
import SwiftUI
import UIKit
import FamilyControls
import DeviceActivity
import UserNotifications

public class BasisScreenTimePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "basis_screen_time",
            binaryMessenger: registrar.messenger()
        )
        let instance = BasisScreenTimePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard #available(iOS 16.0, *), let method = ScreenTimeMethod(rawValue: call.method)
        else { return }
        
        switch method {
        case .scheduleApplicationBlocking: scheduleApplicationBlocking(
            call: call, result: result
        )
        case .requestAuthorization: requestAuthorization(result: result)
        }
    }
    
    @available(iOS 16.0, *)
    private func scheduleApplicationBlocking(
        call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) {
        guard let arguments = call.arguments as? NSDictionary else { return }
        let schedule = STBlockSchedule(dict: arguments)
        presentActivitySelector(schedule: schedule, result: result)
    }
    
    @available(iOS 16.0, *)
    private func presentActivitySelector(
        schedule: STBlockSchedule,
        result: @escaping FlutterResult
    ) {
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var controller: UIViewController! = rootController
            while( controller.presentedViewController != nil ) {
                controller = controller.presentedViewController
            }
            let activity = DeviceActivitySchedule(
                intervalStart: DateComponents(hour: 8, minute: 0, second: 0),
                intervalEnd: DateComponents(hour: 12, minute: 4, second: 0),
                repeats: schedule.repeats
            )
            let hostingController = UIHostingController(
                rootView: ActivitySelectionView(
                    group: schedule.id,
                    schedule: activity
                )
            )
            controller.present(hostingController, animated: true)
        }
    }
    
    @available(iOS 16.0, *)
    private func requestAuthorization(result: @escaping FlutterResult) {
        Task {
            do {
                let center = AuthorizationCenter.shared
                try await center.requestAuthorization(for: .individual)
                return center.authorizationStatus == .approved
            } catch {
                return false
            }
        }
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

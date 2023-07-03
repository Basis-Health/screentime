//
//  DeviceActivityMonitorExtension.swift
//  Device Activity Monitor Example
//
//  Created by Michael Jajou on 7/3/23.
//

import Foundation
import DeviceActivity
import ManagedSettings
import FamilyControls
import UserNotifications

class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        let selection = FamilyActivitySelection.fromKey(activity.rawValue)
        let store = ManagedSettingsStore(named: .init(activity.rawValue))
        store.shield.applications = selection.applicationTokens
        store.shield.webDomains = selection.webDomainTokens
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        let store = ManagedSettingsStore(named: .init(activity.rawValue))
        store.clearAllSettings()
    }
}

@available(iOS 16.0, *)
extension FamilyActivitySelection {
    static func fromKey(_ key: String) -> FamilyActivitySelection {
        if let data = UserDefaults.group()?.data(forKey: key),
           let selection = try? JSONDecoder().decode(
            FamilyActivitySelection.self,
            from: data
        )  {
            return selection
        } else {
            return FamilyActivitySelection(includeEntireCategory: false)
        }
    }
}

extension UserDefaults {
    static func group() -> UserDefaults? {
        return UserDefaults(
            suiteName: "group.J844EMD5AP.basis.controls"
        )
    }
}

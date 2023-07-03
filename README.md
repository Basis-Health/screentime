# basis_screen_time

iOS Screen Time Manager

## Initial Setup
1. Add two extensions must be added to the main app. 
   a. File -> Target -> Shield Configuration 
   b. File -> Target -> Device Activity Monitor Extension. Name it DeviceActivityMonitorExtension. 
2. Enable App Groups for both extensions and the main target
   a. For each target mentioned above, under Signing & Capabilities, add App Groups.
   b. Set the Group ID in this format: group.<TEAM_ID>.basis.controls
3. Open DeviceActivityMonitorExtension.swift, and paste in the following code: 
```
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
            suiteName: "group.<TEAM_ID>.basis.controls"
        )
    }
}
```



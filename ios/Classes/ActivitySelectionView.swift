//
//  ActivitySelectionView.swift
//  screen_time
//
//  Created by Michael Jajou on 6/24/23.
//

import SwiftUI
import FamilyControls
import DeviceActivity
import ScreenTime
import ManagedSettings

@available(iOS 16.0, *)
struct ActivitySelectionView: View {
    let group: String
    let schedule: DeviceActivitySchedule
    let onSaved: () -> Void
    @State private var selection: FamilyActivitySelection
    private var service: DeviceActivityService { DeviceActivityService.shared }
    
    init(group: String, schedule: DeviceActivitySchedule, onSaved: @escaping () -> Void) {
        self.group = group
        self.schedule = schedule
        let key = DeviceActivityName.fromId(group).rawValue
        self._selection = .init(initialValue: .fromKey(key))
        self.onSaved = onSaved
    }
    
    var body: some View {
        NavigationStack {
            FamilyActivityPicker(selection: $selection)
                .toolbar {
                    doneButton
                }
        }
        .environment(\.colorScheme, .dark)
    }
    
    private var doneButton: some View {
        Button {
            saveSelection()
            UIApplication.topViewController()?.dismiss(animated: true)
        } label: {
            Text("Done").foregroundColor(.white)
        }
    }
    
    func saveSelection() {
        do {
            let data = try JSONEncoder().encode(selection)
            UserDefaults.group()?.setValue(
                data,
                forKey: DeviceActivityName.fromId(group).rawValue
            )
            startMonitoring()
            onSaved()
        } catch {
            print(error)
        }
    }
    
    private func startMonitoring() {
        service.startMonitoring(id: group, schedule: schedule)
    }
}

@available(iOS 16.0, *)
class DeviceActivityService {
    static let shared = DeviceActivityService()
    private let center = DeviceActivityCenter()
    
    func startMonitoring(id: String, schedule: DeviceActivitySchedule) {
        do {
            let activity = DeviceActivityName.fromId(id)
            try center.startMonitoring(activity, during: schedule)
        } catch {
            print(error)
        }
    }
    
    func stopMonitoring(id: String) {
        center.stopMonitoring([.fromId(id)])
    }
}

@available(iOS 16.0, *)
extension DeviceActivityName {
    static func fromId(_ id: String) -> DeviceActivityName {
        return DeviceActivityName("device_activity_\(id)")
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
    private var activeSchedulesKey: String {
        "active_schedules"
    }

    static func group() -> UserDefaults? {
        return UserDefaults(
            suiteName: "group.J844EMD5AP.basis.controls"
        )
    }

    func getActiveSchedules() -> [STBlockSchedule] {
        let decoder = JSONDecoder()
        if let data = self.data(forKey: activeSchedulesKey),
           let schedules = try? decoder.decode(
            [STBlockSchedule].self,
            from: data
        ) {
            return schedules
        } else {
            return []
        }
    }

    func setActiveSchedules(_ schedules: [STBlockSchedule]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(schedules) {
            self.setValue(data, forKey: activeSchedulesKey)
        }
    }
}

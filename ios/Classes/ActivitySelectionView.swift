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
    private let key: String
    let group: String
    let schedule: DeviceActivitySchedule
    @State private var selection: FamilyActivitySelection
    
    init(group: String, schedule: DeviceActivitySchedule) {
        let key = "device_activity_\(group)"
        self.key = key
        self.group = group
        self.schedule = schedule
        self._selection = .init(initialValue: .fromKey(key))
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
            UserDefaults.group()?.setValue(data, forKey: key)
            startMonitoring()
        } catch {
            print(error)
        }
    }
    
    private func startMonitoring() {
        let center = DeviceActivityCenter()
        do {
            let activity = DeviceActivityName(key)
            try center.startMonitoring(activity, during: schedule)
        } catch {
            print(error)
        }
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

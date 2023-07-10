//
//  STBlockSchedule.swift
//  basis_screen_time
//
//  Created by Michael Jajou on 7/5/23.
//

import Foundation
import FamilyControls
import DeviceActivity
import UserNotifications

struct STTimeComponent: Codable {
    let hour: Int
    let minute: Int
    let second: Int
    
    init(dict: NSDictionary?) {
        self.hour = dict?["hour"] as? Int ?? 0
        self.minute = dict?["minute"] as? Int ?? 0
        self.second = dict?["second"] as? Int ?? 0
    }
}

struct STBlockSchedule: Codable {
    let id: String
    let startTime: STTimeComponent
    let endTime: STTimeComponent
    let repeats: Bool
    
    init(dict: NSDictionary) {
        self.id = dict["id"] as? String ?? ""
        self.startTime = .init(dict: dict["startTime"] as? NSDictionary)
        self.endTime = .init(dict: dict["endTime"] as? NSDictionary)
        self.repeats = dict["repeats"] as? Bool ?? false
    }
}

@available(iOS 16.0, *)
enum STPermissionState: String {
    case authorized
    case denied
    case notDetermined
    
    static func fromStatus(status: AuthorizationStatus) -> STPermissionState {
        switch status {
        case .approved:
            return .authorized
        case .denied:
            return .denied
        default:
            return .notDetermined
        }
    }
}

extension STTimeComponent {
    func toData() -> NSDictionary {
        return [
            "hour": hour,
            "minute": minute,
            "second": second,
        ]
    }
}

extension STBlockSchedule {
    func toData() -> NSDictionary {
        return [
            "id": id,
            "startTime": startTime.toData(),
            "endTime": endTime.toData(),
            "repeats": repeats
        ]
    }
}

extension Array where Element == STBlockSchedule {
    func toData() -> [NSDictionary] { map { $0.toData() }}
}

//
//  ScreenTimeMethod.swift
//  screen_time
//
//  Created by Michael Jajou on 6/24/23.
//

import Foundation

enum ScreenTimeMethod: String {
    case isOSSupported
    case permissionStatus
    case requestAuthorization
    case scheduleApplicationBlocking
    case activeSchedules
    case deleteSchedule
    case updateSchedule
}

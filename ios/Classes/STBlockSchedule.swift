//
//  STBlockSchedule.swift
//  basis_screen_time
//
//  Created by Michael Jajou on 7/5/23.
//

import Foundation

struct STTimeComponent {
    let hour: Int
    let minute: Int
    let second: Int
    
    init(dict: NSDictionary?) {
        self.hour = dict?["hour"] as? Int ?? 0
        self.minute = dict?["minute"] as? Int ?? 0
        self.second = dict?["second"] as? Int ?? 0
    }
}

struct STBlockSchedule {
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

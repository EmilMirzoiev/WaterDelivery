//
//  SwitcherViewModel.swift
//  WaterDelivery
//
//  Created by Emil on 09.02.23.
//

import Foundation

class SwitcherViewModel {
    var switcherName: String = ""
    var value: Bool = false
    
    var completion: ((Bool) -> Void)?
    
    init(switcherName: String, value: Bool, competion: @escaping (Bool) -> Void) {
        self.switcherName = switcherName
        self.value = value
        self.completion = competion
    }
}

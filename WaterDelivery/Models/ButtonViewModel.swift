//
//  ButtonViewModel.swift
//  WaterDelivery
//
//  Created by Emil on 09.02.23.
//

import Foundation

class ButtonViewModel {
    var buttonName: String = ""
    var completion: (() -> ())?
    
    init(buttonName: String, completion: @escaping () -> Void) {
        self.buttonName = buttonName
        self.completion = completion
    }
}

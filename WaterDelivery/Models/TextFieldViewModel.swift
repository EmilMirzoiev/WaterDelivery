//
//  TextFieldViewModel.swift
//  WaterDelivery
//
//  Created by Emil on 09.02.23.
//

import Foundation

class TextFieldViewModel {
    var fieldName: String = ""
    var value: String = ""
    
    var competion: ((String) -> Void)?
    
    init(fieldName: String, value: String, competion: @escaping (String) -> Void) {
        self.fieldName = fieldName
        self.value = value
        self.competion = competion
    }
}

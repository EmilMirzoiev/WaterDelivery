//
//  LabelViewModel.swift
//  WaterDelivery
//
//  Created by Emil on 09.02.23.
//

import Foundation

class LabelViewModel {
    var titleLabel: String = ""
    var valueLabel: String = ""
    var competion: ((String) -> Void)?
    
    init(titleLabel: String, valueLabel: String, competion: @escaping (String) -> Void) {
        self.titleLabel = titleLabel
        self.valueLabel = valueLabel
        self.competion = competion
    }
}

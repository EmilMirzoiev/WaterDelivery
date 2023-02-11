//
//  ImageViewModel.swift
//  WaterDelivery
//
//  Created by Emil on 09.02.23.
//

import Foundation

class ImageViewModel {
    var imageURL: String = ""
    var completion: (() -> ())?
    
    init(imageURL: String, completion: @escaping () -> Void) {
        self.imageURL = imageURL
        self.completion = completion
    }
}

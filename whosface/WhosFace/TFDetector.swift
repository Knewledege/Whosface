//
//  judge.swift
//  WhosFace
//
//  Created by Kei on 2017/08/07.
//  Copyright © 2017年 takahashi kei. All rights reserved.
//

import Foundation
import UIKit
import TensorSwift

class TFDetector {
    
    static let instance = TFDetector()
    
    private let classifier = Classifier(path: Bundle.main.resourcePath!)
    
    
    init() {
    }
    
    func detectImage(image: UIImage, inputSize: Int) -> ([Float],Int) {
        
        let input: Tensor
        
        do {
            
                var pixels = [UInt8](repeating: 0, count: inputSize * inputSize*4 )
                
                let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue)
                let context = CGContext(data: &pixels, width: inputSize, height: inputSize, bitsPerComponent: 8, bytesPerRow: inputSize * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: bitmapInfo.rawValue)!
                let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(inputSize), height: CGFloat(inputSize))
                context.clear(rect)
                context.draw(image.cgImage!,in:rect)
                
                let rgb = pixels.enumerated().filter { $0.0 % 4 != 3 }.map { Float($0.1) / 255.0 }
                
                input = Tensor(shape: [Dimension(inputSize), Dimension(inputSize), Dimension(3)], elements:rgb)
            }
            let paramate = classifier.classify(input)
            return (paramate.0,paramate.1)
    }
}

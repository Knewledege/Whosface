//
//  String.swift
//  WhosFace
//
//  Created by Kei on 2017/08/07.
//  Copyright © 2017年 takahashi kei. All rights reserved.
//
import Foundation

extension String {
    public func stringByAppendingPathComponent(_ str: String) -> String {
        return (self as NSString).appendingPathComponent(str)
    }
}

//
//  Names.swift
//  WhosFace
//
//  Created by Kei on 2017/08/13.
//  Copyright © 2017年 takahashi kei. All rights reserved.
//

import Foundation

class NamesClass{
    
    let Names : [String] = ["ONE OK ROCK TAKA",
                            "クリスティアーノ・ロナウド",
                            "坂口健太郎"]
    func GetName(indent:Int)->String{
        return Names[indent]
    }
}

//
//  OpenClass.swift
//  SuperCrash
//
//  Created by 王偉 on 2017/1/17.
//  Copyright © 2017年 王偉. All rights reserved.
//

import UIKit

class OpenClass: NSObject {

    class var shared : OpenClass {
        
        struct Static {
            static let instance : OpenClass = OpenClass()
            
        }
        
        return Static.instance
    }
    
    var screenWidth:CGFloat!
    var screenHeight:CGFloat!
    
}

//
//  PrimaryButton.swift
//  MyTasks
//
//  Created by amir on 6/27/17.
//  Copyright © 2017 Amir Khorsandi. All rights reserved.
//

import UIKit

@IBDesignable class PrimaryButton: UIButton {
    
    @IBInspectable public var BackColor:UIColor! = nil{
        didSet{
            if BackColor != nil{
                self.layer.backgroundColor = BackColor.cgColor
                
                self.layer.shadowColor = BackColor.cgColor
                self.layer.shadowOffset = CGSize(width: 0, height: 0)
                self.layer.shadowRadius = 13
                self.layer.shadowOpacity = 0.54
                self.layer.shouldRasterize = true
                self.layer.rasterizationScale = UIScreen.main.scale
            }
        }
    }
    
//    @IBInspectable public var IconName:String = ""{
//        didSet{
//            if IconName != nil{
//                titleLabel.text = Title
//            }
//        }
//    }
    

    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = rect.width/2
        
       // self.layer.backgroundColor = self.backgroundColor?.cgColor
    
    }

}

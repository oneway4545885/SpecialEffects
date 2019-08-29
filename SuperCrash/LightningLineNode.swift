//
//  LightningLineNode.swift
//  SpriteKitLigtning-Swift
//
//  Created by Andrey Gordeev on 28/10/14.
//  Copyright (c) 2014 Andrey Gordeev. All rights reserved.
//

import Foundation
import SpriteKit

class LightningLineNode: SKNode {
    var startPoint = CGPoint(x: 0.0, y: 0.0)
    var endPoint = CGPoint(x: 0.0, y: 0.0)
    let thickness = 1.3
    
    init(startPoint: CGPoint, endPoint: CGPoint) {
        super.init()
        self.startPoint = startPoint
        self.endPoint = endPoint
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func draw() {
        let imageThickness = 2.0
        let thicknessScale = CGFloat(self.thickness / imageThickness)
        let startPointInThisNode = self.convert(self.startPoint, from: self.parent!)
        let endPointInThisNode = self.convert(self.endPoint, from: self.parent!)
        
        let angle = CGFloat(atan2(Float(endPointInThisNode.y) - Float(startPointInThisNode.y),
            Float(endPointInThisNode.x) - Float(startPointInThisNode.x)));
        let length = hypotf(fabsf(Float(endPointInThisNode.x) - Float(startPointInThisNode.x)),
            fabsf(Float(endPointInThisNode.y) - Float(startPointInThisNode.y)))
        
        let halfCircleA = SKSpriteNode(texture: sHalfCircle)
        halfCircleA.anchorPoint = CGPoint(x: 1, y: 0.5)
        let halfCircleB = SKSpriteNode(texture: sHalfCircle)
        halfCircleB.anchorPoint = CGPoint(x: 1, y: 0.5)
        halfCircleB.xScale = -1.0
        let lightningSegment = SKSpriteNode(texture: sLightningSegment)
        halfCircleA.yScale = thicknessScale
        halfCircleB.yScale = thicknessScale
        lightningSegment.yScale = thicknessScale
        halfCircleA.zRotation = angle
        halfCircleB.zRotation = angle
        lightningSegment.zRotation = angle
        lightningSegment.xScale = CGFloat(length*Float(2))
        
        //    halfCircleA.alpha = halfCircleB.alpha = 0.8f;
        halfCircleA.blendMode = SKBlendMode.alpha
        halfCircleB.blendMode = SKBlendMode.alpha
        lightningSegment.blendMode = SKBlendMode.alpha
        
        halfCircleA.position = startPointInThisNode
        halfCircleB.position = endPointInThisNode
        lightningSegment.position = CGPoint(x: (startPointInThisNode.x + endPointInThisNode.x)*0.5, y: (startPointInThisNode.y + endPointInThisNode.y)*0.5)
        self.addChild(halfCircleA)
        self.addChild(halfCircleB)
        self.addChild(lightningSegment)
    }
}

//
//  LineObject.swift
//  Curves
//
//  Created by Sebastian Haußmann on 28.04.16.
//  Copyright © 2016 Moritz Martin. All rights reserved.
//

import Foundation
import SpriteKit

class LineObject{
    
    var position: CGPoint = CGPoint()
    var path = CGPathCreateMutable()
    var lineNode = SKShapeNode()
    var wayPoints: [CGPoint] = []
    var head = SKShapeNode()
    var dead = false
    
    init(head: SKShapeNode,position: CGPoint, path: CGMutablePath, lineNode: SKShapeNode, wayPoints: [CGPoint], dead: Bool){
        self.head = head
        self.position = position
        self.path = path
        self.lineNode = lineNode
        self.wayPoints = wayPoints
        self.dead = dead
    }
    
    
    
}
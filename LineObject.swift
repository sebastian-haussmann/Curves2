//
//  LineObject.swift
//  Curves
//
//  Created by Sebastian Haußmann on 28.06.16.
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
    var lastPoint: CGPoint = CGPoint()
    var xCurve: CGFloat = CGFloat()
    var yCurve: CGFloat = CGFloat()
    var curveRadius: Double = Double()
    var curveSpeed: CGFloat = CGFloat()
    
    init(head: SKShapeNode,position: CGPoint, path: CGMutablePath, lineNode: SKShapeNode, wayPoints: [CGPoint], dead: Bool, lastPoint: CGPoint, xCurve: CGFloat, yCurve: CGFloat, curveRadius: Double, curveSpeed: CGFloat){
        self.head = head
        self.position = position
        self.path = path
        self.lineNode = lineNode
        self.wayPoints = wayPoints
        self.dead = dead
        self.lastPoint = lastPoint
        self.xCurve = xCurve
        self.yCurve = yCurve
        self.curveRadius = curveRadius
        self.curveSpeed = curveSpeed
    }
    
    
    
}
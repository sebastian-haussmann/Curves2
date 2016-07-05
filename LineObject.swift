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
    var lineNode = SKShapeNode()
    var wayPoints: [CGPoint] = []
    var head = SKShapeNode()
    var dead = false
    var lastPoint: CGPoint = CGPoint()
    var xSpeed: CGFloat = CGFloat()
    var ySpeed: CGFloat = CGFloat()
    var speed: CGFloat = CGFloat()
    var tail: [SKShapeNode] = []
    var score: Int = Int()
    
    init(head: SKShapeNode,position: CGPoint, lineNode: SKShapeNode, wayPoints: [CGPoint], dead: Bool, lastPoint: CGPoint, xSpeed: CGFloat, ySpeed: CGFloat, speed: CGFloat, tail: [SKShapeNode], score: Int){
        self.head = head
        self.position = position
        self.lineNode = lineNode
        self.wayPoints = wayPoints
        self.dead = dead
        self.lastPoint = lastPoint
        self.xSpeed = xSpeed
        self.ySpeed = ySpeed
        self.speed = speed
        self.tail = tail
        self.score = score
    }
    
    
    
}
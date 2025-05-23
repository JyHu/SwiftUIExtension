//
//  SwiftUIView.swift
//  
//
//  Created by hujinyou on 2024/5/12.
//

import SwiftUI

public extension Path {
    init(points: [CGPoint], closed: Bool = false) {
        self.init()
        
        for index in 0..<points.count {
            let point = points[index]
            if index == 0 {
                move(to: point)
            } else {
                addLine(to: point)
            }
        }
        
        if closed {
            addLine(to: points[0])
        }
    }
    
    mutating func moveTo(x: Double, y: Double) {
        addLine(to: CGPoint(x: x, y: y))
    }
    
    init(rectFrom point1: CGPoint, to point2: CGPoint) {
        self.init()
        move(to: point1)
        addLine(to: CGPoint(x: point1.x, y: point2.y))
        addLine(to: point2)
        addLine(to: CGPoint(x: point2.x, y: point1.y))
        addLine(to: point1)
    }
    
    init(rectWith point: CGPoint = .zero, size: CGSize) {
        self.init(rectFrom: point, to: CGPoint(x: point.x + size.width, y: point.y + size.height))
    }
    
    init(circleAt point: CGPoint, radius: Double) {
        self.init(ellipseIn: CGRect(
            x: point.x - radius,
            y: point.y - radius,
            width: radius * 2,
            height: radius * 2
        ))
    }
}

public extension Path {
    mutating func addLine(from fpoint: CGPoint, to tpoint: CGPoint) {
        move(to: fpoint)
        addLine(to: tpoint)
    }
    
    mutating func addHLine(fromX: Double, toX: Double, y: Double) {
        move(to: CGPoint(x: fromX, y: y))
        addLine(to: CGPoint(x: toX, y: y))
    }
    
    mutating func addVLine(fromY: Double, toY: Double, x: Double) {
        move(to: CGPoint(x: x, y: fromY))
        addLine(to: CGPoint(x: x, y: toY))
    }
    
    mutating func connect(points: [CGPoint]) {
        guard !points.isEmpty else { return }
        
        for point in points {
            addLine(to: point)
        }
    }
}

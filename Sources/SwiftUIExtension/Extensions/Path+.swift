//
//  SwiftUIView.swift
//  
//
//  Created by hujinyou on 2024/5/12.
//

import SwiftUI

extension Path {
    init(closed: Bool = false, points: CGPoint ...) {
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
        self.init(ellipseIn: CGRect(x: point.x - radius, y: point.y - radius, width: radius * 2, height: radius * 2))
    }
}

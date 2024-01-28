//
//  GeometryUtil.swift
//  CocoLocoMixer
//
//  Created by Romain Bigare on 30/01/2024.
//

import Foundation
import UIKit

func quadCurvedPath(with points: [CGPoint]) -> UIBezierPath {
    let path = UIBezierPath()
    var p1 = points[0]

    path.move(to: p1)

    if points.count == 2 {
        path.addLine(to: points[1])
        return path
    }

    for i in 1..<points.count {
        let mid = midPoint(for: (p1, points[i]))
        path.addQuadCurve(to: mid,
                          controlPoint: controlPoint(for: (mid, p1)))
        path.addQuadCurve(to: points[i],
                          controlPoint: controlPoint(for: (mid, points[i])))
        p1 = points[i]
    }
    return path
}

func midPoint(for points: (CGPoint, CGPoint)) -> CGPoint {
    return CGPoint(x: (points.0.x + points.1.x) / 2, y: (points.0.y + points.1.y) / 2)
}

func controlPoint(for points: (CGPoint, CGPoint)) -> CGPoint {
    var controlPoint = midPoint(for: points)
    let diffY = abs(points.1.y - controlPoint.y)

    if points.0.y < points.1.y {
        controlPoint.y += diffY
    } else if points.0.y > points.1.y {
        controlPoint.y -= diffY
    }
    return controlPoint
}

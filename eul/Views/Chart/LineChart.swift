//
//  LineChart.swift
//  eul
//
//  Created by Gao Sun on 2020/11/8.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SpriteKit
import SwiftUI

struct LineChart: View {
    static var defaultMaxPointCount = 10

    var points: [Double] = []
    var maxPointCount = defaultMaxPointCount
    var maximumPoint: Double = 100
    var minimumPoint: Double = 0
    var frame = CGSize(width: (AppDelegate.statusBarHeight - 4) * 1.75, height: AppDelegate.statusBarHeight - 4)

    var stepX: CGFloat {
        frame.width / (CGFloat(maxPointCount) - 1)
    }

    func getY(_ value: Double) -> CGFloat {
        CGFloat((value - minimumPoint) / (maximumPoint - minimumPoint)) * frame.height
    }

    // https://stackoverflow.com/a/63556358/12514940
    func path() -> Path {
        guard points.count > 1 else {
            return Path()
        }

        let xPoints = (0..<points.count).map { stepX * CGFloat($0) }
        let yPoints = points.map { getY($0) }
        let sequence = SKKeyframeSequence(keyframeValues: yPoints, times: xPoints.map { NSNumber(floatLiteral: Double($0)) })
        sequence.interpolationMode = .spline

        let maxX = stepX * CGFloat(points.count - 1)
        let splinedValues = stride(
            from: 0,
            through: maxX,
            by: 0.5
        ).map { CGPoint(x: $0, y: sequence.sample(atTime: $0) as? CGFloat ?? 0) }

        var path = Path()

        path.move(to: CGPoint(x: splinedValues[0].x, y: splinedValues[0].y))

        splinedValues.dropFirst().forEach {
            path.addLine(to: $0)
        }

        return path
    }

    func closedPath() -> Path {
        guard points.count > 1 else {
            return Path()
        }

        var path = self.path()

        path.addLine(to: CGPoint(x: stepX * CGFloat(points.count - 1), y: 0))
        path.addLine(to: CGPoint.zero)
        path.closeSubpath()

        return path
    }

    var body: some View {
        ZStack {
            Group {
                closedPath()
                    .fill(LinearGradient(gradient: Gradient(colors: [.text, Color.text.opacity(0.9)]), startPoint: .bottom, endPoint: .top))
                path()
                    .stroke(Color.text, style: StrokeStyle(lineWidth: 2, lineJoin: .round))
            }
            .rotationEffect(.degrees(180), anchor: .center)
            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            .drawingGroup()
        }
        .frame(width: frame.width, height: frame.height, alignment: .center)
    }
}

struct LineChart_Preview: PreviewProvider {
    static var previews: LineChart {
        LineChart(points: [10, 10, 10, 20, 20, 20, 30, 30, 30, 80])
    }
}

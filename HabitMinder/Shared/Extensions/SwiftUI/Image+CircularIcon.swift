//
//  Image+CircularIcon.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 07/04/2025.
//

import SwiftUI

extension Image {
    static func circularIcon(
        diameter: CGFloat,
        iconName: String,
        circleColor: UIColor,
        iconColor: UIColor
    ) -> UIImage {
        let size = CGSize(width: diameter, height: diameter)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        drawCircle(
            size: size,
            color: circleColor
        )
        drawIcon(
            named: iconName,
            color: iconColor,
            size: size
        )
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return finalImage
    }
    
    private static func drawCircle(
        size: CGSize,
        color: UIColor
    ) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        let rect = CGRect(
            origin: .zero,
            size: size
        )
        context.setFillColor(color.cgColor)
        context.fillEllipse(in: rect)
    }
    
    private static func drawIcon(
        named iconName: String,
        color: UIColor,
        size: CGSize
    ) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        let iconSize = CGSize(
            width: size.width * 0.5,
            height: size.height * 0.5
        )
        let iconRect = CGRect(
            x: (size.width - iconSize.width) / 2,
            y: (size.height - iconSize.height) / 2,
            width: iconSize.width,
            height: iconSize.height
        )
        
        let image = UIImage(systemName: iconName) ??
                    UIImage(named: iconName)
        
        if let icon = image?.withTintColor(
            color,
            renderingMode: .alwaysOriginal
        ) {
            context.saveGState()
            icon.draw(in: iconRect)
            context.restoreGState()
        }
    }
}

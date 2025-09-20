//
//  UIColorFromARGB.swift
//  SimpleYamap
//
//  Created by Mechislav Pugavko on 14/09/2025.
//


public func UIColorFromARGB(_ argb: Int64) -> UIColor {
    let alpha = CGFloat((argb >> 24) & 0xFF) / 255.0
    let red = CGFloat((argb >> 16) & 0xFF) / 255.0
    let green = CGFloat((argb >> 8) & 0xFF) / 255.0
    let blue = CGFloat(argb & 0xFF) / 255.0
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
}

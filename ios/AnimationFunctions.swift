//
//  AnimationFunctions.swift
//  Pods
//
//  Created by Mechislav Pugavko on 25/09/2025.
//

func easeInOut(progress: Double) -> Double {
    return -0.5 * (cos(Double.pi * progress) - 1)
}

//
//  YamapSimple.swift
//  
//
//  Created by Mechislav Pugavko on 13/09/2025.
//


import UIKit
import YandexMapsMobile

func UIColorFromARGB(_ argb: UInt32) -> UIColor {
    let alpha = CGFloat((argb >> 24) & 0xFF) / 255.0
    let red = CGFloat((argb >> 16) & 0xFF) / 255.0
    let green = CGFloat((argb >> 8) & 0xFF) / 255.0
    let blue = CGFloat(argb & 0xFF) / 255.0
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
}


@objc(RNYMapView)
public class RNYMapView: YMKMapView {
  private lazy var mapObjects = self.mapWindow.map.mapObjects
  private var drawPolygons = [String: YMKPolygonMapObject]()

  override public init(frame: CGRect, scaleFactor: Float, vulkanPreferred: Bool, lifecycleProvider: YRTLifecycleProvider!) {
      super.init(frame: frame, scaleFactor: scaleFactor, vulkanPreferred: vulkanPreferred, lifecycleProvider: lifecycleProvider)
      setupMap()
    }
  
  override public init(frame: CGRect, vulkanPreferred: Bool) {
      super.init(frame: frame, vulkanPreferred: vulkanPreferred)
      setupMap()
    }

    override public init(frame: CGRect) {
    super.init(frame: frame)
      setupMap()
      }
  
  
  @objc public func moveMap(lon: Double, lat: Double, zoom: Float, duration: Float, tilt: Float, azimuth: Float) {
    let cameraPosition = YMKCameraPosition(
                target: YMKPoint(latitude: lat, longitude: lon),
                zoom:zoom,
                azimuth: azimuth,
                tilt: tilt
            )
    
    self.mapWindow.map.move(
      with: cameraPosition,
      animation: YMKAnimation(type: .smooth, duration:duration)
      )
  }
  
  @objc public func enableNightMode() {
    self.mapWindow.map.isNightModeEnabled = true
  }
  
  @objc public func disableNightMode() {
    self.mapWindow.map.isNightModeEnabled = false
  }
  
  @objc public func setPolygons(_ polygons: [NSDictionary]) {
    let newPolygonsDict = Dictionary(uniqueKeysWithValues: polygons.map { ($0["id"] as! String, $0) })
    
    let newPolygonsIds = Set(newPolygonsDict.keys)
    let currentPolygonsIds = Set(drawPolygons.keys)
    
    // Remove polygons
    let idsToRemove = currentPolygonsIds.subtracting(newPolygonsIds)
    for id in idsToRemove {
      if let polygonObj = drawPolygons[id] {
        mapObjects.remove(with: polygonObj)
        drawPolygons.removeValue(forKey: id)
      }
    }
    
    // Add or update polygons
    for (id, polygonData) in newPolygonsDict {
      guard let pointsArr = polygonData["points"] as? [NSDictionary], pointsArr.count >= 3 else {
        continue // Skip polygons without enough points (<3)
      }
      let yandexPoints = pointsArr.map { pointDict -> YMKPoint in
        let lat = pointDict["lat"] as! Double
        let lon = pointDict["lon"] as! Double
        return YMKPoint(latitude: lat, longitude: lon)
      }
      
      // Now only for outer ring
      let polyGeom = YMKPolygon(
        outerRing: YMKLinearRing(points: yandexPoints),
        innerRings: []
      )
      
      if let existingPolygon = drawPolygons[id] {
          existingPolygon.geometry = polyGeom
          if let colorValue = polygonData["fillColor"], let colorNumber = colorValue as? NSNumber {
              existingPolygon.fillColor = UIColorFromARGB(colorNumber.uint32Value)
          }

          if let colorValue = polygonData["strokeColor"], let colorNumber = colorValue as? NSNumber {
              existingPolygon.strokeColor = UIColorFromARGB(colorNumber.uint32Value)
          }

          if let strokeWidth = polygonData["strokeWidth"] as? Float {
              existingPolygon.strokeWidth = strokeWidth
          }

      } else {
          let newPolyObj = mapObjects.addPolygon(with: polyGeom)

          if let colorValue = polygonData["fillColor"], let colorNumber = colorValue as? NSNumber {
              newPolyObj.fillColor = UIColorFromARGB(colorNumber.uint32Value)
          } else {
              newPolyObj.fillColor = .clear           }

          if let colorValue = polygonData["strokeColor"], let colorNumber = colorValue as? NSNumber {
              newPolyObj.strokeColor = UIColorFromARGB(colorNumber.uint32Value)
          } else {
              newPolyObj.strokeColor = .black
          }

          newPolyObj.strokeWidth = (polygonData["strokeWidth"] as? Float) ?? 1.0
        
        drawPolygons[id] = newPolyObj
      }
    }
  }
  
  private func setupMap() {
      

      self.mapWindow.map.move(
          with: YMKCameraPosition(
              target: YMKPoint(latitude: 55.751244, longitude: 37.618423),
              zoom: 100,
              azimuth: 0,
              tilt: 0
          )
      )
    }
  
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
}

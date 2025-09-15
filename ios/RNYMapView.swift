//
//  YamapSimple.swift
//  
//
//  Created by Mechislav Pugavko on 13/09/2025.
//


import UIKit
import YandexMapsMobile


@objc(RNYMapView)
public class RNYMapView: YMKMapView {
  private lazy var mapObjects = self.mapWindow.map.mapObjects
  private var propPolygons = [String: YMKPolygonMapObject]()

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
    let currentPolygonsIds = Set(propPolygons.keys)
    
    // Remove polygons
    let idsToRemove = currentPolygonsIds.subtracting(newPolygonsIds)
    for id in idsToRemove {
      if let polygonObj = propPolygons[id] {
        mapObjects.remove(with: polygonObj)
        propPolygons.removeValue(forKey: id)
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
      
      if let existingPolygon = propPolygons[id] {
          existingPolygon.geometry = polyGeom
          if let colorValue = polygonData["fillColor"], let colorNumber = colorValue as? NSNumber {
            existingPolygon.fillColor = UIColorFromARGB(colorNumber.int64Value)
          }

          if let colorValue = polygonData["strokeColor"], let colorNumber = colorValue as? NSNumber {
            existingPolygon.strokeColor = UIColorFromARGB(
              colorNumber.int64Value
            )
          }

          if let strokeWidth = polygonData["strokeWidth"] as? Float {
              existingPolygon.strokeWidth = strokeWidth
          }

      } else {
          let newPolyObj = mapObjects.addPolygon(with: polyGeom)

          if let colorValue = polygonData["fillColor"], let colorNumber = colorValue as? NSNumber {
            newPolyObj.fillColor = UIColorFromARGB(colorNumber.int64Value)
          } else {
              newPolyObj.fillColor = .clear           }

          if let colorValue = polygonData["strokeColor"], let colorNumber = colorValue as? NSNumber {
            newPolyObj.strokeColor = UIColorFromARGB(colorNumber.int64Value)
          } else {
              newPolyObj.strokeColor = .black
          }

          newPolyObj.strokeWidth = (polygonData["strokeWidth"] as? Float) ?? 1.0
        
        propPolygons[id] = newPolyObj
      }
    }
  }
  
  // Objects control
  public func getMapObjects() -> YMKMapObjectCollection {
    return self.mapObjects
  }
  
  // Polygons
  // Add polygon
  @objc public func addPolygonChild(_ polygonView: RNYMapPolygon) {
    polygonView.parentMapView = self // TODO: Check performance
    polygonView.updatePolygon() // Draw yourself
  }
  
  // Remove polygon
  @objc public func removePolygonChild(_ polygonView: RNYMapPolygon) {
    if let mapObject = polygonView.mapObject {
      mapObjects.remove(with: mapObject)
      polygonView.mapObject = nil
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

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

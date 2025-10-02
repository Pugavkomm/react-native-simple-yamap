//
//  YamapSimple.swift
//
//
//  Created by Mechislav Pugavko on 13/09/2025.
//


import UIKit
import YandexMapsMobile


public typealias CameraPositionCallback = (NSDictionary) -> Void


@objc(RNYMapView)
public class RNYMapView: YMKMapView, YMKMapCameraListener{
  
  // Events
  @objc public var onCameraPositionChange: CameraPositionCallback?
  @objc public var onCameraPositionChangeEnd: CameraPositionCallback?
  
  // Props
  
  
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
  
  
  
  
  // Set center
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
  
  // Night mode control
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
  
  
  //Circles
  // Add circle to map
  @objc public func addCircleChild(_ circleView: RNYMapCircle) {
    circleView.parentMapView = self
    circleView.updateCircle() // Draw yourself
  }
  
  // Remove circle
  @objc public func removeCircleChild(_ circleView: RNYMapCircle) {
    if let mapObject = circleView.mapObject {
      mapObjects.remove(with: mapObject)
      circleView.mapObject = nil
    }
  }
  
  // Markers
  // Add marker to map
  @objc public func addMarkerChild(_ markerView: RNYMapMarker) {
    markerView.parentMapView = self
    markerView.updateMarker() // Draw yourself
  }
  
  // Remove marker from map
  @objc public func removeMarkerChild(_ markerView: RNYMapMarker) {
    if let mapObject = markerView.mapObject {
      mapObjects.remove(with: mapObject)
      markerView.mapObject = nil
    }
  }
  
  private func setupMap() {
    self.mapWindow.map.addCameraListener(with: self)
  }
  
  public func onCameraPositionChanged(
     with map: YMKMap,
     cameraPosition: YMKCameraPosition,
     cameraUpdateReason: YMKCameraUpdateReason,
     finished: Bool
   ) {
     let payload: [String: Any] = [
       "lon": cameraPosition.target.longitude,
       "lat": cameraPosition.target.latitude,
       "zoom": cameraPosition.zoom,
       "tilt": cameraPosition.tilt,
       "azimuth": cameraPosition.azimuth,
       "reason": cameraUpdateReason == .gestures ? "GESTURES" : "APPLICATION",
       "finished": finished
     ]
     
     self.onCameraPositionChange?(payload as NSDictionary)
     
     if (finished) {
       self.onCameraPositionChangeEnd?(payload as NSDictionary)
     }
   }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

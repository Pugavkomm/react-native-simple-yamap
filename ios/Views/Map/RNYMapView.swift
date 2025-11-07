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
  
  deinit {
      self.mapWindow.map.removeCameraListener(with: self)
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
    DispatchQueue.main.async{[weak self, weak polygonView] in
      guard let self = self else { return }
      guard let polygonView = polygonView  else {return}
      guard let mapObjToRemove = polygonView.mapObject else {
        return
      }
      polygonView.mapObject = nil
      mapObjects.remove(with: mapObjToRemove)
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
    DispatchQueue.main.async {[weak self, weak circleView] in
      guard let self = self else {return}
      guard let circleView = circleView else {return}
      guard let mapObjToRemove = circleView.mapObject else {
        return
      }
      circleView.mapObject = nil
      mapObjects.remove(with: mapObjToRemove)
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
    DispatchQueue.main.async {[weak self, weak markerView] in
      guard let self = self else {return}
      guard let markerView = markerView else {return}
      guard let mapObjToRemove = markerView.mapObject else {
        return }
      markerView.mapObject = nil
      mapObjects.remove(with: mapObjToRemove)
    }
  }
  
  
  // Polylines
  // Add polyline to map
  @objc public func addPolyLineChild(_ polyLineView: RNYMapPolyLine){
    polyLineView.parentMapView = self
    polyLineView.updatePolyLine()
  }
  
  
  // Remove polyline from map
  @objc public func removePolyLineChild(_ polyLineView: RNYMapPolyLine){
    if let mapObject = polyLineView.mapObject {
      mapObjects.remove(with: mapObject)
      polyLineView.mapObject = nil
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

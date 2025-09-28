//
//  RNYMapCircle.swift
//
//  Created by Mechislav Pugavko on 24/09/2025.
//

import YandexMapsMobile


@objc(RNYMapCircle)
public class RNYMapCircle: UIView {
  private var FRAMES_PER_SECOND = 60.0
  var mapObject: YMKCircleMapObject?
  @objc public weak var parentMapView: RNYMapView?
  @objc public var id: NSString = "" // Reserved
  @objc public var circleCenter: NSDictionary = [:] {
    didSet {updateCircle()}
  }
  @objc public var radius: Float = 1.0 {
    didSet{updateRadius(radius: radius )}
  }
  @objc public var fillColor: NSNumber? {
    didSet { updateCircleFillColor() }
  }
  @objc public var strokeColor: NSNumber? {
    didSet { updateCircleStrokeColor() }
  }
  @objc public var strokeWidth: NSNumber? {
    didSet { updateCircleStrokeWidth() }
  }
  @objc public var zIndexV: NSNumber? {
    didSet { updateCircleZIndex()}
  }
  
  
  override public func didMoveToSuperview() {
    super.didMoveToSuperview()
    if let mapView = self.superview as? RNYMapView {
      self.parentMapView = mapView
    } else if self.superview == nil {
      parentMapView?.removeCircleChild(self)
      self.parentMapView = nil
    }
  }
  
  override public func removeFromSuperview() {
    super.removeFromSuperview()
  }
  
  private func getOrCreateMapObject() -> YMKCircleMapObject? {
    guard let mapView = parentMapView else {return nil}
    let mapObjects = mapView.getMapObjects()
    if let existingObject = self.mapObject {
      return existingObject;
    } else {
      let newCircle = mapObjects.addCircle(
        with: YMKCircle()
      )
      self.mapObject = newCircle
      return newCircle
    }
  }
  
  private func updateRadius(radius: Float) {
    if (radius == mapObject?.geometry.radius){
      return
    }
    guard let center = mapObject?.geometry.center else {return}
    let newCirclerGeom = YMKCircle(center: center, radius: radius);
    mapObject?.geometry = newCirclerGeom;
  }
  
  @objc public func animatedMove(pointDict: NSDictionary, duration: Float, radius: Float) {
    // First step -- update radius
    // Second state -- update position
    guard let lat = pointDict["lat"] as? Double,
          let lon = pointDict["lon"] as? Double,
          let circle = self.mapObject,
          duration > 0 else {
      return
    }
    let startPosition = circle.geometry.center
    let endPosition = YMKPoint(latitude: lat, longitude: lon)
    let deltaLat =  endPosition.latitude - startPosition.latitude
    let deltaLon = endPosition.longitude - startPosition.longitude
    
    let totalFrames = Int(Double(duration) * FRAMES_PER_SECOND)
    moveAnimLoop(
      frame: 1,
      totalFrames: totalFrames,
      startPoint: startPosition,
      deltaLat: deltaLat,
      deltaLon: deltaLon
    )
    
    updateRadius(radius: radius)
  }
  
  
  // TODO: DUPLICATE IN MARKER. REFACTOR
  private func moveAnimLoop(frame: Int, totalFrames: Int, startPoint: YMKPoint, deltaLat: Double, deltaLon: Double) {
    guard frame <= totalFrames else {
      return
    }
    
    let progress = Double(frame) / Double(totalFrames)
    let easedProgress =  easeInOut(
      progress: progress
    )
    let cLat = startPoint.latitude + (deltaLat * easedProgress)
    
    let cLon = startPoint.longitude + (deltaLon * easedProgress)
    let newPosition = YMKCircle(
      center:  YMKPoint( latitude: cLat, longitude: cLon),
      radius: mapObject?.geometry.radius ?? radius // old radius or from props
    )
    self.mapObject?.geometry = newPosition
    
    let deadline = DispatchTime.now() + (1.0 / FRAMES_PER_SECOND)
    DispatchQueue.main.asyncAfter(deadline: deadline) { [weak self] in
      self?.moveAnimLoop(frame: frame + 1, totalFrames: totalFrames, startPoint: startPoint, deltaLat: deltaLat, deltaLon: deltaLon)
    }
  }
  
  private func updateCircleGeom() {
    guard let circle = getOrCreateMapObject() else {return}
    let circleGeomCenter = YMKPoint(
      latitude: self
        .circleCenter["lat"] as! Double, longitude: self
        .circleCenter["lon"] as! Double
    )
    let circleGeom = YMKCircle(center: circleGeomCenter, radius: radius)
    circle.geometry = circleGeom
  }
  
  private func updateCircleFillColor(){
    guard let circle = getOrCreateMapObject() else {return}
    if (fillColor == nil){
      circle.fillColor = UIColor.clear
      return
    }
    if let colorValue = fillColor, let color = colorValue as? Int64 {
      circle.fillColor  = UIColorFromARGB(color)
    }
    
  }
  
  private func updateCircleStrokeColor() {
    guard let circle = getOrCreateMapObject() else {return}
    if(strokeColor == nil) {
      circle.strokeColor = UIColor.clear
      return
    }
    if let colorValue = strokeColor, let color = colorValue as? Int64 {
      circle.strokeColor = UIColorFromARGB(color)
    }
  }
  
  private func updateCircleStrokeWidth() {
    guard let circle = getOrCreateMapObject() else {return}
    circle.strokeWidth = strokeWidth?.floatValue ?? 0.0
  }
  
  private func updateCircleZIndex() {
    guard let circle = getOrCreateMapObject() else {return}
    circle.zIndex = zIndexV?.floatValue ?? 0.0
  }
  
  public func updateCircle() {
    updateCircleGeom()
    updateRadius(radius: radius)
    updateCircleFillColor()
    updateCircleStrokeColor()
    updateCircleStrokeWidth()
    updateCircleZIndex()
  }
}


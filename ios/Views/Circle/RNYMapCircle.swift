//
//  RNYMapCircle.swift
//
//  Created by Mechislav Pugavko on 24/09/2025.
//

import YandexMapsMobile


@objc(RNYMapCircle)
public class RNYMapCircle: UIView {
  var mapObject: YMKCircleMapObject?
  @objc public weak var parentMapView: RNYMapView?
  @objc public var id: NSString = "" // Reserved
  @objc public var circleCenter: NSDictionary = [:] {
    didSet {updateCircle()}
  }
  @objc public var radius: Float = 1.0 {
    didSet{updateCircle()}
  }
  @objc public var fillColor: NSNumber? {
    didSet { updateCircle() }
  }
  @objc public var strokeColor: NSNumber? {
    didSet { updateCircle() }
  }
  @objc public var strokeWidth: NSNumber? {
    didSet { updateCircle() }
  }
  @objc public var zIndexV: NSNumber? {
    didSet { updateCircle()}
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
  
  private func getOrCreateMapObject(mapObjects: YMKMapObjectCollection) -> YMKCircleMapObject {
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
  
    
  // TODO: Optimize rerender!
  public func updateCircle() {
    guard let mapView = parentMapView else {return}
    let mapObjects = mapView.getMapObjects()
    let circleGeomCenter = YMKPoint(
      latitude: self
        .circleCenter["lat"] as! Double, longitude: self
        .circleCenter["lon"] as! Double
    )
    let circleGeom = YMKCircle(center: circleGeomCenter, radius: radius)
    let circle = getOrCreateMapObject(mapObjects: mapObjects)
    circle.geometry = circleGeom
    if let colorValue = fillColor, let color = colorValue as? Int64 {
      circle.fillColor  = UIColorFromARGB(color)
    }
    if let colorValue = strokeColor, let color = colorValue as? Int64 {
      circle.strokeColor = UIColorFromARGB(color)
    }
    circle.strokeWidth = strokeWidth?.floatValue ?? 1.0
    self.mapObject = circle;
    circle.zIndex = zIndexV?.floatValue ?? 0.0
  }
}


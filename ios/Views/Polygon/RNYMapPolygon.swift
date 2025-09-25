//
//  RNYMapPolygon.swift
//  SimpleYamap
//
//  Created by Mechislav Pugavko on 14/09/2025.
//

import YandexMapsMobile


@objc(RNYMapPolygon)
public class RNYMapPolygon: UIView {
  var mapObject: YMKPolygonMapObject?
  
  
  @objc public var id: NSString = ""
  @objc public var outerRing: [NSDictionary] = [] {
    didSet { updatePolygon() }
  }
  @objc public var innerRings: [[NSDictionary]] = [] {
    didSet {updatePolygon()}
  }
  @objc public var fillColor: NSNumber? {
    didSet { updatePolygon() }
  }
  @objc public var strokeColor: NSNumber? {
    didSet { updatePolygon() }
  }
  @objc public var strokeWidth: NSNumber? {
    didSet { updatePolygon() }
  }
  
  @objc public weak var parentMapView: RNYMapView?
  
  override public func didMoveToSuperview() {
    super.didMoveToSuperview()
    if let mapView = self.superview as? RNYMapView {
      self.parentMapView = mapView
    } else if self.superview == nil {
      // TODO: Check this logic
      self.parentMapView = nil
    }
  }
  
  override public func removeFromSuperview() {
    parentMapView?.removePolygonChild(self)
    super.removeFromSuperview()
  }
  
  public func updatePolygon() {
    guard let mapView = parentMapView else {return}
    let mapObjects = mapView.getMapObjects()
    
    if let existingObject = self.mapObject {
      mapObjects.remove(with: existingObject)
      self.mapObject = nil
    }
    
    // TODO: Refactor. No recreate, just update if exists polygon on Map already
    guard outerRing.count >= 3 else {return}
    let outerPoints = outerRing.map { pointDict -> YMKPoint in
      let lat = pointDict["lat"] as! Double
      let lon = pointDict["lon"] as! Double
      return YMKPoint(latitude: lat, longitude: lon)
    }
    
    let innerRingsArray = innerRings.map { pointsList -> YMKLinearRing in
      let yandexPoints = pointsList.map { pointDict -> YMKPoint in
        guard let lat = pointDict["lat"] as? Double,
              let lon = pointDict["lon"] as? Double else {
          fatalError("Invalid point dictionary format")
        }
        return YMKPoint(latitude: lat, longitude: lon)
      }
      
      return YMKLinearRing(points: yandexPoints)
    }
    
    let polygonGeometry = YMKPolygon(
      outerRing: YMKLinearRing(points: outerPoints),
      innerRings: innerRingsArray
    )
    let newMapObject = mapObjects.addPolygon(with: polygonGeometry)
    
    if let colorValue = fillColor, let color = colorValue as? Int64 {
      newMapObject.fillColor = UIColorFromARGB(color)
    }
    if let colorValue = strokeColor, let color = colorValue as? Int64 {
      newMapObject.strokeColor = UIColorFromARGB(color)
    }
    newMapObject.strokeWidth = strokeWidth?.floatValue ?? 1.0
    
    self.mapObject = newMapObject
  }
}


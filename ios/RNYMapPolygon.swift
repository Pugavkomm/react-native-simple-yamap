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
  @objc public var points: [NSDictionary] = [] {
    didSet { updatePolygon() }
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
      mapView.addPolygonChild(self)
    } else if self.superview == nil {
      // TODO: Check this logic
      parentMapView?.removePolygonChild(self)
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
    guard points.count >= 3 else {return}
    let yandexPoints = points.map { pointDict -> YMKPoint in
      let lat = pointDict["lat"] as! Double
      let lon = pointDict["lon"] as! Double
      return YMKPoint(latitude: lat, longitude: lon)
    }
    let polygonGeometry = YMKPolygon(outerRing: YMKLinearRing(points: yandexPoints), innerRings: [])
    let newMapObject = mapObjects.addPolygon(with: polygonGeometry)
    
    if let colorValue = fillColor, let color = colorValue as? Int64 {
      print("Call update fill color: ", colorValue)
      newMapObject.fillColor = UIColorFromARGB(color)
    }
    if let colorValue = strokeColor, let color = colorValue as? Int64 {
      print("Call update stroke color: ", colorValue)
      newMapObject.strokeColor = UIColorFromARGB(color)
    }
    newMapObject.strokeWidth = strokeWidth?.floatValue ?? 1.0
    
    self.mapObject = newMapObject
  }
}
  

//
//  RNYMapPolyLine.swift
//  Pods
//
//  Created by Mechislav Pugavko on 03/10/2025.
//

import YandexMapsMobile

let DEFAULT_POLYLINE_COLOR = UIColor.clear
let DEFAULT_POLYLINE_STROKE_WIDTH: Float = 1.0
let DEFAULT_POLYLINE_OUTLINE_WIDTH: Float = 1.0

@objc(RNYMapPolyLine)
public class RNYMapPolyLine: UIView {
  @objc public weak var parentMapView: RNYMapView?
  var mapObject: YMKPolylineMapObject?
  
  @objc public var id: NSString = "" // Reserved
  @objc public var strokeColor: NSNumber? {
    didSet {updateStrokeColor()}
  }
  @objc public var outlineColor: NSNumber? {
    didSet {updateOutlineColor()}
  }
  @objc public var strokeWidth: NSNumber?{
    didSet {updateStrokeWidth()}
  }
  @objc public var outlineWidth: NSNumber?{
    didSet {updateOutlineWidth()}
  }
  @objc public var points: [NSDictionary] = [] {
    didSet {updatePolyLineGeometry()}
  }
  
  override public func didMoveToSuperview() {
    super.didMoveToSuperview()
    if let mapView = self.superview as? RNYMapView {
      self.parentMapView = mapView
    } else if self.superview == nil {
      parentMapView?.removePolyLineChild(self)
      self.parentMapView = nil
    }
  }
  
  override public func removeFromSuperview() {
    super.removeFromSuperview()
  }
  
  /**
   Returns polyline geometry from prop 'points'
   
   - Returns: poliline geometry from points
   */
  private func prepareGeometryFromProp() -> YMKPolyline {
    let linePoints = points.map {pointDict -> YMKPoint in
      let lat = pointDict["lat"] as! Double
      let lon = pointDict["lon"] as! Double
      return YMKPoint(latitude: lat, longitude: lon)
    }
    return YMKPolyline(points: linePoints)
  }
  
  /**
   Returns new or old map object.
   
   - Returns: polyline from mapObject or new polyline
   */
  private func getOrCreateMapObject() -> YMKPolylineMapObject? {
    guard let mapView = parentMapView else {return nil}
    if let existingObject = self.mapObject{
      return existingObject
    } else {
      let mapObjects = mapView.getMapObjects()
      let geometry = prepareGeometryFromProp()
      let style = YMKLineStyle()
      let newPolyLine = mapObjects.addPolyline(with: geometry)
      newPolyLine.style = style
      self.mapObject = newPolyLine
      return newPolyLine
    }
  }
  
  /**
   Update geometry from points
   */
  private func updatePolyLineGeometry() {
    guard let polyLine = getOrCreateMapObject() else {return}
    let polyLineGeometry = prepareGeometryFromProp()
    polyLine.geometry = polyLineGeometry
  }
  
  /**
   Update stroke width in unus from props
   */
  private func updateStrokeWidth() {
    guard let polyline = getOrCreateMapObject() else {return}
    let style = polyline.style
    if let width = strokeWidth, let w = width as? Float {
      style.strokeWidth = w
    } else {
      style.strokeWidth = DEFAULT_POLYLINE_STROKE_WIDTH
    }
    polyline.style = style
  }
  
  /**
   Update outline width in units from props
   */
  private func updateOutlineWidth() {
    guard let polyline = getOrCreateMapObject() else {return}
    let style = polyline.style
    if let width = outlineWidth, let w = width as? Float {
      style.outlineWidth = w
    } else {
      style.outlineWidth = DEFAULT_POLYLINE_OUTLINE_WIDTH
    }
    
    polyline.style = style
  }
  
  /**
  Update outline color from prop
   */
  private func updateOutlineColor() {
    guard let polyline = getOrCreateMapObject() else {return}
    let style = polyline.style
    if let colorValue = outlineColor, let color = colorValue as? Int64 {
      style.outlineColor = UIColorFromARGB(color)
    } else {
      style.outlineColor = DEFAULT_POLYLINE_COLOR
    }
    polyline.style = style
  }
  
  private func updateStrokeColor() {
    guard let polyLine = getOrCreateMapObject() else {return}
    if let colorValue = strokeColor, let color = colorValue as? Int64 {
      polyLine.setStrokeColorWith(UIColorFromARGB(color))
    } else {
      polyLine.setStrokeColorWith( DEFAULT_POLYLINE_COLOR)
    }
  }
  
  /**
   Full update poly line object
   */
  @objc public func updatePolyLine(){
    updatePolyLineGeometry()
    updateStrokeWidth()
    updateStrokeColor()
    updateOutlineWidth()
    updateOutlineColor()
  }
}


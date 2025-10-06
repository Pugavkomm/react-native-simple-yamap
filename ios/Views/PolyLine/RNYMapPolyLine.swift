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
  @objc public var zIndexV: NSNumber?{
    didSet {updatePolyLineZIndex()}
  }
  @objc public var strokeColor: NSNumber? {
    didSet {updatePolyLineStrokeColor()}
  }
  @objc public var outlineColor: NSNumber? {
    didSet {updatePolyLineOutlineColor()}
  }
  @objc public var strokeWidth: NSNumber?{
    didSet {updatePolyLineStrokeWidth()}
  }
  @objc public var outlineWidth: NSNumber?{
    didSet {updatePolyLineOutlineWidth()}
  }
  @objc public var points: [NSDictionary] = [] {
    didSet {updatePolyLineGeometry()}
  }
  @objc public var dashLength: NSNumber = 0.0 {
    didSet {updatePolyLineDashLength()}
  }
  @objc public var gapLength: NSNumber = 0.0 {
    didSet {updatePolyLineGapLength()}
  }
  @objc public var dashOffset: NSNumber = 0.0 {
    didSet {updatePolyLineDashOffset()}
  }
  @objc public var turnRadius: NSNumber = 16.0 {
    didSet {updatePolyLineTurnRadius()}
  }
  @objc public var arcApproximationStep: NSNumber = 10.0{
    didSet {updateArcApproximationStep()}
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
  private func updatePolyLineStrokeWidth() {
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
  private func updatePolyLineOutlineWidth() {
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
  private func updatePolyLineOutlineColor() {
    guard let polyline = getOrCreateMapObject() else {return}
    let style = polyline.style
    if let colorValue = outlineColor, let color = colorValue as? Int64 {
      style.outlineColor = UIColorFromARGB(color)
    } else {
      style.outlineColor = DEFAULT_POLYLINE_COLOR
    }
    polyline.style = style
  }
  
  /**
   Update stroke color from props
   */
  private func updatePolyLineStrokeColor() {
    guard let polyLine = getOrCreateMapObject() else {return}
    if let colorValue = strokeColor, let color = colorValue as? Int64 {
      polyLine.setStrokeColorWith(UIColorFromARGB(color))
    } else {
      polyLine.setStrokeColorWith( DEFAULT_POLYLINE_COLOR)
    }
  }
  
  /**
   Update z index from props
   */
  private func updatePolyLineZIndex() {
    guard let polyLine = getOrCreateMapObject() else {return}
    if let zIndex = zIndexV, let zIdx = zIndex as? Float {
      polyLine.zIndex = zIdx
    }
  }
  
  /**
   Update length of dash in units from props
   */
  private func updatePolyLineDashLength() {
    guard let polyline = getOrCreateMapObject() else {return}
    if let length = dashLength as? Float{
      let style = polyline.style
      style.dashLength = length
      polyline.style = style
    }
  }
  
  /**
   Update length of gap between two dashes in units from props
   */
  private func updatePolyLineGapLength() {
    guard let polyline = getOrCreateMapObject() else {return}
    if let length = gapLength as? Float {
      let style = polyline.style
      style.gapLength = length
      polyline.style = style
    }
  }
  
  /**
   Update offset from the start of the polyline to the reference dash in units from props
   */
  private func updatePolyLineDashOffset() {
    guard let polyline = getOrCreateMapObject() else {return}
    if let offset = dashOffset as? Float {
      let style = polyline.style
      style.dashOffset = offset
      polyline.style = style
    }
    
  }
  
  /**
   Update maximum radius of a turn from props
   */
  private func updatePolyLineTurnRadius() {
    guard let polyline = getOrCreateMapObject() else {return}
    if let tRadius = turnRadius as? Float {
      let style = polyline.style
      style.turnRadius = tRadius
      polyline.style = style
    }
  }
  
  /**
   Update step of arc approximation from props
   */
  private func updateArcApproximationStep() {
    guard let polyline = getOrCreateMapObject() else {return}
    if let arc = arcApproximationStep as? Float {
      let style = polyline.style
      style.arcApproximationStep = arc
      polyline.style = style
    }
  }
  /**
   Full update poly line object
   
   This method can be used for intialization
   */
  @objc public func updatePolyLine(){
    updatePolyLineGeometry()
    updatePolyLineStrokeWidth()
    updatePolyLineStrokeColor()
    updatePolyLineOutlineWidth()
    updatePolyLineOutlineColor()
    updatePolyLineZIndex()
    updatePolyLineDashLength()
    updatePolyLineGapLength()
    updatePolyLineDashOffset()
    updatePolyLineTurnRadius()
    updateArcApproximationStep()
  }
}


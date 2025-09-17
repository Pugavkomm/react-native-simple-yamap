//
//  RNYMapMarker.swift
//  SimpleYamap
//
//  Created by Mechislav Pugavko on 15/09/2025.
//

import YandexMapsMobile


@objc(RNYMapMarker)
public class RNYMapMarker: UIView {
  private let FRAMES_PER_SECOND = 60.0 // Number of frames for marker animations
  var mapObject: YMKPlacemarkMapObject?
  @objc public weak var parentMapView: RNYMapView?
  
  
  @objc public var id: NSString = ""
  @objc public var point: NSDictionary = [:] {
    didSet {updateMarker()}
  }
  
  @objc public var text: String = "" {
    didSet {updateMarker()}
  }
  
  @objc public var iconSource: NSString? = "" {
    didSet {updateMarker()}
  }
  
  @objc public var iconScale: NSNumber = 1.0 {
    didSet {updateMarker()}
  }
  
  @objc public var iconRotated: Bool = false {
    didSet {updateMarker()}
  }
  
  @objc public var iconAnchor: NSValue = NSValue(cgPoint: CGPoint(x: 0.5, y:0.5)) {
    didSet {updateMarker()}
  }
  
  @objc public var zIndexV: NSNumber = 0.0 {
    didSet {updateMarker()}
  }
  
  // TODO optimize perfromance after setup all
  
  // TODO: textStyle...
  
  
  override public func didMoveToSuperview() {
    super.didMoveToSuperview()
    if let mapView = self.superview as? RNYMapView {
      self.parentMapView = mapView
      mapView.addMarkerChild(self)
    } else if self.superview == nil {
      // TODO: Check this logic. Dublicate logic. Like polygon
      parentMapView?.removeMarkerChild(self)
      self.parentMapView = nil
    }
  }
  
  override public func removeFromSuperview() {
    parentMapView?.removeMarkerChild(self)
    super.removeFromSuperview()
  }
  
  @objc public func animatedRotate(angle: Float, duration: Float) {
    guard let marker = self.mapObject, duration > 0 else {
      return
    }
    
    let startDirection = marker.direction
    
    let delta = angle - startDirection
    let totalFrames = Int(Double(duration) * FRAMES_PER_SECOND)
    
    rotateAnimationLoop(
      frame: 1,
      totalFrames: totalFrames,
      startDirection: startDirection,
      delta: delta
    )
  }
  
  private func rotateAnimationLoop(frame: Int, totalFrames: Int, startDirection: Float, delta: Float) {
    guard frame <= totalFrames, let marker = self.mapObject else {
      return
    }
    
    let progress = Float(frame) / Float(totalFrames)
    //TODO: different types of rotation
    // Ease in out animation
    let easedProgress = Float(-0.5 * (cos(Double.pi * Double(progress)) - 1))
    marker.direction = startDirection + (delta * easedProgress)
    
    let deadline = DispatchTime.now() + (1.0 / FRAMES_PER_SECOND)
    DispatchQueue.main.asyncAfter(deadline: deadline) { [weak self] in
      self?.rotateAnimationLoop(
        frame: frame + 1,
        totalFrames: totalFrames,
        startDirection: startDirection,
        delta: delta
      )
    }
  }
  
  @objc public func animatedMove(pointDict: NSDictionary, duration: Float) {
    // This block like volga/yamap
    guard let lat = pointDict["lat"] as? Double,
          let lon = pointDict["lon"] as? Double,
          let marker = self.mapObject,
          duration > 0 else {
      return
    }
    
    let startPosition = marker.geometry
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
  }
  
  private func moveAnimLoop(frame: Int, totalFrames: Int, startPoint: YMKPoint, deltaLat: Double, deltaLon: Double) {
    // Return condition: Final the loop
    guard frame <= totalFrames else {
      return
    }
    
    // Update Stage
    let progress = Double(frame) / Double(totalFrames)
    let easedProgress = -0.5 * (cos(Double.pi * Double(progress)) - 1)
    let cLat = startPoint.latitude + (deltaLat * easedProgress)
    let cLon = startPoint.longitude + (deltaLon * easedProgress)
    let newPosition = YMKPoint(latitude: cLat, longitude: cLon)
    self.mapObject?.geometry = newPosition
    
    // Next Frame
    // Recurse call with weak link
    let deadline = DispatchTime.now() + (1.0 / FRAMES_PER_SECOND)
    DispatchQueue.main.asyncAfter(deadline: deadline) { [weak self] in
      self?.moveAnimLoop(frame: frame + 1, totalFrames: totalFrames, startPoint: startPoint, deltaLat: deltaLat, deltaLon: deltaLon)
    }
  }
  
  
  
  private func getOrCreateMapObject(mapObjects: YMKMapObjectCollection) -> YMKPlacemarkMapObject {
    if let existingObject = self.mapObject {
      return existingObject
    } else {
      let newPlacemark = mapObjects.addPlacemark()
      self.mapObject = newPlacemark
      return newPlacemark
    }
  }
  
  private func loadImage(from source: String, completion: @escaping (UIImage?) -> Void) {
    if let localImage = UIImage(named: source) {
      completion(localImage)
      return
    }
    
    guard let url = URL(string: source) else {
      print("Error: Invalid image asset name or URL string: \(source)")
      completion(nil)
      return
    }
    
    DispatchQueue.global(qos: .userInitiated).async {
      if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
        completion(image)
      } else {
        completion(nil)
      }
    }
  }
  
  private func updateIcon(marker: YMKPlacemarkMapObject) {
    guard let source = self.iconSource as String?, !source.isEmpty else {
      return
    }
    loadImage(from: source) { [weak self, weak marker] image in
      guard let self = self, let marker = marker, let finalImage = image else {
        print("Error: Failed to load image from source: \(source)")
        return
      }
      DispatchQueue.main.async {
        let iconStyle = YMKIconStyle()
        iconStyle.scale = self.iconScale
        iconStyle.rotationType = self.iconRotated ? 1 : 0 // 0 - no rotate, 1 - rotate
        iconStyle.anchor = self.iconAnchor
        iconStyle.zIndex = self.zIndexV
        marker.setIconWith(finalImage, style: iconStyle)
      }
    }
  }
  
  public func updateMarker() {
    guard let mapView = parentMapView else {return}
    let mapObjects = mapView.getMapObjects()
    
    
    let marker = getOrCreateMapObject(mapObjects: mapObjects)
    
    let markerGeom = YMKPoint(
      latitude: self.point["lat"] as! Double,
      longitude: self.point["lon"] as! Double
    )
    
    marker.geometry = markerGeom
    if (!self.text.isEmpty){
      marker.setTextWithText(self.text)
    } else {
      marker.setTextWithText("")
    }
    self.mapObject = marker
    updateIcon(marker: marker)
    
  }
}


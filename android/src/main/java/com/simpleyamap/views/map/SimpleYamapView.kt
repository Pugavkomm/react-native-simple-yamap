// SimpleYamapView

package com.simpleyamap.views.map

import android.content.Context
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactContext
import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.UIManagerHelper
import com.facebook.react.uimanager.events.Event
import com.simpleyamap.views.circle.SimpleYamapCircleView
import com.simpleyamap.views.marker.SimpleYamapMarkerView
import com.simpleyamap.views.polyLine.SimpleYamapPolyLineView
import com.simpleyamap.views.polygon.SimpleYamapPolygonView
import com.yandex.mapkit.Animation
import com.yandex.mapkit.MapKitFactory
import com.yandex.mapkit.map.CameraListener
import com.yandex.mapkit.map.CameraPosition
import com.yandex.mapkit.map.CameraUpdateReason
import com.yandex.mapkit.map.Map
import com.yandex.mapkit.map.MapObjectCollection
import com.yandex.mapkit.mapview.MapView
import com.yandex.mapkit.geometry.Point as YandexPoint

class SimpleYamapView(context: Context) : MapView(context), CameraListener {
  private val mapObjects: MapObjectCollection = mapWindow.map.mapObjects

  init {
    mapWindow.map.addCameraListener(this)
  }

  override fun onCameraPositionChanged(
    map: Map,
    cameraPosition: CameraPosition,
    cameraUpdateReason: CameraUpdateReason,
    finished: Boolean
  ) {
    sendCameraPositionEvent(
      "topCameraPositionChange",
      cameraPosition,
      cameraUpdateReason.toString(),
      true
    )
    if (finished) {
      sendCameraPositionEvent(
        "topCameraPositionChangeEnd",
        cameraPosition,
        cameraUpdateReason.toString(),
        false
      )
    }
  }

  private fun sendCameraPositionEvent(
    eventName: String,
    position: CameraPosition,
    reason: String,
    finished: Boolean
  ) {
    val evData = Arguments.createMap().apply {
      putDouble("lon", position.target.longitude)
      putDouble("lat", position.target.latitude)
      putDouble("zoom", position.zoom.toDouble())
      putDouble("azimuth", position.azimuth.toDouble())
      putDouble("tilt", position.tilt.toDouble())
      putString("reason", reason)
      putBoolean("finished", finished)
    }

    val reactContext = context as ReactContext
    val eventDispatcher = UIManagerHelper.getEventDispatcherForReactTag(reactContext, id)
    eventDispatcher?.dispatchEvent(
      CameraPositionEvent(UIManagerHelper.getSurfaceId(this), id, eventName, evData)
    )
  }

  fun moveMap(lon: Double, lat: Double, zoom: Float, duration: Float, tilt: Float, azimuth: Float) {
    val cameraPosition = CameraPosition(
      YandexPoint(lat, lon),
      zoom,
      azimuth,
      tilt
    )
    if (duration > 0) {
      mapWindow.map.move(
        cameraPosition,
        Animation(Animation.Type.SMOOTH, duration),
        null // cameraCallback
      )
    } else {
      mapWindow.map.move(cameraPosition)
    }
  }

  fun setNightMode(enabled: Boolean) {
    mapWindow.map.isNightModeEnabled = enabled
  }


  fun getMapObjects(): MapObjectCollection {
    return this.mapObjects
  }

  fun addPolygonChild(polygonView: SimpleYamapPolygonView) {
    polygonView.updatePolygon()
  }

  fun removePolygonChild(polygonView: SimpleYamapPolygonView) {
    polygonView.mapObject?.let {
      mapObjects.remove(it)
      polygonView.mapObject = null
    }
  }

  fun addMarkerChild(markerView: SimpleYamapMarkerView) {
    markerView.updateMarker()
  }

  fun removeMarkerChild(markerView: SimpleYamapMarkerView) {
    markerView.mapObject?.let {
      mapObjects.remove(it)
      markerView.mapObject = null
    }
  }

  fun addCircleChild(circleView: SimpleYamapCircleView) {
    circleView.updateCircle()
  }

  fun removeCircleChild(circleView: SimpleYamapCircleView) {
    circleView.mapObject?.let {
      mapObjects.remove(it)
      circleView.mapObject = null
    }
  }

  fun addPolyLineChild(polyLineView: SimpleYamapPolyLineView){
    polyLineView.updatePolyLine()
  }

  fun removePolyLineChild(polyLineView: SimpleYamapPolyLineView){
    polyLineView.mapObject?.let {
      mapObjects.remove(it)
      polyLineView.mapObject = null
    }
  }

  fun onHostResume() {
    MapKitFactory.getInstance().onStart()
    this.onStart()
  }

  fun onHostPause() {
    this.onStop()
    MapKitFactory.getInstance().onStop()
  }

  fun onHostDestroy() {
  }

}


internal class CameraPositionEvent(
  surfaceId: Int,
  viewTag: Int,
  private val _eventName: String,
  private val eventData: WritableMap
) : Event<CameraPositionEvent>(surfaceId, viewTag) {
  override fun getEventName(): String = _eventName
  override fun getEventData(): WritableMap = eventData
}

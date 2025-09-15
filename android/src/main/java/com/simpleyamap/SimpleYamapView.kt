// SimpleYamapView

package com.simpleyamap

import android.content.Context
import com.yandex.mapkit.Animation
import com.yandex.mapkit.MapKitFactory
import com.yandex.mapkit.map.CameraPosition
import com.yandex.mapkit.map.MapObjectCollection
import com.yandex.mapkit.mapview.MapView
import com.yandex.mapkit.geometry.Point as YandexPoint

class SimpleYamapView(context: Context) : MapView(context) {
  private val mapObjects: MapObjectCollection = mapWindow.map.mapObjects

  init {
    mapWindow.map.move(
      CameraPosition(YandexPoint(55.751244, 37.618423), 10.0f, 0.0f, 0.0f)
    )
  }

  fun moveMap(lon: Double, lat: Double, zoom: Float, duration: Float, tilt: Float, azimuth: Float) {
    val cameraPosition = CameraPosition(
      YandexPoint(lat, lon),
      zoom,
      azimuth,
      tilt
    )
    // Yandex Maps SDK для Android требует, чтобы длительность анимации была > 0
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

  fun removePolygonChild(polygonView: SimpleYamapPolygonView){
    polygonView.mapObject?.let {
      mapObjects.remove(it)
      polygonView.mapObject = null
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

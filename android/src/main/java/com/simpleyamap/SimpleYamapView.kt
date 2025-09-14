// SimpleYamapView

package com.simpleyamap

import android.content.Context
import android.graphics.Color
import android.util.AttributeSet
import android.view.View
import com.facebook.react.bridge.ReadableArray
import com.yandex.mapkit.map.MapObjectCollection
import com.yandex.mapkit.Animation
import com.yandex.mapkit.MapKitFactory
import com.yandex.mapkit.map.CameraPosition
import com.yandex.mapkit.map.PolygonMapObject
import com.yandex.mapkit.mapview.MapView
import com.yandex.mapkit.geometry.LinearRing
import com.yandex.mapkit.geometry.Point as YandexPoint
import com.yandex.mapkit.geometry.Polygon as YandexPolygon

class SimpleYamapView(context: Context) : MapView(context) {
  private val mapObjects: MapObjectCollection = mapWindow.map.mapObjects
  private val drawnPolygons = mutableMapOf<String, PolygonMapObject>()

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
      map.move(cameraPosition)
    }
  }

  fun setNightMode(enabled: Boolean) {
    mapWindow.map.isNightModeEnabled = enabled
  }

  fun setPolygons(polygons: ReadableArray?) {
    val newPolygonsMap = polygons?.let {
      (0 until it.size()).mapNotNull { i -> it.getMap(i) }
        .associateBy { p -> p.getString("id")!! }
    } ?: emptyMap()
    val newPolygonIds = newPolygonsMap.keys
    val currentPolygonIds = drawnPolygons.keys.toMutableSet()

    // Remove polygons
    val idsToRemove = currentPolygonIds.filter { it !in newPolygonIds }
    idsToRemove.forEach { id ->
      drawnPolygons[id]?.let { mapObjects.remove(it) }
      drawnPolygons.remove(id)
    }

//    Add polygons
      newPolygonsMap.forEach { (id, polygonMap) ->
        val pointsArray = polygonMap.getArray("points")!!
        if (pointsArray.size() < 3) return@forEach

        val yandexPoints = (0 until pointsArray.size()).map { i ->
          val point = pointsArray.getMap(i)!!
          YandexPoint(point.getDouble("lat"), point.getDouble("lon"))
        }

        val existingPolygon = drawnPolygons[id]

        if (existingPolygon != null) {
          // Update old
          existingPolygon.geometry = YandexPolygon(LinearRing(yandexPoints), emptyList())
          if (polygonMap.hasKey("fillColor")) existingPolygon.fillColor =
            polygonMap.getInt("fillColor")
          if (polygonMap.hasKey("strokeColor")) existingPolygon.strokeColor =
            polygonMap.getInt("strokeColor")
          if (polygonMap.hasKey("strokeWidth")) existingPolygon.strokeWidth =
            polygonMap.getDouble("strokeWidth").toFloat()
        } else {
          // Create new
          val newPolygon =
            mapObjects.addPolygon(YandexPolygon(LinearRing(yandexPoints), emptyList()))
          newPolygon.fillColor =
            if (polygonMap.hasKey("fillColor")) polygonMap.getInt("fillColor") else Color.TRANSPARENT
          newPolygon.strokeColor =
            if (polygonMap.hasKey("strokeColor")) polygonMap.getInt("strokeColor") else Color.BLACK
          newPolygon.strokeWidth =
            if (polygonMap.hasKey("strokeWidth")) polygonMap.getDouble("strokeWidth")
              .toFloat() else 1.0f
          drawnPolygons[id] = newPolygon
        }
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

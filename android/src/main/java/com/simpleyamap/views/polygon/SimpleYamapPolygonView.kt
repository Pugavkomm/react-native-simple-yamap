package com.simpleyamap.views.polygon


import android.content.Context
import android.graphics.Color
import android.view.View
import com.simpleyamap.views.map.SimpleYamapView
import com.yandex.mapkit.geometry.LinearRing
import com.yandex.mapkit.map.PolygonMapObject
import com.yandex.mapkit.geometry.Point as YandexPoint
import com.yandex.mapkit.geometry.Polygon as YandexPolygon


class SimpleYamapPolygonView(context: Context) : View(context) {
  var mapObject: PolygonMapObject? = null
  private var parentMapView: SimpleYamapView? = null

  //Props
  var polygonId: String? = null

  var outerPoints: List<YandexPoint> = emptyList()
    set(value) {
      field = value
      updatePolygon()
    }

  var innerPoints: List<List<YandexPoint>> = emptyList()
    set(value) {
      field = value
      updatePolygon()
    }

  var fillColor: Int = Color.TRANSPARENT
    set(value) {
      field = value
      updatePolygon()
    }

  var strokeColor: Int = Color.BLACK
    set(value) {
      field = value
      updatePolygon()
    }

  var strokeWidth: Float = 1.0f
    set(value) {
      field = value
      updatePolygon()
    }

  override fun onAttachedToWindow() {
    super.onAttachedToWindow()
    findParentMapView()
    parentMapView?.addPolygonChild(this)
  }

  override fun onDetachedFromWindow() {
    super.onDetachedFromWindow()
    parentMapView?.removePolygonChild(this)
    parentMapView = null
  }

  private fun findParentMapView() {
    var parentView = parent
    while (parentView != null) {
      if (parentView is SimpleYamapView) {
        this.parentMapView = parentView
        break
      }
      parentView = parentView.parent
    }
  }


  fun updatePolygon() {
    val mapView = parentMapView ?: return
    val mapObjects = mapView.getMapObjects()

    // Remove old polygon
    mapObject?.let {
      mapObjects.remove(it)
      mapObject = null
    }

    // Polygon: points >= 3
    if (outerPoints.size < 3) {
      mapObject?.let {
        mapObjects.remove(it)
        mapObject = null
      }
      return
    }

    val outerRing = LinearRing(outerPoints)
    val innerRings = mutableListOf<LinearRing>()

    innerPoints.forEach {
      if (it.size >= 3) {
        innerRings.add(LinearRing(it))
      }
    }

    if (mapObject == null) {
      val polygonGeometry = YandexPolygon(outerRing, innerRings)
      val newMapObject = mapObjects.addPolygon(polygonGeometry)
      newMapObject.fillColor = this.fillColor
      newMapObject.strokeColor = this.strokeColor
      newMapObject.strokeWidth = this.strokeWidth
      this.mapObject = newMapObject
    } else {
      mapObject?.let { existingObject ->
        existingObject.geometry = YandexPolygon(outerRing, innerRings)
        existingObject.fillColor = this.fillColor
        existingObject.strokeColor = this.strokeColor
        existingObject.strokeWidth = this.strokeWidth
      }
    }
  }
}



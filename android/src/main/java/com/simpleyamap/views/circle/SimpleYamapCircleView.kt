package com.simpleyamap.views.circle

import android.view.View
import android.content.Context
import com.simpleyamap.views.map.SimpleYamapView
import com.yandex.mapkit.map.CircleMapObject
import com.yandex.mapkit.geometry.Point as YandexPoint
import com.yandex.mapkit.geometry.Circle as YandexCircle


class SimpleYamapCircleView(context: Context) : View(context) {
  var mapObject: CircleMapObject? = null
  private var parentMapView: SimpleYamapView? = null

  //Props
  var circleId: String? = null
  var center: YandexPoint? = null
    set(value) {
      field = value
      updateCircle()
    }

  var radius: Float? = null
    set(value) {
      field = value
      updateCircle()
    }

  var fillColor: Int? = null
    set(value) {
      field = value
      updateCircle()
    }
  var strokeColor: Int? = null
    set(value) {
      field = value
      updateCircle()
    }

  var strokeWidth: Float = 0.0f
    set(value) {
      field = value
      updateCircle()
    }

  var zIndexV: Float = 0.0f
    set(value) {
      field = value
      updateCircle()
    }

  override fun onAttachedToWindow() {
    super.onAttachedToWindow()
    findParentMapView()
    parentMapView?.addCircleChild(this)
  }

  override fun onDetachedFromWindow() {
    super.onDetachedFromWindow()
    parentMapView?.removeCircleChild(this)
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


  fun updateCircle() {
    val mapView = parentMapView ?: return
    val mapObjects = mapView.getMapObjects()
    val currentCenter = center
    val currentRadius = radius

    if (mapObject == null) {

      if (currentRadius != null && currentCenter != null) {
        val circle = YandexCircle(currentCenter, currentRadius)
        mapObject = mapObjects.addCircle(circle)
      } else {
        return
      }
    }

    mapObject?.let { existingObject ->
      if (currentRadius != null && currentCenter != null) {
        existingObject.geometry = YandexCircle(currentCenter, currentRadius)
      }
      strokeColor?.let { color ->
        existingObject.strokeColor = color
      }
      existingObject.strokeWidth = strokeWidth
      fillColor?.let { color ->
        existingObject.fillColor = color
      }
      existingObject.zIndex = zIndexV
    }
  }
}

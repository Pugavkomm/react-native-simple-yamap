package com.simpleyamap.views.circle

import android.animation.ValueAnimator
import android.view.View
import android.content.Context
import com.simpleyamap.views.animations.EaseInOutCosineInterpolator
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
    if (currentCenter == null || currentRadius == null) {
      throw IllegalArgumentException("Circle center and radius cannot be null.")
    }

    val circleGeom = YandexCircle(currentCenter, currentRadius)
    if (mapObject == null) {
      mapObject = mapObjects.addCircle(circleGeom)
    } else {
      updateCircleGeom(circleGeom)
    }
    updateCircleStyle()
  }

  private fun updateRadius(radius: Float) {
    mapObject?.let { existingObject ->
      val center = existingObject.geometry.center
      val radius = radius
      existingObject.geometry = YandexCircle(center, radius)
    }
  }

  fun animatedMove(lon: Double, lat: Double, duration: Float, radius: Float) {
    updateRadius(radius)
    val circle = mapObject ?: return
    val endPosition = YandexPoint(lat, lon)
    val startPosition = circle.geometry.center

    if (duration <= 0) {
      circle.geometry = YandexCircle(endPosition, radius)
      return
    }

    val deltaLat = endPosition.latitude - startPosition.latitude
    val deltaLon = endPosition.longitude - startPosition.longitude

    val valueAnimator = ValueAnimator.ofFloat(0f, 1f)
    valueAnimator.duration = (duration * 1000).toLong()
    valueAnimator.interpolator = EaseInOutCosineInterpolator()

    valueAnimator.addUpdateListener { animation ->
      val progress = animation.animatedValue as Float
      val currentLat = startPosition.latitude + (deltaLat * progress)
      val currentLon = startPosition.longitude + (deltaLon * progress)
      mapObject?.geometry = YandexCircle( YandexPoint(currentLat, currentLon), radius)
    }
    valueAnimator.start()
  }

  fun updateCircleStyle() {
    mapObject?.let { existingObject ->
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


  fun updateCircleGeom(geometry: YandexCircle) {
    mapObject?.let { existingObject ->
      existingObject.geometry = geometry
    }
  }
}

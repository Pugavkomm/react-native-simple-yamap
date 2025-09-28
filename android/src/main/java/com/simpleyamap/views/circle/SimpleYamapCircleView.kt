package com.simpleyamap.views.circle

import android.animation.ValueAnimator
import android.view.View
import android.content.Context
import android.graphics.Color
import androidx.core.animation.doOnEnd
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
      updateCircleGeom()
    }

  var radius: Float? = null
    set(value) {
      field = value
      updateCircleRadius()
    }

  var fillColor: Int? = null
    set(value) {
      field = value
      updateCircleFillColor()
    }
  var strokeColor: Int? = null
    set(value) {
      field = value
      updateCircleStrokeColor()
    }

  var strokeWidth: Float = 0.0f
    set(value) {
      field = value
      updateCircleStrokeWidth()
    }

  var zIndexV: Float = 0.0f
    set(value) {
      field = value
      updateCircleZIndex()
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

  private fun getOrCreateMapObject() {
    findParentMapView()
    if (mapObject != null) {
      return
    }
    val mapView = parentMapView ?: return
    val mapObjects = mapView.getMapObjects()
    val currentCenter = center
    val currentRadius = radius
    if (currentCenter != null && currentRadius != null) {
      val circleGeom = YandexCircle(currentCenter, currentRadius)
      val mapObject = mapObjects.addCircle(circleGeom)
      this.mapObject = mapObject
    }
  }


  fun animatedMove(lon: Double, lat: Double, duration: Float, radius: Float) {
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
      mapObject?.geometry = YandexCircle(YandexPoint(currentLat, currentLon), radius)
    }
    valueAnimator.start()
    valueAnimator.doOnEnd {
      this.radius = radius
    }
  }

  private fun updateCircleFillColor() {
    mapObject?.let { existingObject ->
      fillColor.let { color ->
        if (color != null) {
          existingObject.fillColor = color
        } else {
          existingObject.fillColor = Color.TRANSPARENT
        }
      }
    }
  }

  private fun updateCircleStrokeColor() {
    mapObject?.let { existingObject ->
      strokeColor.let { color ->
        if (color != null) {
          existingObject.strokeColor = color
        } else {
          existingObject.strokeColor = Color.TRANSPARENT
        }
      }
    }
  }

  private fun updateCircleStrokeWidth() {
    mapObject?.let { existingObject ->
      existingObject.strokeWidth = strokeWidth
    }
  }

  private fun updateCircleZIndex() {
    mapObject?.let { existingObject ->
      existingObject.zIndex = zIndexV
    }
  }

  fun updateCircleGeom() {
    val currentCenter = center
    val currentRadius = radius
    if (currentCenter == null || currentRadius == null) {
      return
    }
    val geometry = YandexCircle(currentCenter, currentRadius)
    mapObject?.let { existingObject ->
      existingObject.geometry = geometry
    }
  }

  private fun updateCircleRadius() {
    if (radius == null) {
      return
    }
    mapObject?.let { existingObject ->
      val center = existingObject.geometry.center
      val radius = radius
      existingObject.geometry = YandexCircle(center, radius!!)
    }
  }

  fun updateCircle() {
    getOrCreateMapObject()
    updateCircleGeom()
    updateCircleFillColor()
    updateCircleStrokeColor()
    updateCircleStrokeWidth()
    updateCircleZIndex()
  }
}

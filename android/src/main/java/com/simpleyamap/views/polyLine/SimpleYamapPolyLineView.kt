package com.simpleyamap.views.polyLine

import android.content.Context
import android.graphics.Color
import android.view.View
import com.simpleyamap.views.map.SimpleYamapView
import com.yandex.mapkit.map.PolylineMapObject
import com.yandex.mapkit.geometry.Point as YandexPoint
import com.yandex.mapkit.geometry.Polyline as YandexPolyLine

class SimpleYamapPolyLineView(context: Context) : View(context) {

  override fun onAttachedToWindow() {
    super.onAttachedToWindow()
    findParentMapView()
    parentMapView?.addPolyLineChild(this)
  }

  override fun onDetachedFromWindow() {
    super.onDetachedFromWindow()
    parentMapView?.removePolyLineChild(this)
  }

  var mapObject: PolylineMapObject? = null
  private var parentMapView: SimpleYamapView? = null

  var polyLineId: String? = null

  var points: List<YandexPoint> = emptyList()
    set(value) {
      field = value
      updatePolyLineGeometry()
    }
  var strokeColor: Int = Color.TRANSPARENT
    set(value) {
      field = value
      updateStrokeColor()
    }
  var strokeWidth: Float = 1.0f
    set(value) {
      field = value
      updateStrokeWidth()
    }
  var outlineColor: Int = Color.TRANSPARENT
    set(value) {
      field = value
      updateOutlineColor()
    }
  var outlineWidth: Float = 1.0f
    set(value) {
      field = value
      updateOutlineWidth()
    }

  /**
   * Find parent map view
   *
   * This method should be reworked
   */
  private fun findParentMapView() {
    // TODO: This methods repeats many times. Move to one implementation
    var parentView = parent
    while (parentView != null) {
      if (parentView is SimpleYamapView) {
        this.parentMapView = parentView
        break
      }
      parentView = parentView.parent
    }
  }

  /**
   * Get map object or create
   *
   * If map object already exists, return it. If not, attempt to create it and return it
   *
   * @return Map object or null
   */
  private fun getOrCreateMapObject(): PolylineMapObject? {
    if (mapObject != null) {
      return mapObject
    }
    findParentMapView()
    val mapView = parentMapView ?: return null
    val mapObjects = mapView.getMapObjects()
    mapObject = mapObjects.addPolyline(YandexPolyLine(emptyList()))
    return mapObject
  }

  /**
   * update polyline geometry from prop points
   */
  fun updatePolyLineGeometry() {
    val polyLine = getOrCreateMapObject() ?: return
    polyLine.geometry = YandexPolyLine(points)
  }

  /**
   * Update stroke color from props
   */
  fun updateStrokeColor() {
    val polyLine = getOrCreateMapObject() ?: return
    polyLine.setStrokeColor(strokeColor)
  }

  /**
   * Update stroke width in units from props
   */
  fun updateStrokeWidth() {
    val polyLine = getOrCreateMapObject() ?: return
    val style = polyLine.style
    style.strokeWidth = strokeWidth
    polyLine.style = style
  }

  /**
   * Update outline color  from props
   */
  fun updateOutlineColor() {
    val polyLine = getOrCreateMapObject() ?: return
    val style = polyLine.style
    style.outlineColor = outlineColor
    polyLine.style = style
  }

  /**
   * Update outline width in units from props
   */
  fun updateOutlineWidth() {
    val polyLine = getOrCreateMapObject() ?: return
    val style = polyLine.style
    style.outlineWidth = outlineWidth
    polyLine.style = style
  }

  fun updatePolyLine() {
    updatePolyLineGeometry()
    updateStrokeColor()
    updateStrokeWidth()
    updateOutlineColor()
    updateOutlineWidth()
  }
}

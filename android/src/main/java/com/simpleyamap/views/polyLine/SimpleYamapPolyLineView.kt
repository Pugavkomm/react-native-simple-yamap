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

  var zIndexV: Float = 0.0f
    set(value) {
      field = value
      updatePolyLineZIndex()
    }

  var turnRadius: Float = 10.0f
    set(value) {
      field = value
      updatePolyLineTurnRadius()
    }
  var dashOffset: Float = 0.0f
    set(value) {
      field = value
      updatePolyLineDashOffset()
    }
  var dashLength: Float = 0.0f
    set(value) {
      field = value
      updatePolyLineDashLength()
    }
  var gapLength: Float = 0.0f
    set(value) {
      field = value
      updatePolyLineGapLength()
    }
  var arcApproximationStep: Float = 16.0f
    set(value) {
      field = value
      updatePolyLineArcApproximationStep()
    }


  var points: List<YandexPoint> = emptyList()
    set(value) {
      field = value
      updatePolyLineGeometry()
    }
  var strokeColor: Int = Color.TRANSPARENT
    set(value) {
      field = value
      updatePolyLineStrokeColor()
    }
  var strokeWidth: Float = 1.0f
    set(value) {
      field = value
      updatePolyLineStrokeWidth()
    }
  var outlineColor: Int = Color.TRANSPARENT
    set(value) {
      field = value
      updatePolyLineOutlineColor()
    }
  var outlineWidth: Float = 1.0f
    set(value) {
      field = value
      updatePolyLineOutlineWidth()
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
  fun updatePolyLineStrokeColor() {
    val polyLine = getOrCreateMapObject() ?: return
    polyLine.setStrokeColor(strokeColor)
  }

  /**
   * Update stroke width in units from props
   */
  fun updatePolyLineStrokeWidth() {
    val polyLine = getOrCreateMapObject() ?: return
    val style = polyLine.style
    style.strokeWidth = strokeWidth
    polyLine.style = style
  }

  /**
   * Update outline color  from props
   */
  fun updatePolyLineOutlineColor() {
    val polyLine = getOrCreateMapObject() ?: return
    val style = polyLine.style
    style.outlineColor = outlineColor
    polyLine.style = style
  }

  /**
   * Update outline width in units from props
   */
  fun updatePolyLineOutlineWidth() {
    val polyLine = getOrCreateMapObject() ?: return
    val style = polyLine.style
    style.outlineWidth = outlineWidth
    polyLine.style = style
  }

  /**
   * Update z index from props
   */
  fun updatePolyLineZIndex() {
    val polyline = getOrCreateMapObject() ?: return
    polyline.zIndex = zIndexV
  }

  /**
   * Update maximum radius of a turn from props
   */
  fun updatePolyLineTurnRadius() {
    val polyLine = getOrCreateMapObject() ?: return
    val style = polyLine.style
    style.turnRadius = turnRadius
    polyLine.style = style
  }

  /**
   * Update step of arc approximation from props
   */
  fun updatePolyLineArcApproximationStep() {
    val polyLine = getOrCreateMapObject() ?: return
    val style = polyLine.style
    style.arcApproximationStep = arcApproximationStep
    polyLine.style = style
  }

  /**
   * Update offset from the start of the polyline to the
   * reference dash in units from props
   */
  fun updatePolyLineDashOffset() {
    val polyLine = getOrCreateMapObject() ?: return
    val style = polyLine.style
    style.dashOffset = dashOffset
    polyLine.style = style
  }

  /**
   * Update length of dash in units from props
   */
  fun updatePolyLineDashLength() {
    val polyLine = getOrCreateMapObject() ?: return
    val style = polyLine.style
    style.dashLength = dashLength
    polyLine.style = style

  }

  /**
   * Update length of gap between two dashes in units
   */
  fun updatePolyLineGapLength() {
    val polyLine = getOrCreateMapObject() ?: return
    val style = polyLine.style
    style.gapLength = gapLength
    polyLine.style = style
  }


  /**
   * Perform all updates.
   *
   * Can be used for initialization
   */
  fun updatePolyLine() {
    updatePolyLineGeometry()
    updatePolyLineStrokeColor()
    updatePolyLineStrokeWidth()
    updatePolyLineOutlineColor()
    updatePolyLineOutlineWidth()
    updatePolyLineZIndex()
    updatePolyLineArcApproximationStep()
    updatePolyLineTurnRadius()
    updatePolyLineDashOffset()
    updatePolyLineDashLength()
    updatePolyLineGapLength()
  }
}

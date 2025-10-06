package com.simpleyamap.views.polyLine

import com.facebook.react.bridge.ReadableArray
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.SimpleYamapPolyLineViewManagerDelegate
import com.facebook.react.viewmanagers.SimpleYamapPolyLineViewManagerInterface
import kotlin.math.max
import kotlin.math.min
import com.yandex.mapkit.geometry.Point as YandexPoint

@ReactModule(name = SimpleYamapPolyLineViewManager.NAME)
class SimpleYamapPolyLineViewManager : SimpleViewManager<SimpleYamapPolyLineView>(),
  SimpleYamapPolyLineViewManagerInterface<SimpleYamapPolyLineView> {
  private val mDelegate: ViewManagerDelegate<SimpleYamapPolyLineView> =
    SimpleYamapPolyLineViewManagerDelegate(this)

  override fun getDelegate(): ViewManagerDelegate<SimpleYamapPolyLineView>? {
    return mDelegate
  }

  companion object {
    const val NAME = "SimpleYamapPolyLineView"
  }

  override fun getName(): String {
    return NAME
  }


  override fun createViewInstance(reactContext: ThemedReactContext): SimpleYamapPolyLineView {
    return SimpleYamapPolyLineView(reactContext)
  }

  // Reserved
  @ReactProp(name = "id")
  override fun setId(view: SimpleYamapPolyLineView?, value: String?) {
    view?.polyLineId = value
  }

  @ReactProp(name = "points")
  override fun setPoints(
    view: SimpleYamapPolyLineView?,
    points: ReadableArray?
  ) {
    val yandexPoints = mutableListOf<YandexPoint>()
    if (points == null) {
      view?.points = emptyList()
      return
    }
    for (i in 0 until points.size()) {
      val pointMap = points.getMap(i)

      if (pointMap != null) {
        val lat = pointMap.getDouble("lat")
        val lon = pointMap.getDouble("lon")
        yandexPoints.add(YandexPoint(lat, lon))
      }
    }
    view?.points = yandexPoints
  }

  @ReactProp(name = "strokeWidth")
  override fun setStrokeWidth(
    view: SimpleYamapPolyLineView?,
    widht: Float
  ) {
    view?.strokeWidth = widht
  }

  @ReactProp(name = "strokeColor")
  override fun setStrokeColor(
    view: SimpleYamapPolyLineView?,
    color: Int
  ) {
    view?.strokeColor = color
  }

  @ReactProp(name = "outlineColor")
  override fun setOutlineColor(
    view: SimpleYamapPolyLineView?,
    color: Int
  ) {
    view?.outlineColor = color
  }

  override fun setTurnRadius(
    view: SimpleYamapPolyLineView?,
    value: Float
  ) {
    view?.turnRadius = max(value, 0.0f) // Only positive
  }

  override fun setDashOffset(
    view: SimpleYamapPolyLineView?,
    value: Float
  ) {
    view?.dashOffset = max(value, 0.0f) // Only positive
  }

  override fun setDashLength(
    view: SimpleYamapPolyLineView?,
    value: Float
  ) {
    view?.dashLength = max(value, 0.0f) // Only positive
  }

  override fun setGapLength(
    view: SimpleYamapPolyLineView?,
    value: Float
  ) {
    view?.gapLength = max(value, 0.0f) // Only positive
  }

  override fun setZIndexV(
    view: SimpleYamapPolyLineView?,
    zIndex: Float
  ) {
    view?.zIndexV = zIndex
  }

  override fun setArcApproximationStep(
    view: SimpleYamapPolyLineView?,
    value: Float
  ) {
    view?.arcApproximationStep = value
  }

  @ReactProp(name = "outlineWidth")
  override fun setOutlineWidth(view: SimpleYamapPolyLineView?, width: Float) {
    view?.outlineWidth = width
  }

}

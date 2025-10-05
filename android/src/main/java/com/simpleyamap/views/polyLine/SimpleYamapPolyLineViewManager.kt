package com.simpleyamap.views.polyLine

import com.facebook.react.bridge.ReadableArray
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.SimpleYamapPolyLineViewManagerDelegate
import com.facebook.react.viewmanagers.SimpleYamapPolyLineViewManagerInterface
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

  @ReactProp(name = "outlineWidth")
  override fun setOutlineWidth(view: SimpleYamapPolyLineView?, width: Float) {
    view?.outlineWidth = width
  }

}

package com.simpleyamap.views.polygon

import com.facebook.react.bridge.ReadableArray
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.SimpleYamapPolygonViewManagerDelegate
import com.facebook.react.viewmanagers.SimpleYamapPolygonViewManagerInterface
import com.yandex.mapkit.geometry.Point as YandexPoint

@ReactModule(name = SimpleYamapPolygonViewManager.NAME)
class SimpleYamapPolygonViewManager : SimpleViewManager<SimpleYamapPolygonView>(),
  SimpleYamapPolygonViewManagerInterface<SimpleYamapPolygonView> {

  private val mDelegate: ViewManagerDelegate<SimpleYamapPolygonView> =
    SimpleYamapPolygonViewManagerDelegate(this)

  override fun getDelegate(): ViewManagerDelegate<SimpleYamapPolygonView> {
    return mDelegate
  }

  companion object {
    const val NAME = "SimpleYamapPolygonView"
  }

  override fun getName(): String {
    return NAME
  }

  override fun createViewInstance(reactContext: ThemedReactContext): SimpleYamapPolygonView {
    return SimpleYamapPolygonView(reactContext)
  }

  // For future (reserved)
  @ReactProp(name = "id")
  override fun setId(view: SimpleYamapPolygonView?, value: String?) {
    view?.polygonId = value
  }

  @ReactProp(name = "points")
  override fun setPoints(view: SimpleYamapPolygonView?, points: ReadableArray?) {
    if (points == null) {
      view?.outerPoints = emptyList()
      return
    }
    val yandexPoints = mutableListOf<YandexPoint>()
    for (i in 0 until points.size()) {
      val pointMap = points.getMap(i)
      if (pointMap != null) {
        val lat = pointMap.getDouble("lat")
        val lon = pointMap.getDouble("lon")
        yandexPoints.add(YandexPoint(lat, lon))
      }
    }
    view?.outerPoints = yandexPoints
  }


  @ReactProp(name = "innerPoints")
  override fun setInnerPoints(view: SimpleYamapPolygonView?, innerPoints: ReadableArray?) {
    if (innerPoints == null) {
      view?.innerPoints = emptyList()
      return
    }
    val innerRings = mutableListOf<MutableList<YandexPoint>>()
    for (i in 0 until innerPoints.size()) {
      val ringPoints = innerPoints.getArray(i) as ReadableArray
      val yandexPoints = mutableListOf<YandexPoint>()
      for (j in 0 until ringPoints.size()) {
        val pointMap = ringPoints.getMap(j)
        if (pointMap != null) {
          val lat = pointMap.getDouble("lat")
          val lon = pointMap.getDouble("lon")
          yandexPoints.add(YandexPoint(lat, lon))
        }
      }
      if (yandexPoints.size >= 3) {
        innerRings.add(yandexPoints)
      }
    }
    view?.innerPoints = innerRings
  }

  @ReactProp(name = "fillColor", customType = "Color")
  override fun setFillColor(view: SimpleYamapPolygonView?, color: Int) {
    view?.fillColor = color
  }

  @ReactProp(name = "strokeColor", customType = "Color")
  override fun setStrokeColor(view: SimpleYamapPolygonView?, color: Int) {
    view?.strokeColor = color
  }

  @ReactProp(name = "strokeWidth")
  override fun setStrokeWidth(view: SimpleYamapPolygonView?, width: Float) {
    view?.strokeWidth = width
  }
}

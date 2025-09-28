package com.simpleyamap.views.circle

import com.facebook.react.bridge.ReadableMap
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.SimpleYamapCircleViewManagerDelegate
import com.facebook.react.viewmanagers.SimpleYamapCircleViewManagerInterface
import com.yandex.mapkit.geometry.Point as YandexPoint

@ReactModule(name = SimpleYamapCircleViewManager.NAME)
class SimpleYamapCircleViewManager : SimpleViewManager<SimpleYamapCircleView>(),
  SimpleYamapCircleViewManagerInterface<SimpleYamapCircleView> {


  private val mDelegate: ViewManagerDelegate<SimpleYamapCircleView> =
    SimpleYamapCircleViewManagerDelegate(this)

  override fun getDelegate(): ViewManagerDelegate<SimpleYamapCircleView>? {
    return mDelegate
  }

  companion object {
    const val NAME = "SimpleYamapCircleView"
  }

  override fun getName(): String {
    return NAME
  }

  override fun createViewInstance(reactContext: ThemedReactContext): SimpleYamapCircleView {
    return SimpleYamapCircleView(reactContext)
  }

  // For future (reserved)
  @ReactProp(name = "id")
  override fun setId(view: SimpleYamapCircleView?, value: String?) {
    view?.circleId = value
  }


  @ReactProp(name = "center")
  override fun setCenter(view: SimpleYamapCircleView?, value: ReadableMap?) {
    view?.center = value?.let {
      YandexPoint(it.getDouble("lat"), it.getDouble("lon"))
    }
  }

  @ReactProp(name = "radius")
  override fun setRadius(view: SimpleYamapCircleView?, value: Float) {
    view?.radius = value
  }

  @ReactProp(name = "fillColor")
  override fun setFillColor(view: SimpleYamapCircleView?, value: Int) {
    view?.fillColor = value
  }

  @ReactProp(name = "strokeColor")
  override fun setStrokeColor(view: SimpleYamapCircleView?, value: Int) {
    view?.strokeColor = value
  }

  @ReactProp(name = "strokeWidth")
  override fun setStrokeWidth(view: SimpleYamapCircleView?, value: Float) {
    view?.strokeWidth = value
  }

  @ReactProp(name = "zIndexV")
  override fun setZIndexV(view: SimpleYamapCircleView?, value: Double) {
    view?.zIndexV = value.toFloat()
  }

  override fun animatedMove(
    view: SimpleYamapCircleView?,
    lon: Double,
    lat: Double,
    durationInSeconds: Float,
    radius: Float
  ) {
    view?.animatedMove(lon, lat, durationInSeconds, radius)
  }

}



package com.simpleyamap.views.marker

import android.graphics.PointF
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.SimpleYamapMarkerViewManagerDelegate
import com.facebook.react.viewmanagers.SimpleYamapMarkerViewManagerInterface
import kotlin.math.max
import kotlin.math.min
import com.yandex.mapkit.geometry.Point as YandexPoint

@ReactModule(name = SimpleYamapMarkerViewManager.NAME)
class SimpleYamapMarkerViewManager : SimpleViewManager<SimpleYamapMarkerView>(),
  SimpleYamapMarkerViewManagerInterface<SimpleYamapMarkerView> {

  private val mDelegate: ViewManagerDelegate<SimpleYamapMarkerView> =
    SimpleYamapMarkerViewManagerDelegate(this)

  override fun getDelegate(): ViewManagerDelegate<SimpleYamapMarkerView>? {
    return mDelegate
  }

  companion object {
    const val NAME = "SimpleYamapMarkerView"
  }

  override fun getName(): String {
    return NAME
  }

  override fun createViewInstance(reactContext: ThemedReactContext): SimpleYamapMarkerView {
    return SimpleYamapMarkerView(reactContext)
  }


  // For future (reserved)
  @ReactProp(name = "id")
  override fun setId(view: SimpleYamapMarkerView?, value: String?) {
    view?.markerId = value
  }


  @ReactProp(name = "point")
  override fun setPoint(view: SimpleYamapMarkerView, pointMap: ReadableMap?) {
    if (pointMap == null) return
    val lon = pointMap.getDouble("lon")
    val lat = pointMap.getDouble("lat")
    view.point = YandexPoint(lat, lon)
  }

  @ReactProp(name = "text")
  override fun setText(view: SimpleYamapMarkerView, textMap: ReadableMap?) {
    view.textMarker = textMap?.getString("text")
  }

  @ReactProp(name = "icon")
  override fun setIcon(view: SimpleYamapMarkerView, iconMap: ReadableMap?) {
    view.iconSource = iconMap?.getString("uri")
  }

  @ReactProp(name = "iconScale")
  override fun setIconScale(view: SimpleYamapMarkerView, scale: Double) {
    view.iconScale = scale
  }

  @ReactProp(name = "iconRotated")
  override fun setIconRotated(view: SimpleYamapMarkerView, rotated: Boolean) {
    view.iconRotated = rotated
  }

  @ReactProp(name = "iconAnchor")
  override fun setIconAnchor(view: SimpleYamapMarkerView?, value: ReadableMap?) {
    var x = value?.getDouble("x")?.toFloat() ?: 0.5f
    var y = value?.getDouble("y")?.toFloat() ?: 0.5f
    x = max(0.0f, min(1.0f, x))
    y = max(0.0f, min(1.0f, y))
    view?.iconAnchor = PointF(x, y)
  }

  @ReactProp(name = "zIndexV")
  override fun setZIndexV(view: SimpleYamapMarkerView, zIndexV: Double) {
    view.zIndexValue = zIndexV.toFloat()
  }

  override fun setTransitionDurationPosition(
    view: SimpleYamapMarkerView?,
    value: Float
  ) {
    view?.transitionDurationPosition = value
  }

  override fun animatedMove(
    view: SimpleYamapMarkerView,
    lon: Double,
    lat: Double,
    durationInSeconds: Float
  ) {
    view.animatedMove(lon, lat, durationInSeconds.toDouble())
  }

  override fun animatedRotate(
    view: SimpleYamapMarkerView,
    angle: Float,
    durationInSeconds: Float
  ) {
    view.animatedRotate(angle, durationInSeconds)
  }

  override fun getExportedCustomBubblingEventTypeConstants(): Map<String, Any> {
    return mapOf(
      "tap" to mapOf(
        "phasedRegistrationNames" to mapOf("bubbled" to "onTap")
      ),
    )
  }
}

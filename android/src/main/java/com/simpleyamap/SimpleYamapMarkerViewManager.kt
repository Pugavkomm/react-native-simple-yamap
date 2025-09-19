package com.simpleyamap

import android.graphics.PointF
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.SimpleYamapMarkerViewManagerInterface
import kotlin.math.max
import kotlin.math.min
import com.yandex.mapkit.geometry.Point as YandexPoint

@ReactModule(name = SimpleYamapMarkerViewManager.NAME)
class SimpleYamapMarkerViewManager : SimpleViewManager<SimpleYamapMarkerView>(),
  SimpleYamapMarkerViewManagerInterface<SimpleYamapMarkerView> {
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

  // Handelrs
  // TODO: Refactor to new approach
  override fun receiveCommand(
    view: SimpleYamapMarkerView,
    commandId: String?,
    args: ReadableArray?
  ) {
    super.receiveCommand(view, commandId, args)
    when (commandId) {
      "animatedMove" -> {
        // 0 - lon
        // 1 - lat
        // 2 - duration
        if (args != null && args.size() == 3) {
          val lon = args.getDouble(0)
          val lat = args.getDouble(1)
          val duration = args.getDouble(2)
          view.animatedMove(lon, lat, duration)
        }
      }

      "animatedRotate" -> {
        // 0 angle
        // 1 - duration

        if (args != null && args.size() == 2) {
          val angle = args.getDouble(0).toFloat()
          val duration = args.getDouble(1).toFloat()
          view.animatedRotate(angle, duration)
        }
      }
    }
  }

  // Implement animated move
  override fun animatedMove(
    view: SimpleYamapMarkerView,
    lon: Double,
    lat: Double,
    durationInSeconds: Float
  ) {
    view.animatedMove(lon, lat, durationInSeconds.toDouble())
  }

  override fun animatedRotate(
    view: SimpleYamapMarkerView?,
    angle: Float,
    durationInSeconds: Float
  ) {
    TODO("Not yet implemented")
  }

  override fun getExportedCustomBubblingEventTypeConstants(): Map<String, Any> {
    return mapOf(
      "tap" to mapOf(
        "phasedRegistrationNames" to mapOf("bubbled" to "onTap")
      ),
    )
  }
}

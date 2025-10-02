// SimpleYamapViewManager

package com.simpleyamap.views.map

import com.facebook.react.bridge.LifecycleEventListener
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewGroupManager
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.viewmanagers.SimpleYamapViewManagerDelegate
import com.facebook.react.viewmanagers.SimpleYamapViewManagerInterface

@ReactModule(name = SimpleYamapViewManager.NAME)
class SimpleYamapViewManager : ViewGroupManager<SimpleYamapView>(),
  SimpleYamapViewManagerInterface<SimpleYamapView>,
  LifecycleEventListener {
  private val mDelegate: ViewManagerDelegate<SimpleYamapView> = SimpleYamapViewManagerDelegate(this)
  private var viewInstance: SimpleYamapView? = null

  override fun getDelegate(): ViewManagerDelegate<SimpleYamapView>? {
    return mDelegate
  }

  override fun getName(): String {
    return NAME
  }

  public override fun createViewInstance(context: ThemedReactContext): SimpleYamapView {
    context.addLifecycleEventListener(this)
    val view = SimpleYamapView(context)
    this.viewInstance = view
    return view
  }

  override fun onDropViewInstance(view: SimpleYamapView) {
    super.onDropViewInstance(view)
    (view.context as ThemedReactContext).removeLifecycleEventListener(this)
    this.viewInstance = null
  }

  override fun setNightMode(view: SimpleYamapView, value: Boolean) {
    view.setNightMode(value)
  }

  override fun setCameraPosition(view: SimpleYamapView, value: ReadableMap?) {
    value?.let {
      val lon = it.getDouble("lon")
      val lat = it.getDouble("lat")
      val zoom = it.getDouble("zoom").toFloat()
      val tilt = it.getDouble("tilt").toFloat()
      val azimuth = it.getDouble("azimuth").toFloat()
      val duration = it.getDouble("duration").toFloat()
      view.moveMap(lon, lat, zoom, duration, tilt, azimuth)
    }
  }

  override fun setCenter(
    view: SimpleYamapView?,
    lon: Double,
    lat: Double,
    zoom: Float,
    duration: Float,
    azimuth: Float,
    tilt: Float
  ) {
    view?.moveMap(lon, lat, zoom, duration, tilt, azimuth)
  }


  // Lifecycle
  override fun onHostResume() {
    viewInstance?.onHostResume()
  }

  override fun onHostPause() {
    viewInstance?.onHostPause()
  }

  override fun onHostDestroy() {
    viewInstance?.onHostDestroy()
  }

  override fun getExportedCustomBubblingEventTypeConstants(): Map<String, Any> {
    return mapOf(
      "cameraPositionChange" to mapOf(
        "phasedRegistrationNames" to mapOf("bubbled" to "onCameraPositionChange")
      ),
      "cameraPositionChangeEnd" to mapOf(
        "phasedRegistrationNames" to mapOf("bubbled" to "onCameraPositionChangeEnd")
      ),
    )
  }


  companion object {
    const val NAME = "SimpleYamapView"
  }
}

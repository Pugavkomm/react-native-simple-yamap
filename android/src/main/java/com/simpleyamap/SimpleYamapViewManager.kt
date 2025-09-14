// SimpleYamapViewManager

package com.simpleyamap

import com.facebook.react.bridge.LifecycleEventListener
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.SimpleYamapViewManagerInterface
import com.facebook.react.viewmanagers.SimpleYamapViewManagerDelegate

@ReactModule(name = SimpleYamapViewManager.NAME)
class SimpleYamapViewManager : SimpleViewManager<SimpleYamapView>(),
  SimpleYamapViewManagerInterface<SimpleYamapView>,
  LifecycleEventListener {
  private val mDelegate: ViewManagerDelegate<SimpleYamapView>
  private var viewInstance: SimpleYamapView? = null

  init {
    mDelegate = SimpleYamapViewManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<SimpleYamapView>? {
    return mDelegate
  }

  override fun getName(): String {
    return NAME
  }

  public override fun createViewInstance(context: ThemedReactContext): SimpleYamapView {
    context.addLifecycleEventListener(this) // Подписываемся на события
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

  override fun setPolygons(view: SimpleYamapView, value: ReadableArray?){
    view.setPolygons(value)
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

  companion object {
    const val NAME = "SimpleYamapView"
  }
}

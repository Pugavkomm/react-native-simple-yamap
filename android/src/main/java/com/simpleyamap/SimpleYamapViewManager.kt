package com.simpleyamap

import android.graphics.Color
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.SimpleYamapViewManagerInterface
import com.facebook.react.viewmanagers.SimpleYamapViewManagerDelegate

@ReactModule(name = SimpleYamapViewManager.NAME)
class SimpleYamapViewManager : SimpleViewManager<SimpleYamapView>(),
  SimpleYamapViewManagerInterface<SimpleYamapView> {
  private val mDelegate: ViewManagerDelegate<SimpleYamapView>

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
    return SimpleYamapView(context)
  }

  @ReactProp(name = "color")
  override fun setColor(view: SimpleYamapView?, color: String?) {
    view?.setBackgroundColor(Color.parseColor(color))
  }

  companion object {
    const val NAME = "SimpleYamapView"
  }
}

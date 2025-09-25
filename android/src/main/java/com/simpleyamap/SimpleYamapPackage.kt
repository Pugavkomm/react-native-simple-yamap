package com.simpleyamap

import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager
import com.simpleyamap.views.circle.SimpleYamapCircleViewManager
import com.simpleyamap.views.map.SimpleYamapViewManager
import com.simpleyamap.views.marker.SimpleYamapMarkerViewManager
import com.simpleyamap.views.polygon.SimpleYamapPolygonViewManager

class SimpleYamapViewPackage : ReactPackage {
  override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> {
    val viewManagers: MutableList<ViewManager<*, *>> = ArrayList()
    viewManagers.add(SimpleYamapViewManager())
    viewManagers.add(SimpleYamapPolygonViewManager())
    viewManagers.add(SimpleYamapMarkerViewManager())
    viewManagers.add(SimpleYamapCircleViewManager())
    return viewManagers
  }

  @Deprecated("Migrate to [BaseReactPackage] and implement [getModule] instead.")
  override fun createNativeModules(reactContext: ReactApplicationContext): List<NativeModule> {
    return emptyList()
  }

}

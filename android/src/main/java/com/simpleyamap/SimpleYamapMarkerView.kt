package com.simpleyamap


import EaseInOutCosineInterpolator
import android.animation.ValueAnimator
import android.content.Context
import android.graphics.BitmapFactory
import android.graphics.PointF
import android.view.View
import androidx.core.net.toUri
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactContext
import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.UIManagerHelper
import com.facebook.react.uimanager.events.Event
import com.yandex.mapkit.map.IconStyle
import com.yandex.mapkit.map.MapObject
import com.yandex.mapkit.map.MapObjectTapListener
import com.yandex.mapkit.map.PlacemarkMapObject
import com.yandex.mapkit.map.RotationType
import com.yandex.runtime.image.ImageProvider
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.net.URL
import com.yandex.mapkit.geometry.Point as YandexPoint


class SimpleYamapMarkerView(context: Context) : View(context), MapObjectTapListener {
  var mapObject: PlacemarkMapObject? = null
  private var parentMapView: SimpleYamapView? = null

  private var handled = true

  //Props
  var markerId: String? = null

  var point: YandexPoint? = null
    set(value) {
      field = value
      updateMarker()
    }

  var textMarker: String? = null
    set(value) {
      field = value
      updateMarker()
    }

  var iconSource: String? = null
    set(value) {
      field = value
      updateMarker()
    }

  var iconScale: Double = 1.0
    set(value) {
      field = value
      updateMarker()
    }

  var iconRotated: Boolean = false
    set(value) {
      field = value
      updateMarker()
    }

  var iconAnchor: PointF = PointF(0.5f, 0.5f)
    set(value) {
      field = value
      updateMarker()
    }

  var zIndexValue: Float = 0f
    set(value) {
      field = value
      updateMarker()
    }

  //  Lifecycle
  override fun onAttachedToWindow() {
    super.onAttachedToWindow()
    findParentMapView()
    parentMapView?.addMarkerChild(this)
  }

  override fun onDetachedFromWindow() {
    super.onDetachedFromWindow()
    parentMapView?.removeMarkerChild(this)
    parentMapView = null
  }

  private fun findParentMapView() {
    var parentView = parent
    while (parentView != null) {
      if (parentView is SimpleYamapView) {
        this.parentMapView = parentView
        break
      }
      parentView = parentView.parent
    }
  }


  fun updateMarker() {
    val mapObjects = parentMapView?.getMapObjects() ?: return
    val currentPoint = this.point ?: run {
      mapObject?.let { mapObjects.remove(it) }
      mapObject = null
      return
    }

    if (mapObject == null) {
      mapObject = mapObjects.addPlacemark().apply {
        geometry = currentPoint
        addTapListener(this@SimpleYamapMarkerView)
      }
    } else {
      mapObject?.geometry = currentPoint
    }
    print("Call marker props")
    applyMarkerProps()
  }

  private fun applyMarkerProps() {
    mapObject?.let { marker ->
      marker.setText(textMarker ?: "")
      CoroutineScope(Dispatchers.IO).launch {
        val imageProvider = iconSource?.let { createImageProviderFromUri(it) }
        withContext(Dispatchers.Main) {
          imageProvider?.let { marker.setIcon(it) }
          if (imageProvider != null) {
            val iconStyle = IconStyle()
            iconStyle.scale = iconScale.toFloat()
            iconStyle.anchor = iconAnchor
            iconStyle.zIndex = zIndexValue
            if (iconRotated) {
              iconStyle.rotationType = RotationType.ROTATE
            } else {
              iconStyle.rotationType = RotationType.NO_ROTATION
            }
            marker.setIconStyle(iconStyle)
          }

        }
      }
    }
  }

  private fun createImageProviderFromUri(uriString: String): ImageProvider? {
    return try {
      when {
        uriString.startsWith("http") -> {
          val url = URL(uriString)
          val bmp = BitmapFactory.decodeStream(url.openConnection().getInputStream())
          ImageProvider.fromBitmap(bmp)
        }

        uriString.startsWith("file://") -> {
          val bmp = BitmapFactory.decodeFile(uriString.toUri().path)
          ImageProvider.fromBitmap(bmp)
        }

        else -> {

          val resourceId = context.resources.getIdentifier(
            uriString,
            "drawable",
            context.packageName
          )

          if (resourceId != 0) {
            ImageProvider.fromResource(context, resourceId)
          } else {
            null
          }
        }
      }
    } catch (e: Exception) {
      e.printStackTrace()
      null
    }
  }

  // Animation rotation
  fun animatedRotate(angle: Float, duration: Float) {
    val marker = mapObject ?: return
    val startAngle = marker.direction
    val endAngle = angle

    if (duration <= 0) {
      marker.direction = endAngle
      return
    }

    val deltaAngle = endAngle - startAngle

    val valueAnimator = ValueAnimator.ofFloat(0f, 1f)
    valueAnimator.duration = (duration * 1000).toLong()
    valueAnimator.interpolator = EaseInOutCosineInterpolator()

    valueAnimator.addUpdateListener { animation ->
      val progress = animation.animatedValue as Float
      val currentAngle = startAngle + (deltaAngle * progress)
      if (marker.isValid) {
        marker.direction = currentAngle
      }
    }
    valueAnimator.start()
  }

  // Animation move
  fun animatedMove(lon: Double, lat: Double, duration: Double) {
    val marker = mapObject ?: return
    val endPosition = YandexPoint(lat, lon)
    val startPosition = marker.geometry

    if (duration <= 0) {
      marker.geometry = endPosition
      return
    }

    val deltaLat = endPosition.latitude - startPosition.latitude
    val deltaLon = endPosition.longitude - startPosition.longitude

    val valueAnimator = ValueAnimator.ofFloat(0f, 1f)
    valueAnimator.duration = (duration * 1000).toLong()
    valueAnimator.interpolator = EaseInOutCosineInterpolator()

    valueAnimator.addUpdateListener { animation ->
      val progress = animation.animatedValue as Float
      val currentLat = startPosition.latitude + (deltaLat * progress)
      val currentLon = startPosition.longitude + (deltaLon * progress)
      mapObject?.geometry = YandexPoint(currentLat, currentLon)
    }
    valueAnimator.start()
  }


  override fun onMapObjectTap(mapObject: MapObject, point: YandexPoint): Boolean {
    val reactContext = context as ReactContext
    val eventDispatcher = UIManagerHelper.getEventDispatcherForReactTag(reactContext, id)
    eventDispatcher?.dispatchEvent(
      MarkerPressEvent(UIManagerHelper.getSurfaceId(this), id, Arguments.createMap())
    )
    return handled
  }

}

internal class MarkerPressEvent(
  surfaceId: Int,
  viewTag: Int,
  private val eventData: WritableMap,
) : Event<MarkerPressEvent>(surfaceId, viewTag) {
  override fun getEventName(): String = "topTap"
  override fun getEventData(): WritableMap = eventData
}

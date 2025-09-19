import android.animation.TimeInterpolator
import kotlin.math.PI
import kotlin.math.cos

class EaseInOutCosineInterpolator : TimeInterpolator {
  override fun getInterpolation(input: Float): Float {
    return (-0.5 * cos(PI * input) + 0.5).toFloat()
  }
}

# react-native-simple-yamap

Yandex simple maps for react native.

## Installation

```sh
npm install react-native-simple-yamap
```

## Usage

### IOS Configuration

For ios you need update `AppDelegate.swift`. Add the follow lines:

```swift
import YandexMapsMobile
YMKMapKit.setApiKey("Your key")
YMKMapKit.setLocale("Your lan")
YMKMapKit.sharedInstance()

```

Full example (note: '+' indicates that new lines)

```
import UIKit
import React
import React_RCTAppDelegate
import ReactAppDependencyProvider
+import YandexMapsMobile


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  var reactNativeDelegate: ReactNativeDelegate?
  var reactNativeFactory: RCTReactNativeFactory?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    let delegate = ReactNativeDelegate()
    let factory = RCTReactNativeFactory(delegate: delegate)
    delegate.dependencyProvider = RCTAppDependencyProvider()

    reactNativeDelegate = delegate
    reactNativeFactory = factory

    window = UIWindow(frame: UIScreen.main.bounds)

    factory.startReactNative(
      withModuleName: "SimpleYamapExample",
      in: window,
      launchOptions: launchOptions
    )

    +YMKMapKit.setApiKey("Your key")
    +YMKMapKit.setLocale("ru_RU")
    +YMKMapKit.sharedInstance()



    return true
  }
}

class ReactNativeDelegate: RCTDefaultReactNativeFactoryDelegate {
  override func sourceURL(for bridge: RCTBridge) -> URL? {
    self.bundleURL()
  }

  override func bundleURL() -> URL? {
#if DEBUG
    RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index")
#else
    Bundle.main.url(forResource: "main", withExtension: "jsbundle")
#endif
  }
}

```

### Android configuration

For android you need update `MainApplication.kt`. Add the follow lines:

```
import com.yandex.mapkit.MapKitFactory

 override fun onCreate() {
    super.onCreate()
    MapKitFactory.setApiKey("YOU_KEY")
    MapKitFactory.setLocale("YOU_LANG")
    loadReactNative(this)

  }
```

Full example (note: '+' indicates that new lines )


```
import com.facebook.react.ReactNativeHost
import com.facebook.react.ReactPackage
import com.facebook.react.defaults.DefaultReactHost.getDefaultReactHost
import com.facebook.react.defaults.DefaultReactNativeHost
+import com.yandex.mapkit.MapKitFactory

class MainApplication : Application(), ReactApplication {

  override val reactNativeHost: ReactNativeHost =
      object : DefaultReactNativeHost(this) {
        override fun getPackages(): List<ReactPackage> =
            PackageList(this).packages.apply {
              // Packages that cannot be autolinked yet can be added manually here, for example:
              // add(MyReactNativePackage())
            }

        override fun getJSMainModuleName(): String = "index"

        override fun getUseDeveloperSupport(): Boolean = BuildConfig.DEBUG

        override val isNewArchEnabled: Boolean = BuildConfig.IS_NEW_ARCHITECTURE_ENABLED
        override val isHermesEnabled: Boolean = BuildConfig.IS_HERMES_ENABLED
      }

  override val reactHost: ReactHost
    get() = getDefaultReactHost(applicationContext, reactNativeHost)

  override fun onCreate() {
    super.onCreate()
+    MapKitFactory.setApiKey("Your key")
+    MapKitFactory.setLocale("ru_RU")
    loadReactNative(this)

  }
}
```

```tsx
import {
  type Point,
  SimpleYamap,
  type YamapMarkerRef,
} from 'react-native-simple-yamap';

<SimpleYamap
        style={styles.box}
        nightMode={nightMode}
        cameraPosition={{
          point: {
            lon: lon,
            lat: lat,
          },
          duration: 0.5,
          tilt: tilt,
          azimuth: azimuth,
          zoom: zoom,
        }}
      >
        {polygons.map((poly, index) => (
          <SimpleYamap.Polygon
            id={`poly-${index}`}
            key={`poly-${index}`}
            strokeColor={poly.strokeColor}
            strokeWidth={poly.strokeWidth}
            fillColor={poly.fillColor}
            points={poly.points}
          />
        ))}
        <SimpleYamap.Marker
          id={'marker-4'}
          point={{ lon: 74, lat: 40 }}
          text={{ text: 'Only text marker' }}
        />
        <SimpleYamap.Marker
          id={'marker-z-index-20'}
          point={{ lon: 50, lat: 40 }}
          text={{ text: 'zIndex=20' }}
          zIndex={20}
          iconScale={5}
          icon={MarkerIcon}
        />
        <SimpleYamap.Marker
          id={'marker-z-index-10'}
          point={{ lon: 58, lat: 38 }}
          text={{ text: 'zIndex=10' }}
          zIndex={10}
          iconScale={5}
          icon={MarkerIcon2}
        />
        <SimpleYamap.Marker
          id={'marker-4'}
          point={{ lon: 80, lat: 30 }}
          text={{ text: 'Rotated marker' }}
          icon={MarkerWithDirection}
          iconScale={2}
          ref={rotatableMarkerRef}
          iconRotated
          iconAnchor={{ x: 0.5, y: 0.8 }}
        />
        <SimpleYamap.Marker
          id={'marker-with-animation'}
          point={{ lon: 55, lat: 52 }}
          ref={animatedMarkerRef}
          text={{ text: 'Animated marker' }}
          icon={MarkerWithDirection}
          iconScale={3}
          iconRotated
          iconAnchor={{ x: 0.5, y: 1.0 }}
        />
```

## Dependencies

- [MapKit SDK 4.22.0 (September 11 2025)](https://yandex.com/maps-api/docs/mapkit/versions.html)

## Contributing

- [Development workflow](CONTRIBUTING.md#development-workflow)
- [Sending a pull request](CONTRIBUTING.md#sending-a-pull-request)
- [Code of conduct](CODE_OF_CONDUCT.md)

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)

## TODO

- [ ] Marker is visible prop
- [ ] zIndex for polygons
- [ ] Polygon interactions
- [ ] Polyline
- [ ] Style text
- [ ] Clusters
- [x] ~~Lite version, functionality from high has not been used yet~~
- [ ] Testing
- [ ] Map interactions
  - [x] ~~Set center~~
  - [x] ~~onCameraPositionChange~~
  - [x] ~~onCameraPositionChangeEnd~~
  - [ ] getCurrentCameraPosition
- [ ] Default marker icon
- [ ] Fix android auto scale icons
- [ ] Refactor native code from old examples
- [ ] Find routes
- [ ] Lite or full version sdk switcher
- [ ] Full documentation
- [ ] Return marker id with tap event

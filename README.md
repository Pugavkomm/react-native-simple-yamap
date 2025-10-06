# react-native-simple-yamap

Yandex simple maps for react native.

> Warning. This is a very raw version of the library. Some things may change over time.

## Installation

```sh
npm install react-native-simple-yamap
```

![demo.gif](docs/images/demo/demo.gif)

_Demo example_


<!-- TOC -->

* [react-native-simple-yamap](#react-native-simple-yamap)
  * [Installation](#installation)
  * [Abstract](#abstract)
  * [1 Objects](#1-objects)
    * [1.1 Map (SimpleYamap)](#11-map-simpleyamap)
      * [1.1.1 Example](#111-example)
      * [1.1.2 Props](#112-props)
      * [1.1.3 Methods](#113-methods)
    * [1.2 Marker (SimpleMarker)](#12-marker-simplemarker)
      * [1.2.1 Example](#121-example)
      * [1.2.2 Props](#122-props)
      * [1.2.3 Methods](#123-methods)
    * [1.3 Polygon (SimplePolygon)](#13-polygon-simplepolygon)
      * [1.3.1 Example](#131-example)
      * [1.3.2 Props](#132-props)
    * [1.4 Circle (SimpleCircle)](#14-circle-simplecircle)
      * [1.4.1  Example](#141--example)
      * [1.4.2 Props](#142-props)
      * [1.2.3 Methods](#123-methods-1)
  * [2 Types](#2-types)
    * [2.1 Point](#21-point)
      * [2.1.1 Interface](#211-interface)
      * [2.1.2 Fields](#212-fields)
    * [2.2 CameraPosition](#22-cameraposition)
      * [2.2.1 Interface](#221-interface)
      * [2.2.2 Fields](#222-fields)
    * [2.3 CameraPositionEvent](#23-camerapositionevent)
      * [2.3.1 Interface](#231-interface)
      * [2.3.2 Fields](#232-fields)
    * [2.4 iconAnchor](#24-iconanchor)
    * [2.4.1 Interface](#241-interface)
      * [2.4.2 Fields](#242-fields)
    * [2.5 MarkerText](#25-markertext)
      * [2.5.1 Fields](#251-fields)
  * [3 Utils](#3-utils)
    * [3.1 simpleColorConverter](#31-simplecolorconverter)
  * [4 Instructions](#4-instructions)
    * [4.1 Simple example](#41-simple-example)
    * [4.2 IOS Configuration](#42-ios-configuration)
    * [4.3 Android configuration](#43-android-configuration)
  * [Dependencies](#dependencies)
  * [Contributing](#contributing)
  * [License](#license)
  * [TODO](#todo)

<!-- TOC -->

## Abstract

This library was written to provide a simple way to interact with the MapKit SDK in React Native. The library is
being written for our own needs and will be expanded as needed. Currently, only basic features are supported (see
below for a description of map objects). Currently, the lite version of SDK is used; parts of the full version have
not yet been used. The library is being without regard for the old architecture; that is, it's intended for use only
with the new architecture.

## 1 Objects

### 1.1 Map (SimpleYamap)

**SimpleYamap**. The main view that displays a map and can be used to place markers or other SimpleYamap objects.

#### 1.1.1 Example

_Example of use:_

```tsx
<SimpleYamap nightMode cameraPosition={initialCameraPosition} style={styles.mapBox} ref={mapRef}
        onCameraPositionChange={handleCameraPositionEvent};
        onCameraPositionChangeEnd={handleEndCameraPositionEvent};
/>
```

#### 1.1.2 Props

| **Prop name**  | **Type**                                                                                        | **description**         |
|----------------|-------------------------------------------------------------------------------------------------|-------------------------|
| nightMode      | `boolean`                                                                                       | Turn on night mode      |
| cameraPosition | [`CameraPosition`](#22-cameraposition)                                                          | Current Camera position |
| children       | one of: [`SimpleMarker`](#12-marker-simplemarker), [`SimplePolygon`](#13-polygon-simplepolygon) | One of map objects      |

#### 1.1.3 Methods

You can use method for a map using its `YamapRef` reference. See the table below.

```
export interface YamapRef {
  setCenter(center: CameraPosition): void;
}
```

| **Method name** | arguments                                                                                                                                                                                                  | **description**                          |
|-----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------|
| setCenter       | <table><thead><tr><th>Name</th><th>Type</th><th>Description</th></tr></thead><tbody><tr><td>center</td><td>[`CameraPosition`](#22-cameraposition) </td><td>New center of the map</td></tr></tbody></table> | Set center of the map to camera position |

### 1.2 Marker (SimpleMarker)

**SimpleMarker**. A marker is a point object on the screen. It can be an image (icon) or text. It can also contain
both text and an icon. If necessary, the marker can be moved with animation or rotated with animation.

> You can use `transitionDuration` to specify the time it takes for the coordinates to change via props. If the
> value if not specified, it defaults 0, meaning the change is instantaneous. Any negative value of
> `transitionDuration` will be treated as 0. Changing the position in this case would be equivalent to using an
> `animatedMove` through reference. The angle rotation can currently only be done through `animatedRotate`.

> It's important to ensure that the marker's position is updated no more frequently than the animation duration, as
> this can disrupt the animation process. This applies to position changes view `animatedMove` via props.

#### 1.2.1 Example

_Example of use:_

```tsx
<SimpleYamap.Marker
  id={'marker-with-animation'}
  position={{ lon: 55, lat: 52 }}
  transitionDuration={1000}
  ref={animatedMarkerRef}
  text={{ text: 'Animated marker' }}
  icon={MarkerGreenDirection}
  iconScale={iconScaleService(1)}
  iconRotated
  iconAnchor={{ x: 0.5, y: 1.0 }}
/>
```

#### 1.2.2 Props

| **Prop name**      | **Type**                       | **Required** | **description**                                                                                                                     |
|--------------------|--------------------------------|--------------|-------------------------------------------------------------------------------------------------------------------------------------|
| id                 | `string`                       | Yes          | Unique identifier. Currently not used, but it's recommended to set a unique value, <br/> as its active use is planned in the future |
| position           | [`Point`](#21-Point)           | Yes          | Point on the map                                                                                                                    |
| transitionDuration | `number`                       | No           | Transition duration in ms                                                                                                           |
| icon               | `ImageSourcePropType`          | No           | Marker icon                                                                                                                         |
| text               | [`MarkerText`](#25-markertext) | No           | Marker text                                                                                                                         |
| iconScale          | `number`                       | No           | Scale factor of marker.                                                                                                             |
| iconRotated        | `boolean`                      | No           | if true - you can use animatedRotate                                                                                                |                                                                                               |
| iconAnchor         | [`IconAnchor`](#24-iconanchor) | No           | Offsetting the icon relative to the scenter. This can be useful <br/>for rotating markers when the center of image is offset        |                                                                                               |
| zIndex             | `number`                       | No           | The marker's height above the map. This can be used to position markers above each other                                            |
| onPress            | `() => void`                   | No           | A function that is called when the marker is pressed or tapped by the user.                                                         |

> Warning! In the release version, the marker size may be slightly larger than in debug mode. The result should be
> verified during the build process.

#### 1.2.3 Methods

You can use method for a marker using its `YamapMarkerRef` reference. See the table below.

```
export interface YamapMarkerRef {
  animatedMove(position: Point, durationInSeconds: number): void;
  animatedRotate(angle: number, durationInSeconds: number): void;
}
```

| **Method name** | arguments                                                                                                                                                                                                                                                                                                 | **description**                          |
|-----------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------|
| animatedMove    | <table><thead><tr><th>Name</th><th>Type</th><th>Description</th></tr></thead><tbody><tr><td>position</td><td>[`Point`](#21-point) </td><td>New marker position</td></tr><tr><td>durationInSeconds</td><td>`number`</td><td>Animation duration in seconds</td></tr></tbody></table>                        | Set center of the map to camera position |
| animatedRotate  | <table><thead><tr><th>Name</th><th>Type</th><th>Description</th></tr></thead><tbody><tr><td>angle</td><td>`number`</td><td>New marker rotation. It works only with `iconRotated=true`</td></tr><tr><td>durationInSeconds</td><td>`number`</td><td>Animation duration in seconds</td></tr></tbody></table> | Set new marker direction                 |

### 1.3 Polygon (SimplePolygon)

**SimplePolygon**. A map shape with any number of point, but no less than three. It can have a fill or stroke. You
can also use inner points, meaning you can cut out certain areas within the polygon.

#### 1.3.1 Example

_Example of use:_

```tsx
<SimpleYamap.Polygon
  id={'with-inner'}
  points={[
    { lon: 5, lat: 5 },
    { lon: 20, lat: 5 },
    { lon: 19, lat: 19 },
    { lon: 10, lat: 20 },
  ]}
  innerPoints={[
    [
      { lon: 6, lat: 6 },
      { lon: 8, lat: 6 },
      { lon: 8, lat: 8 },
      { lon: 6, lat: 8 },
    ],
    [
      { lon: 10, lat: 10 },
      { lon: 12, lat: 10 },
      { lon: 12, lat: 12 },
      { lon: 10, lat: 12 },
    ],
  ]}
  fillColor={safeProcessColor('rgba(100, 0, 0, 0.3)')}
  strokeWidth={2}
  strokeColor={safeProcessColor('rgba(100, 0, 100, 0.9)')}
/>
```

#### 1.3.2 Props

| **Prop name** | **Type**                 | **Required** | **description**                                                                                                                     |
|---------------|--------------------------|--------------|-------------------------------------------------------------------------------------------------------------------------------------|
| id            | `string`                 | Yes          | Unique identifier. Currently not used, but it's recommended to set a unique value, <br/> as its active use is planned in the future |
| points        | [`Point[]`](#21-point)   | Yes          | Outer ring                                                                                                                          |
| innerPoints   | [`Point[][]`](#21-point) | No           | Inner rings                                                                                                                         |
| fillColor     | 'number                  | No           | Color in integer format                                                                                                             |
| strokeColor   | 'number                  | No           | Color in integer format                                                                                                             |
| strokeWidth   | 'number                  | No           | Width of stroke. By default 1. If 0 - without stroke                                                                                |

### 1.4 Circle (SimpleCircle)

**SimpleCircle**. Circle on the map with color fill and border.

![demo_circles.gif](docs/images/demo/demo_circles.gif)

#### 1.4.1  Example

```tsx
import SimpleYamap from 'react-native-simple-yamap';
import { useEffect, useState } from 'react';

const MAX_RADIUS = 2000000;
const MIN_RADIUS = 100000;

const colors = [
  SimpleYamap.color('rgba(100, 0, 0, 0.2)'),
  SimpleYamap.color('rgba(0, 255, 0, 0.2)'),
  SimpleYamap.color('rgba(0, 0, 255, 0.2)'),
  SimpleYamap.color('rgba(100, 0, 255, 0.2)'),
];

const getColor = (): number => {
  return colors[Math.floor(Math.random() * colors.length)]!;
};

const HeartBeatCircle: React.FC = () => {
  const [color, setColor] = useState<number>(getColor());
  const [radius, setRadius] = useState<number>(MAX_RADIUS);

  const changeRadius = () => {
    const newRadius = Math.random() * (MAX_RADIUS - MIN_RADIUS) + MIN_RADIUS;
    setRadius(newRadius);
    setColor(getColor());
  };

  useEffect(() => {
    const intervalId = setInterval(() => {
      changeRadius();
    }, Math.random() * 10000);
    return () => clearInterval(intervalId);
  }, []);

  return (
    <SimpleYamap.Circle
      id={'circle-1'}
      position={{ lon: 10, lat: 25 }}
      radius={radius}
      fillColor={color}
      strokeColor={SimpleYamap.color('rgba(255, 0, 100, 0.8)')}
      strokeWidth={1}
      zIndex={1000}
    />
  );
};

export default HeartBeatCircle;

```

#### 1.4.2 Props

| **Prop name** | **Type**             | **Required** | **description**                                                                                                                     |
|---------------|----------------------|--------------|-------------------------------------------------------------------------------------------------------------------------------------|
| id            | `string`             | Yes          | Unique identifier. Currently not used, but it's recommended to set a unique value, <br/> as its active use is planned in the future |
| position      | [`Point`](#21-point) | Yes          | Center of circle                                                                                                                    |
| radius        | 'number'             | Yes          | Circle radius                                                                                                                       |
| fillColor     | 'number              | No           | Color in integer format                                                                                                             |
| strokeColor   | 'number              | No           | Color in integer format                                                                                                             |
| strokeWidth   | 'number              | No           | Width of stroke. By default 0. If 0 - without stroke                                                                                |

#### 1.2.3 Methods

You can use method for a marker using its `YamapCircleRef` reference. See the table below.

```ts
export interface YamapCircleRef {
  animatedMove(position: Point, durationInSeconds: number, radius: number): void;
}
```

| **Method name** | arguments                                                                                                                                                                                                                                                                                                                                        | **description**                          |
|-----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------|
| animatedMove    | <table><thead><tr><th>Name</th><th>Type</th><th>Description</th></tr></thead><tbody><tr><td>position</td><td>[`Point`](#21-point) </td><td>New circle position</td></tr><tr><td>durationInSeconds</td><td>`number`</td><td>Animation duration in seconds</td></tr><tr><td>radius<td>`number`</td><td>New circle radius</td></tr></tbody></table> | Set center of the map to camera position |

_animatedMove demo_

![demo_circles_animatedMove.gif](docs/images/demo/demo_circles_animatedMove.gif)

### 1.5 PolyLine (SimplePolyLine)

**SimplePolyLine** - A line that consists of several segments.

#### 1.5.1 Example

```tsx
import React, { useMemo } from 'react';
import SimpleYamap, {
  type Point,
  type SimplePolyLineDashStyle,
  type SimplePolyLineRenderConfig,
} from 'react-native-simple-yamap';

const DashedPolyLine: React.FC = () => {
  const points: Point[] = [
    {
      lon: 15,
      lat: 25,
    },
    { lon: -40, lat: 21 },
    { lon: -30, lat: 11 },
    { lon: -15, lat: 31 },
    { lon: 0, lat: 41 },
  ];
  const dashStyle: SimplePolyLineDashStyle = useMemo<SimplePolyLineDashStyle>(
    () => ({
      dashLength: 30.0,
      gapLength: 3.0,
      dashOffset: 20.0,
    }),
    []
  );

  const renderConfig: SimplePolyLineRenderConfig =
    useMemo<SimplePolyLineRenderConfig>(
      () => ({
        arcApproximationStep: 16,
        turnRadius: 50,
      }),
      []
    );
  return (
    <SimpleYamap.PolyLine
      id={'dashed'}
      points={points}
      dashStyle={dashStyle}
      strokeWidth={3}
      strokeColor={SimpleYamap.color('white')}
      outlineWidth={1}
      outlineColor={SimpleYamap.color('red')}
      zIndex={1000}
      renderConfig={renderConfig}
    />
  );
};

export default DashedPolyLine;

```

#### 1.5.2 Props

```ts
export interface SimplePolyLineProps {
  id: string;
  points: Readonly<Point[]>;
  strokeWidth?: number;
  outlineWidth?: number;
  strokeColor?: number;
  outlineColor?: number;
  dashStyle?: SimplePolyLineDashStyle;
  renderConfig?: SimplePolyLineRenderConfig;
  zIndex?: number;
}
```

| **Prop name** | **Type**                                                       | **Required** | **description**                                                                                                                     |
|---------------|----------------------------------------------------------------|--------------|-------------------------------------------------------------------------------------------------------------------------------------|
| id            | `string`                                                       | Yes          | Unique identifier. Currently not used, but it's recommended to set a unique value, <br/> as its active use is planned in the future |
| points        | [`Point`](#21-point)                                           | Yes          | Points of segments. One segment: [$(x1, y1)$, $(x2, y2)$]. Two segments:[$(x1, y1)$, $(x2, y2)$, $(x3, y3)$]                        |
| strokeWidth   | `number`                                                       | No           | Width of stroke in units. By default 1. If 0 - without stroke                                                                       |
| strokeColor   | `number`                                                       | No           | Color of stroke in integer format. By default Transparent                                                                           |                                                                                                                                    |
| outlineWidth  | `number`                                                       | No           | Width of outline in units. By default 1. If 0 - without outline                                                                     |
| outlineColor  | `number`                                                       | No           | Color of outline in integer format                                                                                                  |
| dashStyle     | [`SimplePolyLineDashStyle`](#26-simplepolylinedashstyle)       | No           | Dash style                                                                                                                          |
| renderConfig  | [`SimplePolyLineRenderConfig`](#27-simplepolylinerenderconfig) | No           | Render configuration                                                                                                                |
| zIndex        | `number`                                                       | No           | The polyline's height above the map. This can be used to position polylines above each other                                        |

## 2 Types

### 2.1 Point

Simple base type with longitude and latitude.

#### 2.1.1 Interface

```ts
export interface Point {
  lon: number;
  lat: number;
}
```

#### 2.1.2 Fields

| **Field name** | **Type** | **Required** | **Description** |
|----------------|----------|--------------|-----------------|
| lon            | `number` | Yes          | Longitude       |
| lat            | `number` | Yes          | Latitude        |

### 2.2 CameraPosition

Map camera position.

#### 2.2.1 Interface

```ts
export interface CameraPosition {
  position: Point;
  zoom: number;
  duration: number;
  azimuth?: number;
  tilt?: number;
}
```

#### 2.2.2 Fields

| **Field name** | **Type**             | **Required** | **Description**                                                                                          |
|----------------|----------------------|--------------|----------------------------------------------------------------------------------------------------------|
| position       | [`Point`](#21-Point) | Yes          | Point on the map                                                                                         |
| zoom           | `number`             | Yes          | Map camera zoom                                                                                          |
| duration       | `number`             | Yes          | Change camera position with duration. The value is specified in seconds. The value 0 = without animation |
| azimuth        | `number`             | No           | Azimuth                                                                                                  |
| tilt           | `number`             | No           | Tilt                                                                                                     |

### 2.3 CameraPositionEvent

#### 2.3.1 Interface

```ts
export interface CameraPositionEvent {
  position: Point;
  zoom: number;
  tilt: number;
  azimuth: number;
  reason: string;
  finished: boolean;
}
```

#### 2.3.2 Fields

| **Field name** | **Type**             | **Required** | **Description**                                                             |
|----------------|----------------------|--------------|-----------------------------------------------------------------------------|
| position       | [`Point`](#21-point) | Yes          | Point on the map                                                            |
| zoom           | `number`             | Yes          | Map camera zoom                                                             |
| duration       | `number`             | Yes          | Change camera position with duration. The value is specified in seconds     |
| azimuth        | `number`             | Yes          | Azimuth                                                                     |
| tilt           | `number`             | Yes          | Tilt                                                                        |
| reason         | `string`             | Yes          | The reason of the camera update. Possible values: `GESTURES`, `APPLICATION` |
| finished       | `boolean`            | Yes          | True if the camera finished moving                                          |

### 2.4 iconAnchor

### 2.4.1 Interface

```ts
export interface IconAnchor {
  x: number;
  y: number;
}
```

#### 2.4.2 Fields

| **Field name** | **Type** | **Required** | **Description**                                                                                                                                                   |
|----------------|----------|--------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| x              | `number` | Yes          | The x-axis offset. Defaults to 0.5. Can range from 0 to 1. If values are specified outside this range, the result will still be limited to values between 0 and 1 |
| y              | `number` | Yes          | The y-axis offset. Defaults to 0.5. Can range from 0 to 1. If values are specified outside this range, the result will still be limited to values between 0 and 1 |

### 2.5 MarkerText

#### 2.5.1 Fields

| **Field name** | **Type** | **Required** | **Description** |
|----------------|----------|--------------|-----------------|
| text           | `string` | Yes          | Text            |

```ts
export interface MarkerText {
  text: string;
}
```

### 2.6 SimplePolyLineDashStyle

#### 2.6.1 Interface

```ts
export interface SimplePolyLineDashStyle {
  dashLength?: number;
  gapLength?: number;
  dashOffset?: number;
}
```

#### 2.6.2 Fields

| **Field name** | **Type** | **Required** | **Description**                                                      |
|----------------|----------|--------------|----------------------------------------------------------------------|
| dashLength     | `number` | No           | Length of dash in units                                              |
| gapLength      | `number` | No           | Length of gap between two dashes in units                            |
| dashOffset     | `number` | No           | Offset from the start of the polyline to the reference dash in units |

### 2.7 SimplePolyLineRenderConfig

#### 2.7.1 Interface

```ts
export interface SimplePolyLineRenderConfig {
  turnRadius?: number;
  arcApproximationStep?: number;
}
```

#### 2.7.2 Fields

| **Field name**       | **Type** | **Required** | **Description**           |
|----------------------|----------|--------------|---------------------------|
| turnRadius           | `number` | No           | Maximum radius of a turn  |
| arcApproximationStep | `number` | No           | Step of arc approximation |

## 3 Utils

### 3.1 simpleColorConverter

Color is assumed to be transmitted using an int value. To simplify definition, a utility function was developed
(`simpleColorConverter`).

The goal was to retain the ability to specify numeric values, as in the original SDK, but also to allow for more
convenient values like `red` or `rgba(255, 0, 0, 0.5)`.

There are two possible ways for use. The first one:

```ts
import { simpleColorConverter } from 'react-native-simple-yamap';
const colorRed = simpleColorConverter('red');
const colorRed80 = simpleColorConverter('rgba(255, 0, 0, 0.8)');
```

The second one:

```ts
import SimpleYamap from 'react-native-simple-yamap';
const colorRed = SimpleYamap.color('red');
const colorRed80 = SimpleYamap.color('rgba(255, 0, 0, 0.8)');
```

## 4 Instructions

### 4.1 Simple example

see [App.tsx](./example/src/App.tsx)

### 4.2 IOS Configuration

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

### 4.3 Android configuration

For android, you need update `MainApplication.kt`. Add the follow lines:

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
- [ ] Animated ~~markers~~, ~~circles~~, polylines. with props
- [ ] Polyline
  - [x] ~~Polyline object~~
  - [x] ~~Dash control~~
  - [x] ~~Render control~~
  - [x] ~~zIndex~~
  - [ ] Add arrow
  - [ ] Interactions (tap, ...)
  - [ ] Rerender geometry event
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
- [x] ~~Refactor native code from old examples~~
- [ ] Find routes
- [ ] Lite or full version sdk switcher
- [x] ~~Full documentation~~
- [ ] Return marker id with tap event
- [ ] Refactor native props handling with separated updates
  - [x] ~~Markers~~
  - [x] ~~Circles~~
  - [ ] Polygons
    - [ ] zIndex for polygons
    - [ ] Polygon interactions

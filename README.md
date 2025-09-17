# react-native-simple-yamap

Yandex simple maps for react native.

## Installation

```sh
npm install react-native-simple-yamap
```

## Usage

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
- [ ] Polyline
- [ ] Style text
- [ ] Clusters
- [ ] Lite version, functionality from high has not been used yet
- [ ] Testing
- [ ] Map interactions
- [ ] Default marker icon

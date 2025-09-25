import { Dimensions, StyleSheet } from 'react-native';
import { useRef, useState } from 'react';
import {
  type CameraPosition,
  SimpleYamap,
  type YamapRef,
} from 'react-native-simple-yamap';
import {
  BrandComponent,
  MapInfoComponent,
  MapNavigBtnsComponent,
  MarkersComponent,
  PolygonsComponent,
} from './components';
import { SafeAreaView } from 'react-native-safe-area-context';
import { MAP_Z_INDEX } from './const';

const CAMERA_SPEED = 10;

const initialCameraPosition: CameraPosition = {
  point: { lon: 37.62, lat: 55.75 },
  zoom: 3,
  tilt: 100,
  azimuth: 0,
  duration: 1,
};

export function App() {
  const [nightMode, setNightMode] = useState<boolean>(false);
  const [currentCenter, setCurrentCenter] = useState<CameraPosition>(
    initialCameraPosition
  );
  const mapRef = useRef<YamapRef | null>(null);

  const left = () => {
    mapRef.current?.setCenter({
      ...currentCenter,
      point: {
        ...currentCenter.point,
        lon: currentCenter.point.lon - CAMERA_SPEED,
      },
    });
  };

  const right = () => {
    mapRef.current?.setCenter({
      ...currentCenter,
      point: {
        ...currentCenter.point,
        lon: currentCenter.point.lon + CAMERA_SPEED,
      },
    });
  };

  const up = () => {
    mapRef.current?.setCenter({
      ...currentCenter,
      point: {
        ...currentCenter.point,
        lat: currentCenter.point.lat + CAMERA_SPEED,
      },
    });
  };

  const down = () => {
    mapRef.current?.setCenter({
      ...currentCenter,
      point: {
        ...currentCenter.point,
        lat: currentCenter.point.lat - CAMERA_SPEED,
      },
    });
  };

  const zoomIn = () => {
    mapRef.current?.setCenter({
      ...currentCenter,
      zoom: currentCenter.zoom + 1,
    });
  };

  const zoomOut = () => {
    mapRef.current?.setCenter({
      ...currentCenter,

      zoom: currentCenter.zoom - 1,
    });
  };

  const azimuthDecrease = () => {
    mapRef.current?.setCenter({
      ...currentCenter,
      azimuth: currentCenter.azimuth! - 10,
    });
  };
  const azimuthIncrease = () => {
    mapRef.current?.setCenter({
      ...currentCenter,
      azimuth: currentCenter.azimuth! + 10,
    });
  };

  const getRandomBetween = (a: number, b: number): number => {
    return Math.random() * (b - a) + a;
  };

  const tiltUp = () => {
    mapRef.current?.setCenter({
      ...currentCenter,
      azimuth: currentCenter.tilt! + 1,
    });
  };
  const tiltDown = () => {
    mapRef.current?.setCenter({
      ...currentCenter,
      azimuth: currentCenter.tilt! - 1,
    });
  };
  const setRandomPosition = () => {
    const latV = getRandomBetween(10, 100);
    const lonV = getRandomBetween(10, 150);

    mapRef.current?.setCenter({
      ...currentCenter,
      point: { lon: lonV, lat: latV },
    });
  };

  const setCenter = () => {
    mapRef.current?.setCenter(initialCameraPosition);
  };

  return (
    <SafeAreaView style={styles.container}>
      <BrandComponent />
      <MapNavigBtnsComponent
        left={left}
        right={right}
        up={up}
        down={down}
        zoomIn={zoomIn}
        zoomOut={zoomOut}
        random={setRandomPosition}
        nightModeToggle={() => setNightMode((prev) => !prev)}
        tiltDown={tiltDown}
        tiltUp={tiltUp}
        azimuthDecrease={azimuthDecrease}
        azimuthIncrease={azimuthIncrease}
        setCenter={setCenter}
      />
      <MapInfoComponent
        lon={currentCenter?.point.lon}
        lat={currentCenter?.point.lat}
        zoom={currentCenter?.zoom}
        tilt={currentCenter?.tilt}
        azimuth={currentCenter?.azimuth}
      />

      <SimpleYamap
        onCameraPositionChange={(e) => {
          setCurrentCenter({
            point: e.point,
            azimuth: e.azimuth,
            zoom: e.zoom,
            tilt: e.tilt,
            duration: initialCameraPosition.duration,
          });
          console.info(
            `Camera position changing: (${e.point.lat}, ${e.point.lon})`
          );
        }}
        onCameraPositionChangeEnd={(e) => {
          console.info(
            `End camera position changing: (${e.point.lat}, ${e.point.lon}). Reason: ${e.reason}`
          );
        }}
        ref={mapRef}
        style={styles.mapBox}
        nightMode={nightMode}
        cameraPosition={initialCameraPosition}
      >
        <MarkersComponent />
        <PolygonsComponent />
      </SimpleYamap>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  mapBox: {
    width: Dimensions.get('screen').width,
    height: Dimensions.get('screen').height,
    zIndex: MAP_Z_INDEX,
  },
});

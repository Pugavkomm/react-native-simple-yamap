import {
  Button,
  Dimensions,
  processColor,
  StyleSheet,
  Text,
  View,
} from 'react-native';
import React, { useCallback, useEffect, useRef, useState } from 'react';
import {
  type CameraPosition,
  type Point,
  SimpleYamap,
  type YamapMarkerRef,
  type YamapRef,
} from 'react-native-simple-yamap';
import { type SimplePolygonProps } from '../../src/components';
import {
  MarkerGreen,
  MarkerGreenDirection,
  MarkerYellow,
  MarkerYellowDirection,
} from './images';
import iconScaleService from './services/iconScaleService';

const MARKER_SPEED = 20;
const CAMERA_SPEED = 10;

const safeProcessColor = (color: string): number | undefined => {
  const processed = processColor(color);
  if (typeof processed === 'number') {
    return processed;
  }
  return undefined;
};

const initialCameraPosition: CameraPosition = {
  point: { lon: 37.62, lat: 55.75 },
  zoom: 3,
  tilt: 100,
  azimuth: 0,
  duration: 1,
};

const initialPolygons: SimplePolygonProps[] = [
  {
    id: 'poly1',
    points: [
      { lat: 10, lon: 20 },
      { lat: 10, lon: 100 },
      { lat: 50, lon: 100 },
      { lat: 10, lon: 10 },
      { lat: 50, lon: 20 },
    ],
    fillColor: safeProcessColor('rgba(100, 100, 250, 0.2)'),
    strokeColor: safeProcessColor('rgba(0, 0, 100, 0.1)'),
    strokeWidth: 1.0,
  },
  {
    id: 'poly2',
    points: [
      { lat: 60, lon: 20 },
      { lat: 60, lon: 100 },
      { lat: 100, lon: 100 },
    ],
    fillColor: safeProcessColor('rgba(100, 0, 0, 0.3)'),
    strokeColor: safeProcessColor('rgba(50, 0, 0, 1)'),
    strokeWidth: 2.0,
  },
];

interface ButtonBlockProps {
  left?: () => void;
  right?: () => void;
  up?: () => void;
  down?: () => void;
  zoomIn?: () => void;
  zoomOut?: () => void;
  random?: () => void;
  nightModeToggle?: () => void;
  tiltUp?: () => void;
  tiltDown?: () => void;
  azimuthIncrease?: () => void;
  azimuthDecrease?: () => void;
  setCenter?: () => void;
}

interface TextInfoBlockProps {
  lon?: number;
  lat?: number;
  zoom?: number;
  tilt?: number;
  azimuth?: number;
}

interface TextInfoProps {
  text: string;
}

const TextInfo: React.FC<TextInfoProps> = (props) => {
  return <Text style={styles.textInfo}>{props.text}</Text>;
};

const TextInfoBlock: React.FC<TextInfoBlockProps> = (props) => {
  return (
    <View style={styles.textInfoBlock}>
      <TextInfo text={`lon: ${props.lon}`} />
      <TextInfo text={`lat: ${props.lat}`} />
      <TextInfo text={`zoom: ${props.zoom}`} />
      <TextInfo text={`tilt: ${props.tilt}`} />
      <TextInfo text={`azimuth: ${props.azimuth}`} />
    </View>
  );
};

const ButtonBlock: React.FC<ButtonBlockProps> = (props) => {
  return (
    <View style={styles.buttonBlock}>
      <Button title={'up'} onPress={props.up} />
      <View style={styles.buttonRow}>
        <Button title={'left'} onPress={props.left} />
        <Button title={'right'} onPress={props.right} />
      </View>
      <Button title={'down'} onPress={props.down} />
      <Text style={styles.buttonHeader}>Zoom</Text>
      <View style={styles.buttonRow}>
        <Button title={'+'} onPress={props.zoomIn} />
        <Button title={'-'} onPress={props.zoomOut} />
      </View>
      <Button title={'Random'} onPress={props.random} />
      <Button title={'Night toggle'} onPress={props.nightModeToggle} />
      <Text style={styles.buttonHeader}>Tilt</Text>
      <View style={styles.buttonRow}>
        <Button title={'+'} onPress={props.tiltUp} />
        <Button title={'-'} onPress={props.tiltDown} />
      </View>
      <Text style={styles.buttonHeader}>Azimuth</Text>
      <View style={styles.buttonRow}>
        <Button title={'+'} onPress={props.azimuthIncrease} />
        <Button title={'-'} onPress={props.azimuthDecrease} />
      </View>
      <Button title={'37.62, 55.75'} onPress={props.setCenter} />
    </View>
  );
};

const MarkerComponent: React.FC = () => {
  return (
    <>
      <SimpleYamap.Marker
        id={'inside container'}
        point={{ lon: 50, lat: 10 }}
        icon={MarkerGreen}
        iconScale={iconScaleService(0.2)}
      />
      <SimpleYamap.Marker
        id={'inside container'}
        point={{ lon: 60, lat: 10 }}
        icon={MarkerGreenDirection}
        iconScale={iconScaleService(0.2)}
      />
    </>
  );
};

export function App() {
  const [nightMode, setNightMode] = useState<boolean>(false);
  const [polygons, setPolygons] = useState<SimplePolygonProps[]>([]);
  const [currentCenter, setCurrentCenter] = useState<CameraPosition>(
    initialCameraPosition
  );
  const [movableMarkerPosition, setMovableMarkerPosition] = useState<Point>({
    lat: 30,
    lon: 70,
  });
  const moveMarkerTimerIdRef = useRef<NodeJS.Timeout | null>(null);
  const angleTimerRef = useRef<NodeJS.Timeout | null>(null);
  const [angle, setAngle] = useState<number>(200);
  const animatedMarkerRef = useRef<YamapMarkerRef | null>(null);
  const rotatableMarkerRef = useRef<YamapMarkerRef | null>(null);
  const mapRef = useRef<YamapRef | null>(null);

  // Smooth shift animated marker
  useEffect(() => {
    animatedMarkerRef.current?.animatedMove(movableMarkerPosition, 0.5);
  }, [movableMarkerPosition]);

  // Smooth rotate
  useEffect(() => {
    rotatableMarkerRef.current?.animatedRotate(angle, 1);
    animatedMarkerRef.current?.animatedRotate(angle, 0.5);
  }, [angle]);

  const changeRotation = useCallback(() => {
    const randomAngle = Math.random() * 360;
    setAngle(randomAngle);
    angleTimerRef.current = setTimeout(() => changeRotation(), 1100);
  }, []);

  const changeMarkerPosition = useCallback(() => {
    setMovableMarkerPosition((prev) => {
      const direction = Math.random() > 0.8 ? 1 : -1;
      return {
        lon: (prev.lon + 2 * direction) % 100,
        lat: (prev.lat + MARKER_SPEED * direction) % 50,
      };
    });
    moveMarkerTimerIdRef.current = setTimeout(
      () => changeMarkerPosition(),
      1100
    );
  }, []);

  // Run rotation
  useEffect(() => {
    changeRotation();
    return () => {
      angleTimerRef.current && clearTimeout(angleTimerRef.current);
    };
  }, [changeRotation]);

  // Run movable
  useEffect(() => {
    changeMarkerPosition();
    return () => {
      moveMarkerTimerIdRef.current &&
        clearTimeout(moveMarkerTimerIdRef.current);
    };
  }, [changeMarkerPosition]);

  useEffect(() => {
    //@ts-ignore
    setTimeout(setPolygons([]));
    setTimeout(() => {
      setPolygons([initialPolygons[0]!]);
    }, 500);

    setTimeout(() => {
      setPolygons((prev) => [...prev, initialPolygons[1]!]);
    }, 2000);

    setTimeout(() => {
      setPolygons([initialPolygons[0]!]);
    }, 5000);
  }, []);

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
    <View style={styles.container}>
      <Text style={styles.brandText}>
        SimpleYamap <Text style={styles.subBrandText}>Demo</Text>
      </Text>
      <ButtonBlock
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
      <TextInfoBlock
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
            `End camera position changing: (${e.point.lat}, ${e.point.lon})`
          );
        }}
        ref={mapRef}
        style={styles.box}
        nightMode={nightMode}
        cameraPosition={initialCameraPosition}
      >
        <>
          <SimpleYamap.Marker
            id={'marker inside polygon'}
            point={{ lat: 15, lon: 12 }}
            text={{ text: 'Polygon with inner rings' }}
          />
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
          <MarkerComponent />
          <SimpleYamap.Marker
            id={'marker-4'}
            point={{ lon: 74, lat: 40 }}
            text={{ text: 'Only text marker' }}
            iconScale={iconScaleService(1)}
          />
          <SimpleYamap.Marker
            id={'marker-z-index-20'}
            point={{ lon: 50, lat: 40 }}
            text={{ text: 'zIndex=20' }}
            zIndex={20}
            iconScale={iconScaleService(2)}
            icon={MarkerGreen}
          />
          <SimpleYamap.Marker
            id={'marker-z-index-10'}
            point={{ lon: 58, lat: 38 }}
            text={{ text: 'zIndex=10' }}
            zIndex={10}
            iconScale={iconScaleService(2)}
            icon={MarkerYellow}
          />
          <SimpleYamap.Marker
            id={'marker-4'}
            point={{ lon: 80, lat: 30 }}
            text={{ text: 'Rotated marker' }}
            icon={MarkerYellowDirection}
            iconScale={iconScaleService(1)}
            ref={rotatableMarkerRef}
            iconRotated
            iconAnchor={{ x: 0.5, y: 0.8 }}
            onPress={() => {
              console.info('Press on marker');
            }}
          />
          <SimpleYamap.Marker
            id={'marker-with-animation'}
            point={{ lon: 55, lat: 52 }}
            ref={animatedMarkerRef}
            text={{ text: 'Animated marker' }}
            icon={MarkerGreenDirection}
            iconScale={iconScaleService(1)}
            iconRotated
            iconAnchor={{ x: 0.5, y: 1.0 }}
          />
        </>
      </SimpleYamap>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  box: {
    width: Dimensions.get('screen').width,
    height: Dimensions.get('screen').height,
    zIndex: -100,
  },

  buttonBlock: {
    flex: 1,
    marginTop: 128,
    position: 'absolute',
    alignItems: 'center',
    justifyContent: 'flex-start',
    backgroundColor: 'rgba(30,0,0,0.8)',
    borderRadius: 8,
    padding: 4,
    borderWidth: 2,
    borderColor: 'rgba(110,0,0,0.8)',
    bottom: 190,
  },
  textInfoBlock: {
    position: 'absolute',
    bottom: 64,
    justifyContent: 'flex-start',
    backgroundColor: 'rgba(30,0,0,0.8)',
    borderRadius: 8,
    padding: 16,
    borderWidth: 2,
    borderColor: 'rgba(110,0,0,0.8)',
  },
  textInfo: {
    fontSize: 11,
    color: '#fff',
  },
  buttonRow: {
    flexDirection: 'row',
    gap: 8,
  },
  buttonHeader: {
    fontSize: 16,
    color: '#fff',
    fontWeight: 'bold',
  },

  brandText: {
    position: 'absolute',
    bottom: 32,
    right: 16,
    backgroundColor: 'rgba(30,0,0,0.8)',
    borderWidth: 2,
    borderColor: 'rgba(110,0,0,0.8)',
    padding: 16,
    borderRadius: 4,
    color: '#fff',
    fontWeight: 'bold',
    fontSize: 18,
    lineHeight: 24,
  },
  subBrandText: {
    fontSize: 10,
  },
});

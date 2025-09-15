import {
  Button,
  Dimensions,
  processColor,
  StyleSheet,
  Text,
  View,
} from 'react-native';

import React, { useEffect, useState } from 'react';
import { SimpleYamap } from 'react-native-simple-yamap';
import type { SimplePolygonProps } from '../../src/components';

const safeProcessColor = (color: string): number | undefined => {
  const processed = processColor(color);
  if (typeof processed === 'number') {
    return processed;
  }
  return undefined;
};

const initialPolygons: SimplePolygonProps[] = [
  {
    id: 'poly1',
    points: [
      { lat: 10, lon: 20 },
      { lat: 10, lon: 100 },
      { lat: 50, lon: 100 },
      { lat: 50, lon: 20 },
    ],
    fillColor: safeProcessColor('rgba(100, 100, 250, 0.1)'),
    strokeColor: safeProcessColor('rgba(0, 0, 100, 1)'),
    strokeWidth: 1.0,
  },
  {
    id: 'poly2',
    points: [
      { lat: 60, lon: 20 },
      { lat: 60, lon: 100 },
      { lat: 100, lon: 100 },
    ],
    fillColor: safeProcessColor('rgba(100, 0, 0, 1)'),
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
}

interface TextInfoBlockProps {
  lon: number;
  lat: number;
  zoom: number;
  tilt: number;
  azimuth: number;
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
    </View>
  );
};

export default function App() {
  const [lon, setLon] = useState<number>(37.62);
  const [lat, setLat] = useState<number>(55.75);
  const [zoom, setZoom] = useState<number>(3);
  const [nightMode, setNightMode] = useState<boolean>(false);
  const [tilt, setTilt] = useState<number>(10);
  const [azimuth, setAzimuth] = useState<number>(0);
  const [polygons, setPolygons] = useState<SimplePolygonProps[]>([]);

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
    setLon((prev) => prev - 1);
  };

  const right = () => {
    setLon((prev) => prev + 1);
  };

  const up = () => {
    setLat((prev) => prev + 1);
  };

  const down = () => {
    setLat((prev) => prev - 1);
  };

  const zoomIn = () => {
    setZoom((prev) => prev + 1);
  };

  const zoomOut = () => {
    setZoom((prev) => prev - 1);
  };

  const azimuthDecrease = () => {
    setAzimuth((prev) => prev - 10);
  };
  const azimuthIncrease = () => {
    setAzimuth((prev) => prev + 10);
  };

  const getRandomBetween = (a: number, b: number): number => {
    return Math.random() * (b - a) + a;
  };

  const tiltUp = () => {
    setTilt((prev) => prev + 10);
  };
  const tiltDown = () => {
    setTilt((prev) => prev - 10);
  };
  const setRandomPosition = () => {
    const latV = getRandomBetween(10, 100);
    const lonV = getRandomBetween(10, 150);

    setLon(lonV);
    setLat(latV);
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
      />
      <TextInfoBlock
        lon={lon}
        lat={lat}
        zoom={zoom}
        tilt={tilt}
        azimuth={azimuth}
      />

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
            strokeColor={poly.strokeColor}
            strokeWidth={poly.strokeWidth}
            fillColor={poly.fillColor}
            points={poly.points}
          />
        ))}
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

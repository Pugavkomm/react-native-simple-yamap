import iconScaleService from '../services/iconScaleService';
import {
  MarkerGreen,
  MarkerGreenDirection,
  MarkerYellow,
  MarkerYellowDirection,
} from '../images';
import React, { useCallback, useEffect, useRef, useState } from 'react';
import SimpleYamap, {
  type Point,
  type YamapMarkerRef,
} from 'react-native-simple-yamap';

const MARKER_SPEED = 20;

const MarkersComponent: React.FC = () => {
  const [movableMarkerPosition, setMovableMarkerPosition] = useState<Point>({
    lat: 30,
    lon: 70,
  });
  const moveMarkerTimerIdRef = useRef<NodeJS.Timeout | null>(null);
  const angleTimerRef = useRef<NodeJS.Timeout | null>(null);
  const [angle, setAngle] = useState<number>(200);
  const animatedMarkerRef = useRef<YamapMarkerRef | null>(null);
  const rotatableMarkerRef = useRef<YamapMarkerRef | null>(null);

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

  return (
    <>
      <SimpleYamap.Marker
        id={'marker-4'}
        position={{ lon: 74, lat: 40 }}
        text={{ text: 'Only text marker' }}
        iconScale={iconScaleService(1)}
      />
      <SimpleYamap.Marker
        id={'marker-z-index-20'}
        position={{ lon: 50, lat: 40 }}
        text={{ text: 'zIndex=20' }}
        zIndex={20}
        iconScale={iconScaleService(2)}
        icon={MarkerGreen}
      />
      <SimpleYamap.Marker
        id={'marker-z-index-10'}
        position={{ lon: 58, lat: 38 }}
        text={{ text: 'zIndex=10' }}
        zIndex={10}
        iconScale={iconScaleService(2)}
        icon={MarkerYellow}
      />
      <SimpleYamap.Marker
        id={'marker-4'}
        position={{ lon: 80, lat: 30 }}
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
        position={{ lon: 55, lat: 52 }}
        ref={animatedMarkerRef}
        text={{ text: 'Animated marker' }}
        icon={MarkerGreenDirection}
        iconScale={iconScaleService(1)}
        iconRotated
        iconAnchor={{ x: 0.5, y: 1.0 }}
      />
    </>
  );
};

export default MarkersComponent;

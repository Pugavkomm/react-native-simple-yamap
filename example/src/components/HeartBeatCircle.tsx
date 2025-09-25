import SimpleYamap, { type YamapCircleRef } from 'react-native-simple-yamap';
import { useEffect, useRef, useState } from 'react';

const MAX_RADIUS = 2000000;
const MIN_RADIUS = 100;
const MIN_LAT = -60;
const MAX_LAT = 60;
const MIN_LON = -100;
const MAX_LON = 140;

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
  const [color, _] = useState<number>(getColor());
  const circleRef = useRef<YamapCircleRef | null>(null);

  const changeCenter = () => {
    const newLon = Math.random() * (MAX_LON - MIN_LON) + MIN_LON;
    const newLat = Math.random() * (MAX_LAT - MIN_LAT) + MIN_LAT;
    const newRadius = Math.random() * (MAX_RADIUS - MIN_RADIUS) + MIN_RADIUS;
    circleRef.current?.animatedMove(
      { lon: newLon, lat: newLat },
      0.8,
      newRadius
    );
  };

  useEffect(() => {
    const intervalId = setInterval(() => {
      changeCenter();
    }, 1000);
    return () => clearInterval(intervalId);
  }, []);

  return (
    <SimpleYamap.Circle
      id={'circle-1'}
      center={{ lon: 10, lat: 25 }}
      radius={100000}
      fillColor={color}
      strokeColor={SimpleYamap.color('rgba(255, 0, 100, 0.8)')}
      strokeWidth={1}
      zIndex={1000}
      ref={circleRef}
    />
  );
};

export default HeartBeatCircle;

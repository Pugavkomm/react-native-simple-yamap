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
      center={{ lon: 10, lat: 25 }}
      radius={radius}
      fillColor={color}
      strokeColor={SimpleYamap.color('rgba(255, 0, 100, 0.8)')}
      strokeWidth={1}
      zIndex={1000}
    />
  );
};

export default HeartBeatCircle;

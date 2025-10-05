import SimpleYamap, { type Point } from 'react-native-simple-yamap';
import { useEffect, useState, useRef, useMemo } from 'react';

// NOTE: animated with js

const generateMeandr = (
  startPoint: Point,
  segmentLength: number,
  amplitude: number,
  steps: number
): Point[] => {
  const points = [startPoint];
  let lastLon = startPoint.lon;
  let lastLat = startPoint.lat;
  let direction = 1;

  for (let i = 0; i < steps; i++) {
    if (i % 2 === 0) {
      lastLon += segmentLength;
    } else {
      lastLat += amplitude * direction;
      direction *= -1;
    }
    points.push({ lon: lastLon, lat: lastLat });
  }
  return points;
};

const AMPL_MAX = 40;
const AMPL_MIN = 0.5;
const ANIMATION_DURATION = 100;

const MeanderComponent = () => {
  const startPoint: Point = useMemo<Point>(
    () => ({ lon: 37.62, lat: 55.75 }),
    []
  );
  const [targetAmpl, setTargetAmpl] = useState<number>(5);
  const [meanderPoints, setMeanderPoints] = useState<Point[]>(() =>
    generateMeandr(startPoint, 5, 4, 12)
  );
  const animationFrameId = useRef<number>(0);

  useEffect(() => {
    const intervalId = setInterval(() => {
      setTargetAmpl(Math.random() * (AMPL_MAX - AMPL_MIN) + AMPL_MIN);
    }, 1000);

    return () => {
      clearInterval(intervalId);
    };
  }, []);

  useEffect(() => {
    const startTime = Date.now();
    const startPoints = meanderPoints;
    const endPoints = generateMeandr(startPoint, targetAmpl, 4, 12);

    const animate = () => {
      const now = Date.now();
      const elapsed = now - startTime;
      const progress = Math.min(elapsed / ANIMATION_DURATION, 1);

      const interpolatedPoints = startPoints.map((startPnt: Point, index) => {
        const endPoint = endPoints[index]!;
        const lat = startPnt.lat + (endPoint.lat - startPnt.lat) * progress;
        const lon = startPnt.lon + (endPoint.lon - startPnt.lon) * progress;
        return { lat, lon };
      });

      setMeanderPoints(interpolatedPoints);

      if (progress < 1) {
        animationFrameId.current = requestAnimationFrame(animate);
      }
    };

    animationFrameId.current = requestAnimationFrame(animate);

    return () => {
      if (animationFrameId.current) {
        cancelAnimationFrame(animationFrameId.current);
      }
    };
  }, [meanderPoints, startPoint, targetAmpl]);

  return (
    <>
      <SimpleYamap.Marker
        id={'comment for meander'}
        position={{ lon: 37.62, lat: 55 }}
        text={{ text: 'ANIMATED WITH JS CODE' }}
      />
      <SimpleYamap.PolyLine
        id={'polyline-1'}
        points={meanderPoints}
        strokeWidth={10}
        strokeColor={SimpleYamap.color('#278A47')}
        outlineWidth={5}
        outlineColor={SimpleYamap.color('#706AD9')}
      />
    </>
  );
};

export default MeanderComponent;

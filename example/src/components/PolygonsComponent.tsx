import React, { useEffect, useState } from 'react';
import SimpleYamap, {
  type SimplePolygonProps,
} from 'react-native-simple-yamap';

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
    fillColor: SimpleYamap.color('rgba(100, 100, 250, 0.2)'),
    strokeColor: SimpleYamap.color('rgba(0, 0, 100, 0.1)'),
    strokeWidth: 1.0,
  },
  {
    id: 'poly2',
    points: [
      { lat: 60, lon: 20 },
      { lat: 60, lon: 100 },
      { lat: 100, lon: 100 },
    ],
    fillColor: SimpleYamap.color('rgba(100, 0, 0, 0.3)'),
    strokeColor: SimpleYamap.color('rgba(50, 0, 0, 1)'),
    strokeWidth: 2.0,
  },
];

const PolygonsComponent: React.FC = () => {
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

  return (
    <>
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
        fillColor={SimpleYamap.color('rgba(100, 0, 0, 0.3)')}
        strokeWidth={2}
        strokeColor={SimpleYamap.color('rgba(100, 0, 100, 0.9)')}
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
    </>
  );
};

export default PolygonsComponent;

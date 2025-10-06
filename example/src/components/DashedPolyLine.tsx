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

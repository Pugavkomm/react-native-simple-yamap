import React from 'react';
import SimpleYamapPolyLineViewNativeComponent from '../native-components/SimpleYamapPolylineViewNativeComponent';
import type { Point } from 'react-native-simple-yamap';

export interface SimplePolyLineProps {
  id: string;
  points: Readonly<Point[]>;
  strokeWidth?: number;
  outlineWidth?: number;
  strokeColor?: number;
  outlineColor?: number;
  zIndex?: number;
}

const SimplePolyLine: React.FC<SimplePolyLineProps> = (props) => {
  return (
    <SimpleYamapPolyLineViewNativeComponent
      id={props.id}
      points={props.points}
      strokeWidth={props.strokeWidth}
      strokeColor={props.strokeColor}
      outlineWidth={props.outlineWidth}
      outlineColor={props.outlineColor}
      zIndexV={props.zIndex}
    />
  );
};

export default SimplePolyLine;

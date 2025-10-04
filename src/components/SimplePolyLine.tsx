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
}

const SimplePolyLine: React.FC<SimplePolyLineProps> = (props) => {
  return <SimpleYamapPolyLineViewNativeComponent {...props} />;
};

export default SimplePolyLine;

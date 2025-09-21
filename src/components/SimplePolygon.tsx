import SimpleYamapPolygonViewNativeComponent from '../native-components/SimpleYamapPolygonViewNativeComponent';
import React from 'react';
import type { Point } from '../interfaices';

export interface SimplePolygonProps {
  id: string;
  points: Readonly<Point[]>;
  innerPoints?: Readonly<Point[][]>;
  fillColor?: number;
  strokeColor?: number;
  strokeWidth?: number;
}

const SimplePolygon: React.FC<SimplePolygonProps> = (props) => {
  return <SimpleYamapPolygonViewNativeComponent {...props} />;
};

export default SimplePolygon;

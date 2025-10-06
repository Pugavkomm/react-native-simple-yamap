import React from 'react';
import SimpleYamapPolyLineViewNativeComponent from '../native-components/SimpleYamapPolylineViewNativeComponent';
import type { Point } from 'react-native-simple-yamap';

export interface SimplePolyLineRenderConfig {
  turnRadius?: number;
  arcApproximationStep?: number;
}

export interface SimplePolyLineDashStyle {
  dashLength?: number;
  gapLength?: number;
  dashOffset?: number;
}

export interface SimplePolyLineProps {
  id: string;
  points: Readonly<Point[]>;
  strokeWidth?: number;
  outlineWidth?: number;
  strokeColor?: number;
  outlineColor?: number;
  dashStyle?: SimplePolyLineDashStyle;
  renderConfig?: SimplePolyLineRenderConfig;
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
      dashLength={props.dashStyle?.dashLength}
      dashOffset={props.dashStyle?.dashOffset}
      gapLength={props.dashStyle?.gapLength}
      turnRadius={props.renderConfig?.turnRadius}
      arcApproximationStep={props.renderConfig?.arcApproximationStep}
    />
  );
};

export default SimplePolyLine;

import SimpleYamapCircleViewNativeComponent from '../native-components/SimpleYamapCircleViewNativeComponent';
import type { Point } from 'react-native-simple-yamap';

export interface SimpleCircleProps {
  id: string;
  center: Point;
  radius: number;
  fillColor?: number;
  strokeColor?: number;
  strokeWidth?: number;
  zIndex?: number;
}

const SimpleCircle: React.FC<SimpleCircleProps> = (props) => {
  return (
    <SimpleYamapCircleViewNativeComponent
      id={props.id}
      center={props.center}
      radius={props.radius}
      fillColor={props.fillColor}
      strokeColor={props.strokeColor}
      strokeWidth={props.strokeWidth}
      zIndexV={props.zIndex}
    />
  );
};

export default SimpleCircle;

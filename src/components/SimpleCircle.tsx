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
  return <SimpleYamapCircleViewNativeComponent {...props} />;
};

export default SimpleCircle;

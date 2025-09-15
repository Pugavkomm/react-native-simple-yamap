import { codegenNativeComponent, type ViewProps } from 'react-native';
import type {
  Double,
  Float,
  Int32,
} from 'react-native/Libraries/Types/CodegenTypesNamespace';

type Point = Readonly<{
  lon: Double;
  lat: Double;
}>;

export interface NativeProps extends ViewProps {
  id: string;
  points: Readonly<Point[]>;
  fillColor?: Int32;
  strokeColor?: Int32;
  strokeWidth?: Float;
}

export default codegenNativeComponent<NativeProps>('SimpleYamapPolygonView');

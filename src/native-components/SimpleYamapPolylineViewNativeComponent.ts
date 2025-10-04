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
  strokeWidth?: Float;
  outlineWidth?: Float;
  strokeColor?: Int32;
  outlineColor?: Int32;
}

export default codegenNativeComponent<NativeProps>('SimpleYamapPolyLineView');

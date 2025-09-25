import type {
  Double,
  Float,
  Int32,
} from 'react-native/Libraries/Types/CodegenTypesNamespace';
import { codegenNativeComponent, type ViewProps } from 'react-native';

type Point = Readonly<{
  lon: Double;
  lat: Double;
}>;

export interface NativeProps extends ViewProps {
  id: string;
  center: Point;
  radius: Float;
  fillColor?: Int32;
  strokeColor?: Int32;
  strokeWidth?: Float;
  zIndexV?: Double;
}

export default codegenNativeComponent<NativeProps>('SimpleYamapCircleView');

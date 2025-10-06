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
  // Geometry configuration
  points: Readonly<Point[]>;
  // Style configuration
  strokeWidth?: Float;
  outlineWidth?: Float;
  strokeColor?: Int32;
  outlineColor?: Int32;
  zIndexV?: Float;
  // Dash configuration
  dashLength?: Float;
  gapLength?: Float;
  dashOffset?: Float;
  // Render configuration
  turnRadius?: Float;
  arcApproximationStep?: Float;
}

export default codegenNativeComponent<NativeProps>('SimpleYamapPolyLineView');

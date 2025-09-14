import { codegenNativeComponent, type ViewProps } from 'react-native';
import type {
  Double,
  Float,
  Int32,
} from 'react-native/Libraries/Types/CodegenTypesNamespace';

export type Point = Readonly<{
  lon: Double;
  lat: Double;
}>;

export type Polygon = Readonly<{
  id: string;
  points: Readonly<Point[]>;
  fillColor?: Int32;
  strokeColor?: Int32;
  strokeWidth?: Float;
}>;

export type CameraPosition = Readonly<{
  lon: Double;
  lat: Double;
  zoom: Float;
  duration: Float;
  azimuth?: Float;
  tilt?: Float;
}>;

interface NativeProps extends ViewProps {
  nightMode?: boolean;
  cameraPosition?: CameraPosition;
  polygons?: Readonly<Polygon[]>;
}

export default codegenNativeComponent<NativeProps>('SimpleYamapView');

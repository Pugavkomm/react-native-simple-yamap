import { codegenNativeComponent, type ViewProps } from 'react-native';
import type {
  Double,
  Float,
} from 'react-native/Libraries/Types/CodegenTypesNamespace';

export type Point = Readonly<{
  lon: Double;
  lat: Double;
}>;

export type CameraPosition = Readonly<{
  lon: Double;
  lat: Double;
  zoom: Float;
  duration: Float;
  azimuth?: Float;
  tilt?: Float;
}>;

export interface NativeProps extends ViewProps {
  nightMode?: boolean;
  cameraPosition?: CameraPosition;
}

export default codegenNativeComponent<NativeProps>('SimpleYamapView');

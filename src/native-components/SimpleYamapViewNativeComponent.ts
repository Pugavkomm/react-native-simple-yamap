import {
  codegenNativeCommands,
  codegenNativeComponent,
  type HostComponent,
  type ViewProps,
} from 'react-native';
import type {
  Double,
  Float,
} from 'react-native/Libraries/Types/CodegenTypesNamespace';
import type { DirectEventHandler } from 'react-native/Libraries/Types/CodegenTypesNamespace';

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

export type CameraPositionEvent = Readonly<{
  lon: Double;
  lat: Double;
  zoom: Float;
  tilt: Float;
  azimuth: Float;
  reason: string;
  // reason: 'GESTURES' | 'APPLICATION';
  finished: boolean;
}>;

export interface NativeProps extends ViewProps {
  nightMode?: boolean;
  cameraPosition?: CameraPosition;
  onCameraPositionChange?: DirectEventHandler<CameraPositionEvent>;
  onCameraPositionChangeEnd?: DirectEventHandler<CameraPositionEvent>;
}

export interface NativeCommands {
  setCenter: (
    viewRef: React.ElementRef<HostComponent<NativeProps>>,
    lon: Double,
    lat: Double,
    zoom: Float,
    duration: Float,
    azimuth?: Float,
    tilt?: Float
  ) => void;
}

export const Commands: NativeCommands = codegenNativeCommands<NativeCommands>({
  supportedCommands: ['setCenter'],
});

export default codegenNativeComponent<NativeProps>('SimpleYamapView');

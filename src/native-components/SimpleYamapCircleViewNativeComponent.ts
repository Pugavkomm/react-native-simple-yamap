import type {
  Double,
  Float,
  Int32,
} from 'react-native/Libraries/Types/CodegenTypesNamespace';
import {
  codegenNativeCommands,
  codegenNativeComponent,
  type HostComponent,
  type ViewProps,
} from 'react-native';

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

export interface NativeCommands {
  animatedMove: (
    viewRef: React.ElementRef<HostComponent<NativeProps>>,
    lon: Double,
    lat: Double,
    durationInSeconds: Float,
    radius?: Float
  ) => void;
}

export const Commands: NativeCommands = codegenNativeCommands<NativeCommands>({
  supportedCommands: ['animatedMove'],
});

export default codegenNativeComponent<NativeProps>('SimpleYamapCircleView');

import {
  codegenNativeCommands,
  codegenNativeComponent,
  type HostComponent,
  type ViewProps,
} from 'react-native';
import type {
  BubblingEventHandler,
  Double,
  Float,
} from 'react-native/Libraries/Types/CodegenTypesNamespace';

type Point = Readonly<{
  lon: Double;
  lat: Double;
}>;

type Text = Readonly<{
  text: string;
}>;

export type ImageSource = Readonly<{
  uri: string;
}>;

export type IconAnchor = Readonly<{
  x: Float;
  y: Float;
}>;

export interface NativeProps extends ViewProps {
  id: string;
  point: Point;
  text?: Text;
  icon?: ImageSource;
  iconScale?: Double;
  iconRotated?: boolean;
  iconAnchor?: IconAnchor;
  zIndexV?: Double;
  onTap?: BubblingEventHandler<Readonly<{}>> | null;
  transitionDurationPosition?: Float; // seconds
}

export interface NativeCommands {
  animatedMove: (
    viewRef: React.ElementRef<HostComponent<NativeProps>>,
    lon: Double,
    lat: Double,
    durationInSeconds: Float
  ) => void;
  animatedRotate: (
    viewRef: React.ElementRef<HostComponent<NativeProps>>,
    angle: Float,
    durationInSeconds: Float
  ) => void;
}

export const Commands: NativeCommands = codegenNativeCommands<NativeCommands>({
  supportedCommands: ['animatedMove', 'animatedRotate'],
});

export default codegenNativeComponent<NativeProps>('SimpleYamapMarkerView');

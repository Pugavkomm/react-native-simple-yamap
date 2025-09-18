import SimpleYamapMarkerViewNativeComponent, {
  Commands,
  type ImageSource,
  type NativeProps,
} from '../native-components/SimpleYamapMarkerViewNativeComponent';
import type { Point } from 'react-native-simple-yamap';
import { Image, type ImageSourcePropType } from 'react-native';
import { forwardRef, useImperativeHandle, useMemo, useRef } from 'react';

export interface MarkerText {
  text: string;
}

export interface IconAnchor {
  x: number;
  y: number;
}

export interface SimpleMarkerProps {
  id: string;
  point: Point;
  text?: MarkerText;
  icon?: ImageSourcePropType;
  iconScale?: number;
  iconRotated?: boolean;
  iconAnchor?: IconAnchor;
  zIndex?: number;
  onPress?: () => void;
}

export interface YamapMarkerRef {
  animatedMove(point: Point, durationInSeconds: number): void;
  animatedRotate(angle: number, durationInSeconds: number): void;
}
const SimpleMarkerRender: React.ForwardRefRenderFunction<
  YamapMarkerRef,
  SimpleMarkerProps
> = (props, ref) => {
  const nativeRef =
    useRef<React.ComponentRef<typeof SimpleYamapMarkerViewNativeComponent>>(
      null
    );

  const nativeIcon = useMemo((): ImageSource | undefined => {
    if (!props.icon) {
      return undefined;
    }
    const uri = Image.resolveAssetSource(props.icon)?.uri;
    return uri ? { uri: uri } : undefined;
  }, [props.icon]);
  const componentProps: NativeProps = {
    id: props.id,
    point: props.point,
    text: props.text,
    iconScale: props.iconScale,
    iconRotated: props.iconRotated === undefined ? false : props.iconRotated,
    iconAnchor: !props.iconAnchor ? { x: 0.5, y: 0.5 } : props.iconAnchor,
    zIndexV: props.zIndex,
    onTap: props.onPress,
  };

  // Handlers
  useImperativeHandle(ref, () => ({
    animatedMove(point: Point, durationInSeconds: number) {
      if (nativeRef.current) {
        Commands.animatedMove(
          nativeRef.current,
          point.lon,
          point.lat,
          durationInSeconds
        );
      }
    },
    animatedRotate(angle: number, durationInSeconds: number) {
      if (nativeRef.current) {
        Commands.animatedRotate(nativeRef.current, angle, durationInSeconds);
      }
    },
  }));

  if (nativeIcon) {
    componentProps.icon = nativeIcon;
  }
  return (
    <SimpleYamapMarkerViewNativeComponent {...componentProps} ref={nativeRef} />
  );
};

const SimpleMarker = forwardRef(SimpleMarkerRender);
export default SimpleMarker;

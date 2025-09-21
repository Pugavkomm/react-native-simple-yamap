import SimpleYamapViewNativeComponent, {
  Commands,
} from '../native-components/SimpleYamapViewNativeComponent';
import {
  forwardRef,
  type ReactElement,
  useImperativeHandle,
  useRef,
} from 'react';
import type { CameraPosition, CameraPositionEvent } from '../interfaices';
import type { StyleProp, ViewStyle } from 'react-native';
import type {
  Double,
  Float,
} from 'react-native/Libraries/Types/CodegenTypesNamespace';
import { type SimpleMarkerProps } from './SimpleMarker';
import { type SimplePolygonProps } from './SimplePolygon';

export interface YamapProps {
  cameraPosition?: CameraPosition;
  children?:
    | ReactElement<SimpleMarkerProps | SimplePolygonProps>
    | ReactElement<SimpleMarkerProps | SimplePolygonProps>[];
  nightMode?: boolean;
  onCameraPositionChange?: (event: CameraPositionEvent) => void;
  onCameraPositionChangeEnd?: (event: CameraPositionEvent) => void;
}

export type SimpleYamapProps = YamapProps & {
  style?: StyleProp<ViewStyle>;
};

export interface YamapRef {
  setCenter(center: CameraPosition): void;
}
const SimpleYamapRender: React.ForwardRefRenderFunction<
  YamapRef,
  SimpleYamapProps
> = (props, ref) => {
  const nativeRef =
    useRef<React.ComponentRef<typeof SimpleYamapViewNativeComponent>>(null);

  useImperativeHandle(ref, () => ({
    setCenter(center: CameraPosition) {
      if (nativeRef.current) {
        Commands.setCenter(
          nativeRef.current,
          center.point.lon,
          center.point.lat,
          center.zoom,
          center.duration,
          center.azimuth,
          center.tilt
        );
      }
    },
  }));

  const handleChangeCameraPosition = (
    nativeEvent: Readonly<{
      lon: Double;
      lat: Double;
      zoom: Float;
      tilt: Float;
      azimuth: Float;
      reason: string;
      finished: boolean;
    }>
  ): CameraPositionEvent => {
    return {
      point: { lat: nativeEvent.lat, lon: nativeEvent.lon },
      azimuth: nativeEvent.azimuth,
      finished: nativeEvent.finished,
      reason: nativeEvent.reason,
      tilt: nativeEvent.tilt,
      zoom: nativeEvent.zoom,
    };
  };

  return (
    <SimpleYamapViewNativeComponent
      ref={nativeRef}
      style={props.style}
      nightMode={props.nightMode}
      onCameraPositionChange={(p) => {
        if (props.onCameraPositionChange) {
          props.onCameraPositionChange(
            handleChangeCameraPosition(p.nativeEvent)
          );
        }
      }}
      onCameraPositionChangeEnd={(p) => {
        if (props.onCameraPositionChangeEnd) {
          props.onCameraPositionChangeEnd(
            handleChangeCameraPosition(p.nativeEvent)
          );
        }
      }}
      cameraPosition={
        props.cameraPosition && {
          lon: props.cameraPosition.point.lon,
          lat: props.cameraPosition.point.lat,
          zoom: props.cameraPosition.zoom,
          azimuth: props.cameraPosition.azimuth,
          tilt: props.cameraPosition.tilt,
          duration: props.cameraPosition.duration || 0.5,
        }
      }
    >
      {props.children}
    </SimpleYamapViewNativeComponent>
  );
};

const SimpleYamapView = forwardRef(SimpleYamapRender);

export default SimpleYamapView;

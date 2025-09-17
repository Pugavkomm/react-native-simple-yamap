import SimpleYamapViewNativeComponent from '../native-components/SimpleYamapViewNativeComponent';
import type { ReactNode } from 'react';
import type { CameraPosition } from '../interfaices';
import type { StyleProp, ViewStyle } from 'react-native';

export interface YamapProps {
  cameraPosition?: CameraPosition;
  nightMode?: boolean;
  children?: ReactNode;
}

export type SimpleYamapProps = YamapProps & {
  style?: StyleProp<ViewStyle>;
};

const SimpleYamapView: React.FC<SimpleYamapProps> = (props) => {
  return (
    <SimpleYamapViewNativeComponent
      style={props.style}
      nightMode={props.nightMode}
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

export default SimpleYamapView;

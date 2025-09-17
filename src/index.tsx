// index.ts

import type { NativeProps as MapViewProps } from './native-components/SimpleYamapViewNativeComponent';
import BaseMapView from './native-components/SimpleYamapViewNativeComponent';
import type { NativeProps as PolygonProps } from './native-components/SimpleYamapPolygonViewNativeComponent';

import {
  type MarkerText,
  SimpleMarker,
  type SimpleMarkerProps,
  SimplePolygon,
  type SimpleYamapProps,
  SimpleYamapView,
} from './components';

import type { YamapMarkerRef } from './native-components/SimpleYamapMarkerViewNativeComponent';

export type { Point, CameraPosition } from './interfaices';
export type { PolygonProps };
export type { MapViewProps };
export type { MarkerText };
export type { YamapMarkerRef };

const SimpleYamap: React.FC<SimpleYamapProps> & {
  Polygon: typeof SimplePolygon;
  Marker: React.ForwardRefExoticComponent<
    SimpleMarkerProps & React.RefAttributes<YamapMarkerRef>
  >;
} = (props) => {
  return <SimpleYamapView {...props} />;
};

SimpleYamap.Polygon = SimplePolygon;
SimpleYamap.Marker = SimpleMarker;

export { BaseMapView, SimplePolygon, SimpleYamap, SimpleMarker };
export default SimpleYamap;

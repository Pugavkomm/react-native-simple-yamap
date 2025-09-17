// index.ts

import type { NativeProps as MapViewProps } from './SimpleYamapViewNativeComponent';
import BaseMapView from './SimpleYamapViewNativeComponent';
import type { NativeProps as PolygonProps } from './SimpleYamapPolygonViewNativeComponent';

import {
  type MarkerText,
  SimpleMarker,
  type SimpleMarkerProps,
  SimplePolygon,
  type SimpleYamapProps,
  SimpleYamapView,
} from './components';

import type { YamapMarkerRef } from './SimpleYamapMarkerViewNativeComponent';

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

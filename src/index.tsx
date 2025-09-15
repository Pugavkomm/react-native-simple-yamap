// index.ts

import type { NativeProps as MapViewProps } from './SimpleYamapViewNativeComponent';
import BaseMapView from './SimpleYamapViewNativeComponent';
import type { NativeProps as PolygonProps } from './SimpleYamapPolygonViewNativeComponent';
import PolygonView from './SimpleYamapPolygonViewNativeComponent';
import {
  SimplePolygon,
  type SimpleYamapProps,
  SimpleYamapView,
} from './components';
export type { Point, CameraPosition } from './interfaices';

export type { PolygonProps };
export type { MapViewProps };

const SimpleYamap: React.FC<SimpleYamapProps> & {
  Polygon: typeof SimplePolygon;
} = (props) => {
  return <SimpleYamapView {...props} />;
};

SimpleYamap.Polygon = PolygonView;

export { BaseMapView, SimplePolygon, SimpleYamap };
export default SimpleYamap;

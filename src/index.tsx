// index.ts

import type { NativeProps as MapViewProps } from './native-components/SimpleYamapViewNativeComponent';
import BaseMapView from './native-components/SimpleYamapViewNativeComponent';
import type { NativeProps as PolygonProps } from './native-components/SimpleYamapPolygonViewNativeComponent';

import {
  type MarkerText,
  SimpleMarker,
  SimplePolygon,
  SimpleYamapView,
} from './components';

import type { YamapMarkerRef } from './components/SimpleMarker';
import type { YamapRef } from './components/SimpleYamap';
import type { CameraPosition, CameraPositionEvent, Point } from './interfaices';

export type {
  PolygonProps,
  MapViewProps,
  MarkerText,
  YamapMarkerRef,
  YamapRef,
  Point,
  CameraPosition,
  CameraPositionEvent,
};

type YamapComposition = typeof SimpleYamapView & {
  Marker: typeof SimpleMarker;
  Polygon: typeof SimplePolygon;
};

const SimpleYamap = SimpleYamapView as YamapComposition;

SimpleYamap.Polygon = SimplePolygon;
SimpleYamap.Marker = SimpleMarker;

export { BaseMapView, SimplePolygon, SimpleYamap, SimpleMarker };
export default SimpleYamap;

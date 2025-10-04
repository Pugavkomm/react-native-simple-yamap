// index.ts

import BaseMapView from './native-components/SimpleYamapViewNativeComponent';

import {
  type MarkerText,
  SimpleMarker,
  SimplePolygon,
  SimpleCircle,
  SimpleYamapView,
  type SimpleCircleProps,
  type SimpleMarkerProps,
  type SimplePolygonProps,
  SimplePolyLine,
} from './components';

import type { YamapMarkerRef } from './components/SimpleMarker';
import type { YamapRef } from './components/SimpleYamap';
import type { CameraPosition, CameraPositionEvent, Point } from './interfaices';
import type { YamapCircleRef } from './components/SimpleCircle';

export type {
  SimpleMarkerProps,
  SimplePolygonProps,
  SimpleCircleProps,
  MarkerText,
  YamapMarkerRef,
  YamapRef,
  Point,
  CameraPosition,
  CameraPositionEvent,
  YamapCircleRef,
};

type YamapComposition = typeof SimpleYamapView & {
  Marker: typeof SimpleMarker;
  Polygon: typeof SimplePolygon;
  Circle: typeof SimpleCircle;
  PolyLine: typeof SimplePolyLine;
  color: typeof simpleColorConverter;
};

import { simpleColorConverter } from './utils';

const SimpleYamap = SimpleYamapView as YamapComposition;

SimpleYamap.Polygon = SimplePolygon;
SimpleYamap.Marker = SimpleMarker;
SimpleYamap.Circle = SimpleCircle;
SimpleYamap.PolyLine = SimplePolyLine;
SimpleYamap.color = simpleColorConverter;

export { BaseMapView, SimplePolygon, SimpleYamap, SimpleMarker, SimpleCircle };
export { simpleColorConverter };
export default SimpleYamap;

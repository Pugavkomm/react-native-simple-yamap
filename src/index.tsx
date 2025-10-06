// index.ts

import BaseMapView from './native-components/SimpleYamapViewNativeComponent';

import {
  type MarkerText,
  SimpleCircle,
  type SimpleCircleProps,
  SimpleMarker,
  type SimpleMarkerProps,
  SimplePolygon,
  type SimplePolygonProps,
  SimplePolyLine,
  type SimplePolyLineDashStyle,
  type SimplePolyLineRenderConfig,
  SimpleYamapView,
} from './components';

import type { YamapMarkerRef } from './components/SimpleMarker';
import type { YamapRef } from './components/SimpleYamap';
import type { CameraPosition, CameraPositionEvent, Point } from './interfaices';
import type { YamapCircleRef } from './components/SimpleCircle';
import { simpleColorConverter } from './utils';

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
  SimplePolyLineDashStyle,
  SimplePolyLineRenderConfig,
};

type YamapComposition = typeof SimpleYamapView & {
  Marker: typeof SimpleMarker;
  Polygon: typeof SimplePolygon;
  Circle: typeof SimpleCircle;
  PolyLine: typeof SimplePolyLine;
  color: typeof simpleColorConverter;
};

const SimpleYamap = SimpleYamapView as YamapComposition;

SimpleYamap.Polygon = SimplePolygon;
SimpleYamap.Marker = SimpleMarker;
SimpleYamap.Circle = SimpleCircle;
SimpleYamap.PolyLine = SimplePolyLine;
SimpleYamap.color = simpleColorConverter;

export { BaseMapView, SimplePolygon, SimpleYamap, SimpleMarker, SimpleCircle };
export { simpleColorConverter };
export default SimpleYamap;

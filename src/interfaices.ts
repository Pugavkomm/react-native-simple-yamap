export interface Point {
  lon: number;
  lat: number;
}

export interface CameraPosition {
  point: Point;
  zoom: number;
  duration: number;
  azimuth?: number;
  tilt?: number;
}

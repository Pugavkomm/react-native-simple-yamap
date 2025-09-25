import SimpleYamapCircleViewNativeComponent, {
  Commands,
} from '../native-components/SimpleYamapCircleViewNativeComponent';
import type { Point } from 'react-native-simple-yamap';
import { forwardRef, useImperativeHandle, useRef } from 'react';

export interface SimpleCircleProps {
  id: string;
  center: Point;
  radius: number;
  fillColor?: number;
  strokeColor?: number;
  strokeWidth?: number;
  zIndex?: number;
}

export interface YamapCircleRef {
  animatedMove(point: Point, durationInSeconds: number, radius: number): void;
}

const SimpleCircleRender: React.ForwardRefRenderFunction<
  YamapCircleRef,
  SimpleCircleProps
> = (props, ref) => {
  const nativeRef =
    useRef<React.ComponentRef<typeof SimpleYamapCircleViewNativeComponent>>(
      null
    );

  useImperativeHandle(ref, () => ({
    animatedMove(point: Point, durationInSeconds: number, radius?: number) {
      if (nativeRef.current) {
        Commands.animatedMove(
          nativeRef.current,
          point.lon,
          point.lat,
          durationInSeconds,
          radius
        );
      }
    },
  }));

  return (
    <SimpleYamapCircleViewNativeComponent
      id={props.id}
      center={props.center}
      radius={props.radius}
      fillColor={props.fillColor}
      strokeColor={props.strokeColor}
      strokeWidth={props.strokeWidth}
      zIndexV={props.zIndex}
      ref={nativeRef}
    />
  );
};

const SimpleCircle = forwardRef(SimpleCircleRender);

export default SimpleCircle;

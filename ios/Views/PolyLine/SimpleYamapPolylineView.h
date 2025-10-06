//
//  SimpleYamapPolylineView.h
//
//  Created by Mechislav Pugavko on 03/10/2025.
//
#import <YandexMapsMobile/YMKMapObjectTapListener.h>
#import <YandexMapsMobile/YMKMapCameraListener.h>
#import <React/RCTViewComponentView.h>
#import <UIKit/UIKit.h>

#ifndef SimpleYamapPolyLineViewNativeComponent_h
#define SimpleYamapPolyLineViewNativeComponent_h

NS_ASSUME_NONNULL_BEGIN

@class RNYMapPolyLine;
@interface SimpleYamapPolyLineView : RCTViewComponentView
- (RNYMapPolyLine *)getView;
@end
NS_ASSUME_NONNULL_END

#endif

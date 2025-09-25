//
//  SimpleYamapCircleView.h
//
//  Created by Mechislav Pugavko on 24/09/2025.
//

#import <YandexMapsMobile/YMKMapObjectTapListener.h>
#import <YandexMapsMobile/YMKMapCameraListener.h>
#import <React/RCTViewComponentView.h>
#import <UIKit/UIKit.h>


#ifndef SimpleYamapCircleViewNativeComponent_h
#define SimpleYamapCircleViewNativeComponent_h


NS_ASSUME_NONNULL_BEGIN
@class RNYMapCircle;

@interface SimpleYamapCircleView : RCTViewComponentView
- (RNYMapCircle *)getView;

@end

NS_ASSUME_NONNULL_END

#endif /* SimpleYamapCircleViewNativeComponent_h */

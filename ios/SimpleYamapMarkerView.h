//
//  SimpleYamapMarkerView.h
//  Pods
//
//  Created by Mechislav Pugavko on 15/09/2025.
//
#import <React/RCTViewComponentView.h>
#import <UIKit/UIKit.h>


#ifndef SimpleYamapMarkerViewNativeComponent_h
#define SimpleYamapMarkerViewNativeComponent_h


NS_ASSUME_NONNULL_BEGIN
@class RNYMapMarker;

@interface SimpleYamapMarkerView : RCTViewComponentView
- (RNYMapMarker *)getView;

@end

NS_ASSUME_NONNULL_END

#endif /* SimpleYamapMarkerViewNativeComponent_h */

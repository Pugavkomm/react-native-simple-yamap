//
//  SimpleYamapPolygonView.h
//  Pods
//
//  Created by Mechislav Pugavko on 14/09/2025.
//
#import <React/RCTViewComponentView.h>
#import <UIKit/UIKit.h>


#ifndef SimpleYamapPolygonViewNativeComponent_h
#define SimpleYamapPolygonViewNativeComponent_h


NS_ASSUME_NONNULL_BEGIN
@class RNYMapPolygon;

@interface SimpleYamapPolygonView : RCTViewComponentView
- (RNYMapPolygon *)getView;
@end

NS_ASSUME_NONNULL_END

#endif /* SimpleYamapPolygonViewNativeComponent_h */

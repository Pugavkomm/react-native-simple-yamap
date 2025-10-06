//
//  SimpleYamapPolygonView.mm
//  SimpleYamap
//
//  Created by Mechislav Pugavko on 14/09/2025.
//

#import "SimpleYamapPolygonView.h"

#import <react/renderer/components/SimpleYamapViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/SimpleYamapViewSpec/EventEmitters.h>
#import <react/renderer/components/SimpleYamapViewSpec/Props.h>
#import <react/renderer/components/SimpleYamapViewSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"
#import <YandexMapsMobile/YMKMapObjectTapListener.h>
#import <YandexMapsMobile/YMKMapCameraListener.h>
#import <YandexMapsMobile/YMKMapView.h>
#import "SimpleYamap-Swift.h"

using namespace facebook::react;

@interface SimpleYamapPolygonView () <RCTSimpleYamapPolygonViewViewProtocol>
@end

@implementation SimpleYamapPolygonView {
  RNYMapPolygon * _view;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<SimpleYamapPolygonViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        static const auto defaultProps = std::make_shared<const SimpleYamapPolygonViewProps>();
        _props = defaultProps;
        _view = [[RNYMapPolygon alloc] init];
        self.contentView = _view;
    }
    return self;
}

// Refactor props to new approach
- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
  const auto &oldViewProps = *std::static_pointer_cast<SimpleYamapPolygonViewProps const>(_props);
  const auto &newViewProps = *std::static_pointer_cast<SimpleYamapPolygonViewProps const>(props);
  
  _view.id = [NSString stringWithUTF8String:newViewProps.id.c_str()];
  
  // Outer points
  NSMutableArray *outerRings = [NSMutableArray new];
  // TODO: compare old and new rings
  for (const auto &point : newViewProps.points) {
    NSMutableDictionary  *pointDict = [NSMutableDictionary new];
    pointDict[@"lat"] = @(point.lat);
    pointDict[@"lon"] = @(point.lon);
    [outerRings addObject:pointDict];
    }
  _view.outerRing = outerRings;
  
  
  // Inner points
  // TODO: compare old and new rings
  NSMutableArray *innerRings = [NSMutableArray new];
  for (const auto &points : newViewProps.innerPoints) {
    NSMutableArray *innerRing = [NSMutableArray new];
    for (const auto &point : points) {
      NSMutableDictionary *pointDict = [NSMutableDictionary new];
      pointDict[@"lat"] = @(point.lat);
      pointDict[@"lon"] = @(point.lon);
      [innerRing addObject:pointDict];
    }
    [innerRings addObject:innerRing];
  }
  _view.innerRings = innerRings;
  
  
  
  // Colors & Width
  if (oldViewProps.fillColor != newViewProps.fillColor) {
    _view.fillColor = @(newViewProps.fillColor);
  }
  if (oldViewProps.strokeColor != newViewProps.strokeColor){
    _view.strokeColor = @(newViewProps.strokeColor);
  }
  if (oldViewProps.strokeWidth != newViewProps.strokeWidth) {
    _view.strokeWidth = @(newViewProps.strokeWidth);
  }
  
  [super updateProps:props oldProps:oldProps];
}



- (RNYMapPolygon *)getView {
    return _view;
}

@end

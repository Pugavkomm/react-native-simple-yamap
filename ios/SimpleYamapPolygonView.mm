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
  
  // Points
  NSMutableArray *points = [NSMutableArray new];
  for (const auto &point : newViewProps.points) {
    NSMutableDictionary  *pointDict = [NSMutableDictionary new];
    pointDict[@"lat"] = @(point.lat);
    pointDict[@"lon"] = @(point.lon);
    [points addObject:pointDict];
    }
  _view.points = points;
  // Colors & Width
  NSLog(@"Call update from update props: %d", newViewProps.strokeColor);
  _view.fillColor = @(newViewProps.fillColor);
  _view.strokeColor = @(newViewProps.strokeColor);
  _view.strokeWidth = @(newViewProps.strokeWidth);
  [super updateProps:props oldProps:oldProps];
}



- (RNYMapPolygon *)getView {
    return _view;
}

@end

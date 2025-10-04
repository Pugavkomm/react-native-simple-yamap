//
//  SimpleYamapPolylineView.mm
//  Pods
//
//  Created by Mechislav Pugavko on 03/10/2025.
//

#import <react/renderer/components/SimpleYamapViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/SimpleYamapViewSpec/Props.h>
#import <react/renderer/components/SimpleYamapViewSpec/RCTComponentViewHelpers.h>

#import <YandexMapsMobile/YMKMapView.h>
#import "RCTFabricComponentsPlugins.h"
#import "SimpleYamapPolyLineView.h"
#import "SimpleYamap-Swift.h"

using namespace facebook::react;

@interface SimpleYamapPolyLineView()  <RCTSimpleYamapPolyLineViewViewProtocol>
@end

@implementation SimpleYamapPolyLineView {
  RNYMapPolyLine * _view;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<SimpleYamapPolyLineViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]){
    static const auto defaultProps = std::make_shared<const SimpleYamapPolygonViewProps>();
    _props = defaultProps;
    _view = [[RNYMapPolyLine alloc] init];
    self.contentView = _view;
  }
  return self;
}


-(void)updateProps:(const facebook::react::Props::Shared &)props oldProps:(const facebook::react::Props::Shared &)oldProps
{
  
  const auto &oldViewProps = *std::static_pointer_cast<SimpleYamapPolyLineViewProps const>(_props);
  const auto &newViewProps = *std::static_pointer_cast<SimpleYamapPolyLineViewProps const>(props);
  
  
  if (oldViewProps.strokeColor != newViewProps.strokeColor){
    _view.strokeColor = @(newViewProps.strokeColor);
  }
  
  if (oldViewProps.strokeWidth != newViewProps.strokeWidth) {
    _view.strokeWidth = @(newViewProps.strokeWidth);
  }
  
  if (oldViewProps.outlineColor != newViewProps.outlineColor) {
    _view.outlineColor = @(newViewProps.outlineColor);
  }
  
  if (oldViewProps.outlineWidth != newViewProps.outlineWidth) {
    _view.outlineWidth = @(newViewProps.outlineWidth);
  }
  
  bool pointsEqual = (oldViewProps.points.size() == newViewProps.points.size()) &&
                     std::equal(
                         oldViewProps.points.begin(),
                         oldViewProps.points.end(),
                         newViewProps.points.begin(),
                         [](const SimpleYamapPolyLineViewPointsStruct& p1,
                            const SimpleYamapPolyLineViewPointsStruct& p2) {
                             return p1.lat == p2.lat && p1.lon == p2.lon;
                         }
                     );
  if (!pointsEqual){
    NSMutableArray *polyLinePoints = [NSMutableArray new];
    for (const auto &points : newViewProps.points){
      NSMutableDictionary *pointDict = [NSMutableDictionary new];
      pointDict[@"lat"] = @(points.lat);
      pointDict[@"lon"] = @(points.lon);
      [polyLinePoints addObject:pointDict];
    }
    _view.points = polyLinePoints;
  }
    
  
  
  [super updateProps:props oldProps:oldProps];
}

- (RNYMapPolyLine *)getView {
  return _view;
}
@end



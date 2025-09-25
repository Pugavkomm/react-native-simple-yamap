//
//  SimpleYamapCircleView.mm
//
//  Created by Mechislav Pugavko on 24/09/2025.
//

#import <react/renderer/components/SimpleYamapViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/SimpleYamapViewSpec/Props.h>
#import <react/renderer/components/SimpleYamapViewSpec/RCTComponentViewHelpers.h>

#import <YandexMapsMobile/YMKMapView.h>
#import "RCTFabricComponentsPlugins.h"
#import "SimpleYamapCircleView.h"
#import "SimpleYamap-Swift.h"

using namespace facebook::react;

@interface SimpleYamapCircleView() <RCTSimpleYamapCircleViewViewProtocol>
@end

@implementation SimpleYamapCircleView {
  RNYMapCircle * _view;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<SimpleYamapCircleViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const SimpleYamapCircleViewProps>();
    _props = defaultProps;
    _view = [[RNYMapCircle alloc] init];
    self.contentView = _view;
  }
  return self;
}



- (void)updateProps:(const facebook::react::Props::Shared &)props oldProps:(const facebook::react::Props::Shared &)oldProps
{
  const auto &oldViewProps = *std::static_pointer_cast<SimpleYamapCircleViewProps const>(_props);
  const auto &newViewProps = *std::static_pointer_cast<SimpleYamapCircleViewProps const>(props);
  
  const auto center = newViewProps.center;
  NSMutableDictionary *centerDict = [NSMutableDictionary new];
  centerDict[@"lon"] = @(center.lon);
  centerDict[@"lat"] = @(center.lat);
  _view.circleCenter = centerDict;
  if (oldViewProps.radius != newViewProps.radius){
    _view.radius = newViewProps.radius;
  }
  
  if(oldViewProps.fillColor != newViewProps.fillColor) {
    _view.fillColor = @(newViewProps.fillColor);
  }
  
  if(oldViewProps.strokeColor != newViewProps.strokeColor) {
    _view.strokeColor = @(newViewProps.strokeColor);
  }
  
  if (oldViewProps.strokeWidth != newViewProps.strokeWidth) {
    _view.strokeWidth = @(newViewProps.strokeWidth);
  }
  
  if (oldViewProps.zIndexV != newViewProps.zIndexV) {
    _view.zIndexV = @(newViewProps.zIndexV);
  }
  
  [super updateProps:props oldProps:oldProps];
}

- (RNYMapCircle *)getView {
  return _view;
}

@end

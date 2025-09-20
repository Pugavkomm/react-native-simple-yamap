//
//  SimpleYamapMarkerView.mm
//  SimpleYamap
//
//  Created by Mechislav Pugavko on 15/09/2025.
//
#import <react/renderer/components/SimpleYamapViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/SimpleYamapViewSpec/EventEmitters.h>
#import <react/renderer/components/SimpleYamapViewSpec/Props.h>
#import <react/renderer/components/SimpleYamapViewSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"
#import <YandexMapsMobile/YMKMapView.h>
#import <YandexMapsMobile/YMKMapObjectTapListener.h>
#import "SimpleYamapMarkerView.h"
#import "SimpleYamap-Swift.h"

using namespace facebook::react;

@interface SimpleYamapMarkerView() <RCTSimpleYamapMarkerViewViewProtocol>
@end

@implementation SimpleYamapMarkerView {
  RNYMapMarker * _view;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<SimpleYamapMarkerViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const SimpleYamapMarkerViewProps>();
    _props = defaultProps;
    _view = [[RNYMapMarker alloc] init];
    self.contentView = _view;
    
    // onTap callback
    __weak SimpleYamapMarkerView *weakSelf = self;
    _view.onTap = ^{
      SimpleYamapMarkerView *strongSelf = weakSelf;
      if (!strongSelf) {
        return;
      }
      if (strongSelf->_eventEmitter) {
        strongSelf.eventEmitter.onTap({});
      }
    };
  }
  return self;
}


- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
  const auto &oldViewProps = *std::static_pointer_cast<SimpleYamapMarkerViewProps const>(_props);
  const auto &newViewProps = *std::static_pointer_cast<SimpleYamapMarkerViewProps const>(props);
  
  // TODO: Skip without changes props: old == new
  _view.id = [NSString stringWithUTF8String:newViewProps.id.c_str()];
  // Points
  const auto point = newViewProps.point;
  NSMutableDictionary *pointDict = [NSMutableDictionary new];
  pointDict[@"lat"] = @(point.lat);
  pointDict[@"lon"] = @(point.lon);
  _view.point = pointDict;
  if (!newViewProps.text.text.empty()){
    const char* c_string = newViewProps.text.text.c_str();
    NSString *objectiveCString = [NSString stringWithUTF8String:c_string];
    _view.text = objectiveCString;
  }
  
  CGFloat clampedX = fmax(0.0, fmin(1.0, newViewProps.iconAnchor.x));
  CGFloat clampedY = fmax(0.0, fmin(1.0, newViewProps.iconAnchor.y));
  CGPoint clampedAnchor = CGPointMake(clampedX, clampedY);
  _view.iconAnchor = [NSValue valueWithCGPoint:clampedAnchor];
  
  
  if (oldViewProps.iconRotated != newViewProps.iconRotated) {
    _view.iconRotated = newViewProps.iconRotated;
  }
  
  _view.zIndexV = @(newViewProps.zIndexV);
  
  const auto &imageSource = newViewProps.icon;
  if(!imageSource.uri.empty()) {
    _view.iconSource = [NSString stringWithUTF8String:imageSource.uri.c_str()];
  } else {
    _view.iconSource = nil;
  }
  
  if (newViewProps.iconScale > 0) {
    _view.iconScale = @(newViewProps.iconScale);
  } else {
    _view.iconScale = @(1.0);
  }
  [super updateProps:props oldProps:oldProps];
}


-(void)handleCommand:(const NSString *)commandName args:(const NSArray *)args
{
  RCTSimpleYamapMarkerViewHandleCommand(self, commandName, args);
}

-(void)animatedRotate:(float)angle durationInSeconds:(float)durationInSeconds
{
  [_view animatedRotateWithAngle:angle duration:durationInSeconds];
}

-(void)animatedMove:(double)lon lat:(double)lat durationInSeconds:(float)durationInSeconds
{
  NSMutableDictionary *pointDict = [NSMutableDictionary new];
  pointDict[@"lon"] = @(lon);
  pointDict[@"lat"]  = @(lat);
  [_view animatedMoveWithPointDict:pointDict duration:durationInSeconds];
}



// Event emitter convenience method
- (const SimpleYamapMarkerViewEventEmitter &)eventEmitter
{
  return static_cast<const SimpleYamapMarkerViewEventEmitter &>(*_eventEmitter);
}

- (RNYMapMarker *)getView {
  return _view;
}

@end

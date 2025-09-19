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

// Handlers TODO: refactor
- (void)handleCommand:(NSString const *)commandName args:(NSArray const *)args
{
  if ([commandName isEqualToString:@"animatedMove"]) {
    // BEFORE:
    // // 0 - point
    // // 1 - duration
    // if (args.count == 2 && [args[0] isKindOfClass:[NSDictionary class]] && [args[1] isKindOfClass:[NSNumber class]]) {
    //   [_view animatedMoveWithPointDict:args[0] duration:[args[1] floatValue]];
    // }
    
    // AFTER:
    // 0 - lon
    // 1 - lat
    // 2 - duration
    if (args.count == 3 && [args[0] isKindOfClass:[NSNumber class]] && [args[1] isKindOfClass:[NSNumber class]] && [args[2] isKindOfClass:[NSNumber class]]) {
      // Reconstruct the point dictionary here
      NSMutableDictionary *pointDict = [NSMutableDictionary new];
      pointDict[@"lon"] = args[0];
      pointDict[@"lat"] = args[1];
      
      [_view animatedMoveWithPointDict:pointDict duration:[args[2] floatValue]];
      
    } else {
      RCTLogError(@"Invalid arguments for command 'animatedMove'. Expected lon, lat, duration.");
    }
    return;
  } else if ([commandName isEqualToString:@"animatedRotate"]){
    // 0 - angle (float)
    // 1 - duration (float)
    if (args.count == 2 && [args[0] isKindOfClass:[NSNumber class]] && [args[1] isKindOfClass:[NSNumber class]]) {
      [_view animatedRotateWithAngle:[args[0] floatValue] duration:[args[1] floatValue]];
    }
    return;
  }
  [super handleCommand:commandName args:args];
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

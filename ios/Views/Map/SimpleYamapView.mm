//
// SimpleYamapView.mm
//


#import <YandexMapsMobile/YMKMapCameraListener.h>
#import <react/renderer/components/SimpleYamapViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/SimpleYamapViewSpec/EventEmitters.h>
#import <react/renderer/components/SimpleYamapViewSpec/Props.h>
#import <react/renderer/components/SimpleYamapViewSpec/RCTComponentViewHelpers.h>
#import "RCTFabricComponentsPlugins.h"
#import <YandexMapsMobile/YMKMapView.h>
#import <YandexMapsMobile/YMKMapKit.h>
#import "SimpleYamapPolygonView.h"
#import "SimpleYamapView.h"
#import "SimpleYamapMarkerView.h"
#import "SimpleYamapCircleView.h"
#import "SimpleYamapPolylineView.h"
#import "SimpleYamap-Swift.h"
#import <folly/dynamic.h>
#import <jsi/jsi.h>

using namespace facebook::react;
using namespace facebook::jsi;

// HELPLER JSI -> NSOBJECT
static NSObject* convertJsiValueToNSObject(Runtime& runtime,
                                           const facebook::jsi::Value& value) {
  if (value.isUndefined() || value.isNull()) {
    return [NSNull null];
  }
  if (value.isBool()) {
    return @(value.getBool());
  }
  if (value.isNumber()) {
    return @(value.getNumber());
  }
  if (value.isString()) {
    return [NSString stringWithUTF8String:value.getString(runtime).utf8(runtime).c_str()];
  }
  if (value.isObject()) {
    auto obj = value.getObject(runtime);
    if (obj.isArray(runtime)) {
      auto arr = obj.getArray(runtime);
      NSMutableArray* nsArr = [NSMutableArray new];
      for (size_t i = 0; i < arr.size(runtime); ++i) {
        [nsArr addObject:convertJsiValueToNSObject(runtime, arr.getValueAtIndex(runtime, i))];
      }
      return nsArr;
    } else {
      NSMutableDictionary* nsDict = [NSMutableDictionary new];
      auto propNames = obj.getPropertyNames(runtime);
      for (size_t i = 0; i < propNames.size(runtime); ++i) {
        auto propName = propNames.getValueAtIndex(runtime, i).getString(runtime);
        auto propValue = obj.getProperty(runtime, propName);
        NSString* key = [NSString stringWithUTF8String:propName.utf8(runtime).c_str()];
        nsDict[key] = convertJsiValueToNSObject(runtime, propValue);
      }
      return nsDict;
    }
  }
  return [NSNull null];
}

@interface SimpleYamapView () <RCTSimpleYamapViewViewProtocol>

@end

// MAP VIEW
@implementation SimpleYamapView {
  RNYMapView * _view;
  std::shared_ptr<const SimpleYamapViewEventEmitter> eventEmitter;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<SimpleYamapViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const SimpleYamapViewProps>();
    _props = defaultProps;
    
    
    _view = [[RNYMapView alloc] init];
    
    self.contentView = (UIView *)_view;
    
    __weak SimpleYamapView *weakSelf = self;
    
    _view.onCameraPositionChange = ^(NSDictionary *payload) {
      SimpleYamapView *strongSelf = weakSelf;
      if (!strongSelf ||  !strongSelf->_eventEmitter ) {
        return;
      }
      
      auto event = SimpleYamapViewEventEmitter::OnCameraPositionChange{};
      event.lon = [payload[@"lon"] doubleValue];
      event.lat = [payload[@"lat"] doubleValue];
      event.zoom = [payload[@"zoom"] floatValue];
      event.tilt = [payload[@"tilt"] floatValue];
      event.azimuth = [payload[@"azimuth"] floatValue];
      event.reason = [[payload[@"reason"] description] UTF8String];
      event.finished = [payload[@"finished"] boolValue];
      strongSelf.eventEmitter.onCameraPositionChange(event);
    };
    
    _view.onCameraPositionChangeEnd = ^(NSDictionary *payload) {
      SimpleYamapView *strongSelf = weakSelf;
      if (!strongSelf || !strongSelf->_eventEmitter) {
        return;
      }
      
      auto event = SimpleYamapViewEventEmitter::OnCameraPositionChangeEnd{};
      event.lon = [payload[@"lon"] doubleValue];
      event.lat = [payload[@"lat"] doubleValue];
      event.zoom = [payload[@"zoom"] floatValue];
      event.tilt = [payload[@"tilt"] floatValue];
      event.azimuth = [payload[@"azimuth"] floatValue];
      event.reason = [[payload[@"reason"] description] UTF8String];
      event.finished = [payload[@"finished"] boolValue];
      
      strongSelf.eventEmitter.onCameraPositionChangeEnd(event);
    };
  }
  
  return self;
}
- (void)mountChildComponentView:(UIView<RCTComponentViewProtocol> *)childComponentView
                          index:(NSInteger)index
{
  if ([childComponentView isKindOfClass:[SimpleYamapPolygonView class]]) {
    SimpleYamapPolygonView *polygonView = (SimpleYamapPolygonView *)childComponentView;
    RNYMapPolygon *polygon = [polygonView getView];
    
    [_view addPolygonChild:polygon];
    
    return;
  } else if ([childComponentView isKindOfClass:[SimpleYamapMarkerView class]]) {
    SimpleYamapMarkerView *markerView = (SimpleYamapMarkerView *)childComponentView;
    RNYMapMarker *marker = [markerView getView];
    [_view addMarkerChild:marker];
    return;
  } else if ([childComponentView isKindOfClass:[SimpleYamapCircleView class]]) {
    SimpleYamapCircleView *circleView = (SimpleYamapCircleView *)childComponentView;
    RNYMapCircle *circle = [circleView getView];
    [_view addCircleChild:circle];
    return;
  } else if ([childComponentView isKindOfClass:[SimpleYamapPolyLineView class]]){
    SimpleYamapPolyLineView *polyLineView = (SimpleYamapPolyLineView *)childComponentView;
    RNYMapPolyLine *polyLine = [polyLineView getView];
    [_view addPolyLineChild:polyLine];
    return;
  }
  
  [super mountChildComponentView:childComponentView index:index];
}

- (void)unmountChildComponentView:(UIView<RCTComponentViewProtocol> *)childComponentView index:(NSInteger)index
{
  if ([childComponentView isKindOfClass:[SimpleYamapPolygonView class]]) {
    SimpleYamapPolygonView *polygonView = (SimpleYamapPolygonView *)childComponentView;
    RNYMapPolygon *polygon = [polygonView getView];
    [_view removePolygonChild:polygon];
    return;
  } else if ([childComponentView isKindOfClass:[SimpleYamapMarkerView class]]) {
    SimpleYamapMarkerView *markerView = (SimpleYamapMarkerView *)childComponentView;
    RNYMapMarker *marker = [markerView getView];
    [_view removeMarkerChild:marker];
    return;
  } else if ([childComponentView isKindOfClass:[SimpleYamapCircleView class]]) {
    SimpleYamapCircleView  *circleView = (SimpleYamapCircleView *)childComponentView;
    RNYMapCircle *circle = [circleView getView];
    [_view removeCircleChild:circle];
    return;
  } else if ([childComponentView isKindOfClass:[SimpleYamapPolyLineView class]]) {
    SimpleYamapPolyLineView *polyLineView = (SimpleYamapPolyLineView *)childComponentView;
    RNYMapPolyLine *polyLine = [polyLineView getView];
    [_view removePolyLineChild:polyLine];
    return;
  }
  
  [super unmountChildComponentView:childComponentView index:index];
}


- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
  const auto &oldViewProps = *std::static_pointer_cast<SimpleYamapViewProps const>(_props);
  const auto &newViewProps = *std::static_pointer_cast<SimpleYamapViewProps const>(props);
  
  // Position
  double lon = newViewProps.cameraPosition.lon;
  double lat = newViewProps.cameraPosition.lat;
  
  // Camera
  float zoom = newViewProps.cameraPosition.zoom;
  float tilt = newViewProps.cameraPosition.tilt;
  float azimuth = newViewProps.cameraPosition.azimuth;
  
  float duration = newViewProps.cameraPosition.duration; // Animation duration
  
  if(lon != oldViewProps.cameraPosition.lon || lat!=oldViewProps.cameraPosition.lat || zoom != oldViewProps.cameraPosition.zoom || azimuth != oldViewProps.cameraPosition.azimuth || tilt != oldViewProps.cameraPosition.tilt){
    zoom = MAX(1.0, zoom);
    duration = MAX(0.0, duration);
    [_view moveMapWithLon:lon lat:lat zoom:zoom duration:duration tilt: tilt azimuth: azimuth];
  }
  
  if (newViewProps.nightMode != oldViewProps.nightMode) {
    if (newViewProps.nightMode){
      [_view enableNightMode];
    } else {
      [_view disableNightMode];
    }
  }
  
  [super updateProps:props oldProps:oldProps];
}
- (void)handleCommand:(const NSString *)commandName args:(const NSArray *)args
{
  RCTSimpleYamapViewHandleCommand(self, commandName, args);
}

- (void)setCenter:(double)lon lat:(double)lat zoom:(float)zoom duration:(float)duration azimuth:(float)azimuth tilt:(float)tilt{
  [_view moveMapWithLon:lon lat:lat zoom:zoom duration:duration tilt:tilt azimuth:azimuth];
}

// Event emitter convenience method
- (const SimpleYamapViewEventEmitter &)eventEmitter
{
  return static_cast<const SimpleYamapViewEventEmitter &>(*_eventEmitter);
}


Class<RCTComponentViewProtocol> SimpleYamapViewCls(void)
{
  return SimpleYamapView.class;
}

@end

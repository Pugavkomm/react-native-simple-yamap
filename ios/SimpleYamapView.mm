//
// SimpleYamapView.mm
//

#import "SimpleYamapView.h"

#import <react/renderer/components/SimpleYamapViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/SimpleYamapViewSpec/EventEmitters.h>
#import <react/renderer/components/SimpleYamapViewSpec/Props.h>
#import <react/renderer/components/SimpleYamapViewSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"

#import <YandexMapsMobile/YMKMapView.h>
#import <YandexMapsMobile/YMKMapKit.h>
#import "SimpleYamapPolygonView.h"

#import "SimpleYamap-Swift.h"
#import <jsi/jsi.h>

using namespace facebook::react;
using namespace facebook::jsi;

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

@implementation SimpleYamapView {
    RNYMapView * _view;
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

  }

  return self;
}
- (void)mountChildComponentView:(UIView<RCTComponentViewProtocol> *)childComponentView
                          index:(NSInteger)index
{
    NSLog(@"Child component type: %@", NSStringFromClass([childComponentView class]));

    if ([childComponentView isKindOfClass:[SimpleYamapPolygonView class]]) {
        SimpleYamapPolygonView *polygonView = (SimpleYamapPolygonView *)childComponentView;
        RNYMapPolygon *polygon = [polygonView getView];
        
        [_view addPolygonChild:polygon];

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
  int zoom = newViewProps.cameraPosition.zoom;
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

Class<RCTComponentViewProtocol> SimpleYamapViewCls(void)
{
    return SimpleYamapView.class;
}

@end

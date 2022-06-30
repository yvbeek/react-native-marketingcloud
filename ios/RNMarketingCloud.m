#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(RNMarketingCloud, NSObject)

+ (BOOL)requiresMainQueueSetup {
  return NO;
}

RCT_EXTERN_METHOD(initializeSDK:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(setDebugLoggingEnabled:(bool)enabled)

RCT_EXTERN_METHOD(getDeviceToken:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(setProfileAttributes:(NSDictionary *)attributes)
RCT_EXTERN_METHOD(getProfileId:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(setProfileId:(NSString *)profileId)
RCT_EXTERN_METHOD(isPushEnabled:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(setPushEnabled:(bool)enabled)

RCT_EXTERN_METHOD(getAllMessages:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(getAllMessagesCount:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(getUnreadMessagesCount:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(markMessageDeleted:(NSString)messageId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(markMessageRead:(NSString)messageId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(markAllMessagesDeleted:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(markAllMessagesRead:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(refreshMessages:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)

@end

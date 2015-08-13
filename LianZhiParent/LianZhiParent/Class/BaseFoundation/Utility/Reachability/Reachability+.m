//
//  Reachability+.m
//  iPhoneVideo
//
//  Created by MingLQ on 2012-04-06.
//  Copyright 2012 SOHU. All rights reserved.
//

#import "Reachability+.h"


typedef NS_ENUM(NSInteger, WWANType) {
    WWANTypeNotAvailable    = - 1,          // can not detect
    WWANTypeNone            = 0,            // has not
    WWANType2G              = 2,
    WWANType3G              = 3,
    WWANType4G              = 4,
    WWANTypeUnknown         = NSIntegerMax  // has, but unknown
};

@interface Reachability (WWANType)

// + (CTTelephonyNetworkInfo *)sharedTelephonyNetworkInfo;
// + (NSString *)currentRadioAccessTechnology;

+ (BOOL)isWWANTypeAvailable;
+ (WWANType)currentWWANType;

@end


#pragma mark -

@implementation Reachability (plus)

+ (Reachability *)sharedReachability {
    static Reachability *SharedReachability = nil;
    
    if (SharedReachability) {
        return SharedReachability;
    }
    
    @synchronized(self) {
        if (!SharedReachability) {
            SharedReachability = [Reachability reachabilityForInternetConnection];
        }
    }
    
    return SharedReachability;
}

+ (NetworkStatus)currentReachabilityStatus {
    return [[self sharedReachability] currentReachabilityStatus];
}

+ (void)addReachabilityChangedNotificationObserver:(id)observer selector:(SEL)selector {
    [[NSNotificationCenter defaultCenter] addObserver:observer
                                             selector:selector
                                                 name:kReachabilityChangedNotification
                                               object:[self sharedReachability]];}

+ (void)removeReachabilityChangedNotificationObserver:(id)observer {
    [[NSNotificationCenter defaultCenter] removeObserver:observer
                                                    name:kReachabilityChangedNotification
                                                  object:[self sharedReachability]];
}

@end


#pragma mark -

@implementation Reachability (CTTelephonyNetworkInfo)

+ (CTTelephonyNetworkInfo *)sharedTelephonyNetworkInfo {
    static CTTelephonyNetworkInfo *SharedTelephonyNetworkInfo = nil;
    
    if (SharedTelephonyNetworkInfo) {
        return SharedTelephonyNetworkInfo;
    }
    
    @synchronized(self) {
        if (!SharedTelephonyNetworkInfo) {
            SharedTelephonyNetworkInfo = [[CTTelephonyNetworkInfo alloc] init];
        }
    }
    
    return SharedTelephonyNetworkInfo;
}

+ (NSString *)currentRadioAccessTechnology {
    return ([[self sharedTelephonyNetworkInfo] respondsToSelector:@selector(currentRadioAccessTechnology)]
            ? [self sharedTelephonyNetworkInfo].currentRadioAccessTechnology
            : nil);
}

@end


#pragma mark -

@implementation Reachability (WWANType)

+ (BOOL)isWWANTypeAvailable {
    return [[self sharedTelephonyNetworkInfo] respondsToSelector:@selector(currentRadioAccessTechnology)];
}

+ (WWANType)currentWWANType {
    if (![self isWWANTypeAvailable]) {
        return WWANTypeNotAvailable;
    }
    
    NSString *currentRadioAccessTechnology = [self currentRadioAccessTechnology];
    if (!currentRadioAccessTechnology) {
        return WWANTypeNone;
    }
    
    static NSDictionary *WWANTypes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // @see https://github.com/appscape/open-rmbt-ios/blob/6125831eadf02ffb4bf356ab1221453ecc6b0e82/Sources/RMBTConnectivity.m
        WWANTypes = @{ CTRadioAccessTechnologyGPRS:            @(WWANType2G),
                       CTRadioAccessTechnologyEdge:            @(WWANType2G),
                       
                       CTRadioAccessTechnologyCDMA1x:          @(WWANType2G),
                       CTRadioAccessTechnologyCDMAEVDORev0:    @(WWANType2G),
                       CTRadioAccessTechnologyCDMAEVDORevA:    @(WWANType2G),
                       CTRadioAccessTechnologyCDMAEVDORevB:    @(WWANType2G),
                       CTRadioAccessTechnologyeHRPD:           @(WWANType2G),
                       
                       CTRadioAccessTechnologyWCDMA:           @(WWANType3G),
                       CTRadioAccessTechnologyHSDPA:           @(WWANType3G),
                       CTRadioAccessTechnologyHSUPA:           @(WWANType3G),
                       
                       CTRadioAccessTechnologyLTE:             @(WWANType4G) };
    });
    
    NSNumber *typeNumber = [WWANTypes objectForKey:[self currentRadioAccessTechnology]];
    return typeNumber ? [typeNumber integerValue] : WWANTypeUnknown;
}

@end


#pragma mark -

@implementation Reachability (NetworkType)

+ (NetworkType)currentNetworkType {
    if ([self notReachable]) {
        return NetworkTypeNone;
    }
    
    if ([self reachableViaWiFi]) {
        return NetworkTypeWiFi;
    }
    
    if ([self reachableViaWWAN]) {
        switch ([self currentWWANType]) {
            case WWANType2G:
                return NetworkType2G;
            case WWANType3G:
                return NetworkType3G;
            case WWANType4G:
                return NetworkType4G;
            default:
                return NetworkTypeUnknownWWAN;
        }
    }
    
    return NetworkTypeNone; // NetworkTypeUnknown?
}

+ (BOOL)notReachable {
    return [self currentReachabilityStatus] == NotReachable;
}

+ (BOOL)reachableViaWiFi {
    return [self currentReachabilityStatus] == ReachableViaWiFi;
}

+ (BOOL)reachableViaWWAN {
    return [self currentReachabilityStatus] == ReachableViaWWAN;
}

+ (BOOL)reachableViaWWAN2G {
    return [self reachableViaWWAN] && [self isWWANTypeAvailable] && [self currentWWANType] == WWANType2G;
}

+ (BOOL)reachableViaWWAN3G {
    return [self reachableViaWWAN] && [self isWWANTypeAvailable] && [self currentWWANType] == WWANType3G;
}

+ (BOOL)reachableViaWWAN4G {
    return [self reachableViaWWAN] && [self isWWANTypeAvailable] && [self currentWWANType] == WWANType4G;
}

+ (void)addNetworkTypeChangedNotificationObserver:(id)observer selector:(SEL)selector {
    if (&CTRadioAccessTechnologyDidChangeNotification) {
        
        // !!!: init shared CTTelephonyNetworkInfo instance before add notification observer
        // @see the comments of this method in the header file
        [self sharedTelephonyNetworkInfo];
        
        // !!!: object is the CTRadioAccessTechnologyXXX instead of the CTTelephonyNetworkInfo instance
        [[NSNotificationCenter defaultCenter] addObserver:observer
                                                 selector:selector
                                                     name:CTRadioAccessTechnologyDidChangeNotification
                                                   object:nil];
    }
    else {
        [self addReachabilityChangedNotificationObserver:observer selector:selector];
    }
}

+ (void)removeNetworkTypeChangedNotificationObserver:(id)observer {
    if (&CTRadioAccessTechnologyDidChangeNotification) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer
                                                        name:CTRadioAccessTechnologyDidChangeNotification
                                                      object:nil];
    }
    else {
        [self removeReachabilityChangedNotificationObserver:observer];
    }
}

@end


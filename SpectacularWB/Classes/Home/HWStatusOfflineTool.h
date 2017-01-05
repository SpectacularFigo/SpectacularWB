//
//  HWStatusOfflineTool.h
//  SpectacularWB
//
//  Created by Figo Han on 2016-10-03.
//  Copyright © 2016 Figo Han. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWStatusOfflineTool : NSObject
/**将微博数组存进数据库 */
+(void)saveStatus:(NSArray*)statuses;
/** return stored status in databasse*/
+(NSArray*)offineStatusWithDictionary:(NSDictionary*)parameters;
@end

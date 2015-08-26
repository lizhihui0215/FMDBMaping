//
//  Entity.h
//  FMDBMapping
//
//  Created by 李智慧 on 8/21/15.
//  Copyright © 2015 lizhihui. All rights reserved.
//

#import "BaseEntity.h"
@protocol test <NSObject>

@end
@interface Entity : BaseEntity
@property (nonatomic, strong) NSString *tableName;


- (void)save;





@end

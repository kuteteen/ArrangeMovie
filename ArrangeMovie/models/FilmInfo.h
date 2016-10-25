#import <UIKit/UIKit.h>

@interface FilmInfo : NSObject

@property (nonatomic, strong) NSString * daoyan;
@property (nonatomic, strong) NSString * imagename;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * yanyuan;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
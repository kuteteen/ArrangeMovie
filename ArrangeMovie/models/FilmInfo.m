//
//	FilmInfo.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "FilmInfo.h"

NSString *const kFilmInfoDaoyan = @"daoyan";
NSString *const kFilmInfoImagename = @"imagename";
NSString *const kFilmInfoTitle = @"title";
NSString *const kFilmInfoYanyuan = @"yanyuan";

@interface FilmInfo ()
@end
@implementation FilmInfo




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kFilmInfoDaoyan] isKindOfClass:[NSNull class]]){
		self.daoyan = dictionary[kFilmInfoDaoyan];
	}	
	if(![dictionary[kFilmInfoImagename] isKindOfClass:[NSNull class]]){
		self.imagename = dictionary[kFilmInfoImagename];
	}	
	if(![dictionary[kFilmInfoTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kFilmInfoTitle];
	}	
	if(![dictionary[kFilmInfoYanyuan] isKindOfClass:[NSNull class]]){
		self.yanyuan = dictionary[kFilmInfoYanyuan];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.daoyan != nil){
		dictionary[kFilmInfoDaoyan] = self.daoyan;
	}
	if(self.imagename != nil){
		dictionary[kFilmInfoImagename] = self.imagename;
	}
	if(self.title != nil){
		dictionary[kFilmInfoTitle] = self.title;
	}
	if(self.yanyuan != nil){
		dictionary[kFilmInfoYanyuan] = self.yanyuan;
	}
	return dictionary;

}


@end
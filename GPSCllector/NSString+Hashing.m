

#import "NSString+Hashing.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (NSString_Hashing)

//两个方法获取到的是一样结果

- (NSString *)MD5Hash
{
	const char *cStr = [self UTF8String];
	unsigned char result[16];
	CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
	return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]];
}

-(id)md5
{
    const char *cStr = [self UTF8String];
     unsigned char digest[16];
     unsigned int x=(int)strlen(cStr) ;
    CC_MD5( cStr, x, digest );
     // This is the md5 call
     NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
     [output appendFormat:@"%02x", digest[i]];
    }
    return  output;
}

@end


 


@class NSString;



@interface NSData (Encryption)


- (NSData *)AES256EncryptWithKey:(NSString *)key withInitialization:( const void *)iv;   //加密

- (NSData *)AES256DecryptWithKey:(NSString *)key withInitialization:( const void *)iv;  //解密

- (NSString *)newStringInBase64FromData;            //追加64编码

+ (NSString*)base64encode:(NSString*)str;           //同上64编码




@end


 
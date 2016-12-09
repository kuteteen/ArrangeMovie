//
//  CKRSAUtil.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/11/26.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "CKRSAUtil.h"

@implementation CKRSAUtil

+ (NSData *)getSHA1HashBytes:(NSData *)plainText {
    CC_SHA1_CTX ctx;
    uint8_t * hashBytes = NULL;
    NSData * hash = nil;
    
    // Malloc a buffer to hold hash.
    hashBytes = malloc( kSHA1ChosenDigestLength * sizeof(uint8_t) );
    memset((void *)hashBytes, 0x0, kSHA1ChosenDigestLength);
    // Initialize the context.
    CC_SHA1_Init(&ctx);
    // Perform the hash.
    CC_SHA1_Update(&ctx, (void *)[plainText bytes], [plainText length]);
    // Finalize the output.
    CC_SHA1_Final(hashBytes, &ctx);
    
    // Build up the SHA1 blob.
    hash = [NSData dataWithBytes:(const void *)hashBytes length:(NSUInteger)kSHA1ChosenDigestLength];
    if (hashBytes) free(hashBytes);
    
    return hash;
}

+ (NSData *)getMD5HashBytes:(NSString *)plainText {
    
    const char *cStr = [plainText UTF8String];
    unsigned char digest[kMD5ChosenDigestLength];
    CC_MD5( cStr, strlen(cStr), digest );
    
    NSData *hash = [[NSData alloc]initWithBytes:digest length:kMD5ChosenDigestLength];
    
    return hash;
}

+ (NSData *)getMD51HashBytes:(NSData *)plainText {
    CC_MD5_CTX ctx;
    uint8_t * hashBytes = NULL;
    NSData * hash = nil;
    
    // Malloc a buffer to hold hash.
    hashBytes = malloc( kMD5ChosenDigestLength * sizeof(uint8_t) );
    memset((void *)hashBytes, 0x0, kMD5ChosenDigestLength);
    // Initialize the context.
    CC_MD5_Init(&ctx);
    // Perform the hash.
    CC_MD5_Update(&ctx, (void *)[plainText bytes], [plainText length]);
    // Finalize the output.
    CC_MD5_Final(hashBytes, &ctx);
    
    // Build up the SHA1 blob.
    hash = [NSData dataWithBytes:(const void *)hashBytes length:(NSUInteger)kMD5ChosenDigestLength];
    if (hashBytes) free(hashBytes);
    
    return hash;
}

+(NSString *)signTheDataSHA1WithRSA:(NSString *)plainText
{
    uint8_t* signedBytes = NULL;
    size_t signedBytesSize = 0;
    OSStatus sanityCheck = noErr;
    NSData* signedHash = nil;
    
    NSString * path = [[NSBundle mainBundle]pathForResource:@"private_key" ofType:@"p12"];
    NSData * data = [NSData dataWithContentsOfFile:path];
    NSMutableDictionary * options = [[NSMutableDictionary alloc] init]; // Set the private key query dictionary.
    [options setObject:@"123456" forKey:(id)kSecImportExportPassphrase];
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus securityError = SecPKCS12Import((CFDataRef) data, (CFDictionaryRef)options, &items);
    if (securityError!=noErr) {
        return nil ;
    }
    CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
    SecIdentityRef identityApp =(SecIdentityRef)CFDictionaryGetValue(identityDict,kSecImportItemIdentity);
    SecKeyRef privateKeyRef=nil;
    SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
    signedBytesSize = SecKeyGetBlockSize(privateKeyRef);
    
    NSData *plainTextBytes = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    
    signedBytes = malloc( signedBytesSize * sizeof(uint8_t) ); // Malloc a buffer to hold signature.
    memset((void *)signedBytes, 0x0, signedBytesSize);
    //kSecPaddingPKCS1SHA1   SecKeyRawSign
    sanityCheck = SecKeyRawSign(privateKeyRef,
                                kSecPaddingPKCS1SHA1,
                                (const uint8_t *)[[self getSHA1HashBytes:plainTextBytes] bytes],
                                kSHA1ChosenDigestLength,
                                (uint8_t *)signedBytes,
                                &signedBytesSize);
    
    if (sanityCheck == noErr)
    {
        signedHash = [NSData dataWithBytes:(const void *)signedBytes length:(NSUInteger)signedBytesSize];
    }
    else
    {
        return nil;
    }
    
    if (signedBytes)
    {
        free(signedBytes);
    }
    NSString *signatureResult=[NSString stringWithFormat:@"%@",[signedHash base64EncodedString]];
    return signatureResult;
}

+(NSString *)signTheDataMD5WithRSA:(NSString *)plainText
{
    uint8_t* signedBytes = NULL;
    size_t signedBytesSize = 0;
    OSStatus sanityCheck = noErr;
    NSData* signedHash = nil;
    
    NSString * path = [[NSBundle mainBundle]pathForResource:@"private_key" ofType:@"p12"];
    NSData * data = [NSData dataWithContentsOfFile:path];
    NSMutableDictionary * options = [[NSMutableDictionary alloc] init]; // Set the private key query dictionary.
    [options setObject:@"123456" forKey:(id)kSecImportExportPassphrase];
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus securityError = SecPKCS12Import((CFDataRef) data, (CFDictionaryRef)options, &items);
    if (securityError!=noErr) {
        return nil ;
    }
    CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
    SecIdentityRef identityApp =(SecIdentityRef)CFDictionaryGetValue(identityDict,kSecImportItemIdentity);
    SecKeyRef privateKeyRef=nil;
    SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
    signedBytesSize = SecKeyGetBlockSize(privateKeyRef);
    
     NSData *plainTextBytes = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    
    signedBytes = malloc( signedBytesSize * sizeof(uint8_t) ); // Malloc a buffer to hold signature.
    memset((void *)signedBytes, 0x0, signedBytesSize);
    sanityCheck = SecKeyRawSign(privateKeyRef,
                                kSecPaddingPKCS1MD5,
                                (const uint8_t *)[[self getMD51HashBytes:plainTextBytes] bytes],
                                kMD5ChosenDigestLength,
                                (uint8_t *)signedBytes,
                                &signedBytesSize);
    
    if (sanityCheck == noErr)
    {
        signedHash = [NSData dataWithBytes:(const void *)signedBytes length:(NSUInteger)signedBytesSize];
    }
    else
    {
        return nil;
    }
    
    if (signedBytes)
    {
        free(signedBytes);
    }
    NSString *signatureResult=[NSString stringWithFormat:@"%@",[signedHash base64EncodedString]];
    return signatureResult;
}

+(SecKeyRef)getPublicKey{
    NSString *certPath = [[NSBundle mainBundle] pathForResource:@"keystore" ofType:@"p7b"];
    SecCertificateRef myCertificate = nil;
    NSData *certificateData = [[NSData alloc] initWithContentsOfFile:certPath];
    myCertificate = SecCertificateCreateWithData(kCFAllocatorDefault, (CFDataRef)certificateData);
    SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
    SecTrustRef myTrust;
    OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);
    SecTrustResultType trustResult;
    if (status == noErr) {
        status = SecTrustEvaluate(myTrust, &trustResult);
    }
    return SecTrustCopyPublicKey(myTrust);
}


+(NSString *)RSAEncrypotoTheData:(NSString *)plainText
{
    
    SecKeyRef publicKey=nil;
    publicKey=[self getPublicKey];
    size_t cipherBufferSize = SecKeyGetBlockSize(publicKey);
    uint8_t *cipherBuffer = NULL;
    
    cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    memset((void *)cipherBuffer, 0*0, cipherBufferSize);
    
    NSData *plainTextBytes = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    int blockSize = cipherBufferSize-11;  // 这个地方比较重要是加密问组长度
    int numBlock = (int)ceil([plainTextBytes length] / (double)blockSize);
    NSMutableData *encryptedData = [[NSMutableData alloc] init];
    for (int i=0; i<numBlock; i++) {
        int bufferSize = MIN(blockSize,[plainTextBytes length]-i*blockSize);
        NSData *buffer = [plainTextBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        OSStatus status = SecKeyEncrypt(publicKey,
                                        kSecPaddingPKCS1,
                                        (const uint8_t *)[buffer bytes],
                                        [buffer length],
                                        cipherBuffer,
                                        &cipherBufferSize);
        if (status == noErr)
        {
            NSData *encryptedBytes = [[NSData alloc]
                                       initWithBytes:(const void *)cipherBuffer
                                       length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
        }
        else
        {
            return nil;
        }
    }
    if (cipherBuffer)
    {
        free(cipherBuffer);
    }
    NSString *encrypotoResult=[NSString stringWithFormat:@"%@",[encryptedData base64EncodedString]];
    return encrypotoResult;
}

@end

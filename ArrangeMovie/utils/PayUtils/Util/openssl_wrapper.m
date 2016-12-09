//
//  openssl_wrapper.m
//  ThirdDemoApp
//
//  Created by Xu Hanjie on 11-1-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "openssl_wrapper.h"

#import "rsa.h"
#include "pem.h"
#include "md5.h"
#include "bio.h"
#include "sha.h"
#include <string.h>


//sha1签名
int rsa_sign_with_private_key_pem(char *message, int message_length
                                  , unsigned char *signature, unsigned int *signature_length
                                  , char *private_key_file_path)
{
    //    unsigned char sha1[20];
    //    SHA1((unsigned char *)message, message_length, sha1);
    
    int success = 0;
    BIO *bio_private = NULL;
    RSA *rsa_private = NULL;
    bio_private = BIO_new(BIO_s_file());
    BIO_read_filename(bio_private, private_key_file_path);
    rsa_private = PEM_read_bio_RSAPrivateKey(bio_private, NULL, NULL, "");
    if (rsa_private != nil) {
        if (1 == RSA_check_key(rsa_private))
        {
            //			int rsa_sign_valid = RSA_sign(NID_sha1
            //										  , sha1, 20
            //										  , signature, signature_length
            //										  , rsa_private);
            
            //先把message经过撕咬加密
            char *en = NULL;//加密后的
            int rsa_len = 0;
            
            en = (char *)malloc(256);
            memset(en, 0, 256);
            
            rsa_len = RSA_size(rsa_private);//128
            
            int offset = 0;
            int i = 0;
            
            
            char *allen = (char *)malloc(256);//用来叠加的最终加密data
            
            
            while (message_length-offset>0) {
                if (message_length-offset>rsa_len-11) {
                    //需要分割了
                    char *splitmessage = (char *)malloc(rsa_len-11);
                    strncpy(splitmessage, message+offset, rsa_len-11);
                    RSA_private_encrypt(rsa_len-11, (unsigned char *)splitmessage, (unsigned char *)en, rsa_private, RSA_PKCS1_PADDING);
                    strncat(allen, en,(int)strlen(en));
                }else{
                    char *splitmessage = (char *)malloc(message_length-offset);
                    strncpy(splitmessage, message+offset, message_length-offset);
                    RSA_private_encrypt(message_length-offset, (unsigned char *)splitmessage, (unsigned char *)en, rsa_private, RSA_PKCS1_PADDING);
                    strncat(allen, en,(int)strlen(en));
                }
                i++;
                offset = i*(rsa_len-11);
            }
            
            
            
            
            
            
            unsigned char md5[16];
            //            if (-1 != rsa_private_encrypt_valid) {
            
            MD5((unsigned char *)allen, (int)strlen(allen), md5);
            //            }
            
            
            
            
            
            
            int rsa_sign_valid = RSA_sign(NID_md5
                                          ,md5,16
                                          , signature, signature_length
                                          , rsa_private);
            if (1 == rsa_sign_valid)
            {
                success = 1;
            }
        }
        BIO_free_all(bio_private);
    }
    else {
        NSLog(@"rsa_private read error : private key is NULL");
    }
    
    return success;
}

int rsa_verify_with_public_key_pem(char *message, int message_length
                                   , unsigned char *signature, unsigned int signature_length
                                   , char *public_key_file_path)
{
    unsigned char sha1[20];
    SHA1((unsigned char *)message, message_length, sha1);
    BIO *bio_public = NULL;
    RSA *rsa_public = NULL;
    bio_public = BIO_new(BIO_s_file());
    BIO_read_filename(bio_public, public_key_file_path);
    rsa_public = PEM_read_bio_RSA_PUBKEY(bio_public, NULL, NULL, NULL);
    
    int rsa_verify_valid = RSA_verify(NID_sha1
                                      , sha1, 20
                                      , signature, signature_length
                                      , rsa_public);
    BIO_free_all(bio_public);
    if (1 == rsa_verify_valid)
    {
        return 1;
    }
    return 0;
}

NSString *base64StringFromData(NSData *signature)
{
    int signatureLength = (int)[signature length];
    unsigned char *outputBuffer = (unsigned char *)malloc(2 * 4 * (signatureLength / 3 + 1));
    int outputLength = EVP_EncodeBlock(outputBuffer, [signature bytes], signatureLength);
    outputBuffer[outputLength] = '\0';
    NSString *base64String = [NSString stringWithCString:(char *)outputBuffer encoding:NSASCIIStringEncoding];
    free(outputBuffer);
    return base64String;
}

NSData *dataFromBase64String(NSString *base64String)
{
    int stringLength = (int)[base64String length];
    const unsigned char *strBuffer = (const unsigned char *)[base64String UTF8String];
    unsigned char *outputBuffer = (unsigned char *)malloc(2 * 3 * (stringLength / 4 + 1));
    int outputLength = EVP_DecodeBlock(outputBuffer, strBuffer, stringLength);
    
    int zeroByteCounter = 0;
    for (int i = stringLength - 1; i >= 0; i--)
    {
        if (strBuffer[i] == '=')
        {
            zeroByteCounter++;
        }
        else
        {
            break;
        }
    }
    
    NSData *data = [[NSData alloc] initWithBytes:outputBuffer length:outputLength - zeroByteCounter];
    free(outputBuffer);
    return data;
}

NSString *rsaSignString(NSString *stringToSign, NSString *privateKeyFilePath, BOOL *signSuccess)
{
    const char *message = [stringToSign cStringUsingEncoding:NSUTF8StringEncoding];
    int messageLength = (int)strlen(message);
    unsigned char *sig = (unsigned char *)malloc(256);
    unsigned int sig_len;
    char *filePath = (char *)[privateKeyFilePath cStringUsingEncoding:NSUTF8StringEncoding];
    int sign_ok = rsa_sign_with_private_key_pem((char *)message, messageLength
                                                , sig, &sig_len
                                                , filePath);
    NSString *signedString = nil;
    if (1 == sign_ok)
    {
        *signSuccess = YES;
        signedString = base64StringFromData([NSData dataWithBytes:sig length:sig_len]);
    }
    else
    {
        *signSuccess = NO;
    }
    free(sig);
    return signedString;
}

void rsaVerifyString(NSString *stringToVerify, NSString *signature, NSString *publicKeyFilePath, BOOL *verifySuccess)
{
    const char *message = [stringToVerify cStringUsingEncoding:NSUTF8StringEncoding];
    int messageLength = (int)[stringToVerify lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSData *signatureData = dataFromBase64String(signature);
    unsigned char *sig = (unsigned char *)[signatureData bytes];
    unsigned int sig_len = (int)[signatureData length];
    char *filePath = (char *)[publicKeyFilePath cStringUsingEncoding:NSUTF8StringEncoding];
    int verify_ok = rsa_verify_with_public_key_pem((char *)message, messageLength
                                                   , sig, sig_len
                                                   , filePath);
    if (1 == verify_ok)
    {
        *verifySuccess = YES;
    }
    else
    {
        *verifySuccess = NO;
    }
}

NSString *formattedPEMString(NSString *originalString)
{    
    NSString *trimmedString = [originalString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    const char *c = [trimmedString UTF8String];
    int len = (int)[trimmedString length];
    NSMutableString *result = [NSMutableString string];
    [result appendString:@"-----BEGIN PRIVATE KEY-----\n"];
    int index = 0;
    while (index < len) {
        char cc = c[index];
        [result appendFormat:@"%c", cc];
        if ( (index+1) % 64 == 0)
        {
            [result appendString:@"\n"];
        }
        index++;
    }
    [result appendString:@"\n-----END PRIVATE KEY-----"];
    return result;
}

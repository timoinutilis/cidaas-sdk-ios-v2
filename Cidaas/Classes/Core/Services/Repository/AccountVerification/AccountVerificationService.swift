//
//  AccountVerificationService.swift
//  Cidaas
//
//  Created by ganesh on 27/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation
import Alamofire

public class AccountVerificationService {
    
    // shared instance
    public static var shared : AccountVerificationService = AccountVerificationService()
    let location = DBHelper.shared.getLocation()
    
    // constructor
    public init() {
        
    }
    
    // initiate account verification
    public func initiateAccountVerification(accountVerificationEntity : InitiateAccountVerificationEntity, properties : Dictionary<String, String>, callback: @escaping (Result<InitiateAccountVerificationResponseEntity>) -> Void) {
        
        // local variables
        var headers : HTTPHeaders
        var urlString : String
        var baseURL : String
        
        // get device information
        let deviceInfoEntity = DBHelper.shared.getDeviceInfo()
        
        // construct headers
        headers = [
            "User-Agent": CidaasUserAgentBuilder.shared.UAString(),
            "deviceId" : deviceInfoEntity.deviceId,
            "deviceMake" : deviceInfoEntity.deviceMake,
            "deviceModel" : deviceInfoEntity.deviceModel,
            "lat": location.0,
            "lon": location.1,
            "deviceVersion" : deviceInfoEntity.deviceVersion
        ]
        
        // construct body params
        var bodyParams = Dictionary<String, String>()
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(accountVerificationEntity)
            bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, String> ?? Dictionary<String, String>()
        }
        catch(_) {
            callback(Result.failure(error: WebAuthError.shared.conversionException()))
            return
        }
        
        // assign base url
        baseURL = (properties["DomainURL"]) ?? ""
        
        if (baseURL == "") {
            callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
            return
        }
        
        // construct url
        urlString = baseURL + URLHelper.shared.getInitiateAccountVerificationURL()
        
        Alamofire.request(urlString, method: .post, parameters: bodyParams, headers: headers).validate().responseString { response in
            switch response.result {
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.netWorkTimeoutException()))
                    return
                }
                if (response.data != nil) {
                    let jsonString = String(decoding: response.data!, as: UTF8.self)
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        let errorResponseEntity = try decoder.decode(ErrorResponseEntity.self, from: data)
                        
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.INITIATE_ACCOUNT_VERIFICATION_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error: errorResponseEntity)))
                    }
                    catch(let error) {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.INITIATE_ACCOUNT_VERIFICATION_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.INITIATE_ACCOUNT_VERIFICATION_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.INITIATE_ACCOUNT_VERIFICATION_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                }
                return
            case .success:
                if response.response?.statusCode == 200 {
                    if let jsonString = response.result.value {
                        let decoder = JSONDecoder()
                        do {
                            let data = jsonString.data(using: .utf8)!
                            let initiateAccountVerificationResponseEntity = try decoder.decode(InitiateAccountVerificationResponseEntity.self, from: data)
                            // return success
                            callback(Result.success(result: initiateAccountVerificationResponseEntity))
                        }
                        catch {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.ERROR_JSON_PARSING.rawValue, errorMessage: StringsHelper.shared.ERROR_JSON_PARSING, statusCode: HttpStatusCode.DEFAULT.rawValue)))
                            return
                        }
                    }
                    else {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.INITIATE_ACCOUNT_VERIFICATION_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.INITIATE_ACCOUNT_VERIFICATION_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.INITIATE_ACCOUNT_VERIFICATION_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.INITIATE_ACCOUNT_VERIFICATION_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                    break
                }
            }
        }
    }
    
    // verify account
    public func verifyAccount(accountVerificationEntity : VerifyAccountEntity, properties : Dictionary<String, String>, callback: @escaping (Result<VerifyAccountResponseEntity>) -> Void) {
        
        // local variables
        var headers : HTTPHeaders
        var urlString : String
        var baseURL : String
        
        // get device information
        let deviceInfoEntity = DBHelper.shared.getDeviceInfo()
        
        // construct headers
        headers = [
            "User-Agent": CidaasUserAgentBuilder.shared.UAString(),
            "lat": location.0,
            "lon": location.1,
            "deviceId" : deviceInfoEntity.deviceId,
            "deviceMake" : deviceInfoEntity.deviceMake,
            "deviceModel" : deviceInfoEntity.deviceModel,
            "deviceVersion" : deviceInfoEntity.deviceVersion
        ]
        
        // construct body params
        var bodyParams = Dictionary<String, String>()
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(accountVerificationEntity)
            bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, String> ?? Dictionary<String, String>()
        }
        catch(_) {
            callback(Result.failure(error: WebAuthError.shared.conversionException()))
            return
        }
        
        // assign base url
        baseURL = (properties["DomainURL"]) ?? ""
        
        if (baseURL == "") {
            callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
            return
        }
        
        // construct url
        urlString = baseURL + URLHelper.shared.getVerifyAccountURL()
        
        Alamofire.request(urlString, method: .post, parameters: bodyParams, headers: headers).validate().responseString { response in
            switch response.result {
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.netWorkTimeoutException()))
                    return
                }
                if (response.data != nil) {
                    let jsonString = String(decoding: response.data!, as: UTF8.self)
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        let errorResponseEntity = try decoder.decode(ErrorResponseEntity.self, from: data)
                        
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VERIFY_ACCOUNT_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error: errorResponseEntity)))
                    }
                    catch(let error) {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VERIFY_ACCOUNT_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VERIFY_ACCOUNT_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.VERIFY_ACCOUNT_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                }
                return
            case .success:
                if response.response?.statusCode == 200 {
                    if let jsonString = response.result.value {
                        let decoder = JSONDecoder()
                        do {
                            let data = jsonString.data(using: .utf8)!
                            let initiateAccountVerificationResponseEntity = try decoder.decode(VerifyAccountResponseEntity.self, from: data)
                            // return success
                            callback(Result.success(result: initiateAccountVerificationResponseEntity))
                        }
                        catch {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.ERROR_JSON_PARSING.rawValue, errorMessage: StringsHelper.shared.ERROR_JSON_PARSING, statusCode: HttpStatusCode.DEFAULT.rawValue)))
                            return
                        }
                    }
                    else {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VERIFY_ACCOUNT_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.VERIFY_ACCOUNT_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VERIFY_ACCOUNT_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.VERIFY_ACCOUNT_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                    break
                }
            }
        }
    }
    
    // get account verification list
    public func getAccountVerificationList(sub: String, properties : Dictionary<String, String>, callback: @escaping (Result<AccountVerificationListResponseEntity>) -> Void) {
        
        // local variables
        var headers : HTTPHeaders
        var urlString : String
        var baseURL : String
        
        // get device information
        let deviceInfoEntity = DBHelper.shared.getDeviceInfo()
        
        // construct headers
        headers = [
            "User-Agent": CidaasUserAgentBuilder.shared.UAString(),
            "lat": location.0,
            "lon": location.1,
            "deviceId" : deviceInfoEntity.deviceId,
            "deviceMake" : deviceInfoEntity.deviceMake,
            "deviceModel" : deviceInfoEntity.deviceModel,
            "deviceVersion" : deviceInfoEntity.deviceVersion
        ]
        
        // assign base url
        baseURL = (properties["DomainURL"]) ?? ""
        
        if (baseURL == "") {
            callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
            return
        }
        
        // construct url
        urlString = baseURL + URLHelper.shared.getVerifyAccountListURL(sub: sub)
        
        Alamofire.request(urlString, method: .get, headers: headers).validate().responseString { response in
            switch response.result {
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.netWorkTimeoutException()))
                    return
                }
                if (response.data != nil) {
                    let jsonString = String(decoding: response.data!, as: UTF8.self)
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        let errorResponseEntity = try decoder.decode(ErrorResponseEntity.self, from: data)
                        
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VERIFY_ACCOUNT_LIST_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error: errorResponseEntity)))
                    }
                    catch(let error) {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VERIFY_ACCOUNT_LIST_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VERIFY_ACCOUNT_LIST_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.VERIFY_ACCOUNT_LIST_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                }
                return
            case .success:
                if response.response?.statusCode == 200 {
                    if let jsonString = response.result.value {
                        let decoder = JSONDecoder()
                        do {
                            let data = jsonString.data(using: .utf8)!
                            let initiateAccountVerificationResponseEntity = try decoder.decode(AccountVerificationListResponseEntity.self, from: data)
                            // return success
                            callback(Result.success(result: initiateAccountVerificationResponseEntity))
                        }
                        catch {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.ERROR_JSON_PARSING.rawValue, errorMessage: StringsHelper.shared.ERROR_JSON_PARSING, statusCode: HttpStatusCode.DEFAULT.rawValue)))
                            return
                        }
                    }
                    else {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VERIFY_ACCOUNT_LIST_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.VERIFY_ACCOUNT_LIST_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VERIFY_ACCOUNT_LIST_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.VERIFY_ACCOUNT_LIST_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                    break
                }
            }
        }
    }
}

//
//  VerificationSettingsController.swift
//  Cidaas
//
//  Created by ganesh on 17/08/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class VerificationSettingsController {
    
    // shared instance
    public static var shared : VerificationSettingsController = VerificationSettingsController()
    
    // constructor
    public init() {
    }
    
    // configure email from properties
    public func getMFAList(sub: String, properties: Dictionary<String, String>, callback: @escaping(Result<MFAListResponseEntity>) -> Void) {
        // null check
        if properties["DomainURL"] == "" || properties["DomainURL"] == nil {
            let error = WebAuthError.shared.propertyMissingException()
            // log error
            let loggerMessage = "Read properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // validating fields
        if (sub == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.error = "sub must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // getting userDeviceId
        let userDeviceId = DBHelper.shared.getUserDeviceId(key: properties["DomainURL"] ?? "OAuthUserDeviceId")
        
        // call getMFAList service
        VerificationSettingsService.shared.getMFAList(sub: sub, userDeviceId: userDeviceId, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Get MFA List service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let serviceResponse):
                // log success
                let loggerMessage = "Get MFA List service success : " + "Count  - " + String(describing: serviceResponse.data.count)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // return callback
                DispatchQueue.main.async {
                    callback(Result.success(result: serviceResponse))
                }
            }
        }
    }
}
//
//  AccessTokenService.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation
import Alamofire

public class AccessTokenService {
    
    // shared instance
    public static var shared : AccessTokenService = AccessTokenService()
    let location = DBHelper.shared.getLocation()
    var sharedSession: SessionManager
    
    // constructor
    public init() {
        sharedSession = SessionManager.shared
    }
    
    // get access token by code
    public func getAccessToken(code : String, properties : Dictionary<String, String>, callback: @escaping (Result<AccessTokenEntity>) -> Void) {
        // local variables
        var urlString : String
        
        // construct body params
        var bodyParams = Dictionary<String, String>()
        bodyParams["grant_type"] = properties["GrantType"]
        bodyParams["code"] = code
        bodyParams["redirect_uri"] = properties["RedirectURL"]
        bodyParams["client_id"] = properties["ClientId"]
        bodyParams["code_verifier"] = properties["Verifier"]
        
        // assign token url
        urlString = (properties["TokenURL"]) ?? ""
        
        if urlString == "" {
            callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
            return
        }
        
        if (urlString == "") {
            callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
            return
        }
        
        sharedSession.startSession(url: urlString, method: .post, parameters: bodyParams) {  response, error in
            if error != nil {
                callback(Result.failure(error: error!))
                return
            }
            let decoder = JSONDecoder()
            do {
                let data = response!.data(using: .utf8)!
                let responseEntity = try decoder.decode(AccessTokenEntity.self, from: data)
                // return success
                callback(Result.success(result: responseEntity))
            }
            catch {
                // return failure
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.ERROR_JSON_PARSING.rawValue, errorMessage: StringsHelper.shared.ERROR_JSON_PARSING, statusCode: HttpStatusCode.DEFAULT.rawValue)))
                return
            }
        }
    }
    
    // get access token by refresh token
    public func getAccessToken(refreshToken : String, properties : Dictionary<String, String>, callback: @escaping (Result<AccessTokenEntity>) -> Void) {
        
        // local variables
        var urlString : String
        
        // construct body params
        var bodyParams = Dictionary<String, String>()
        bodyParams["grant_type"] = "refresh_token"
        bodyParams["refresh_token"] = refreshToken
        bodyParams["redirect_uri"] = properties["RedirectURL"]
        bodyParams["client_id"] = properties["ClientId"]
        bodyParams["client_secret"] = properties["ClientSecret"]
        
        // assign token url
        urlString = (properties["TokenURL"]) ?? ""
        
        sharedSession.startSession(url: urlString, method: .post, parameters: bodyParams) {  response, error in
            if error != nil {
                callback(Result.failure(error: error!))
                return
            }
            let decoder = JSONDecoder()
            do {
                let data = response!.data(using: .utf8)!
                let responseEntity = try decoder.decode(AccessTokenEntity.self, from: data)
                // return success
                callback(Result.success(result: responseEntity))
            }
            catch {
                // return failure
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.ERROR_JSON_PARSING.rawValue, errorMessage: StringsHelper.shared.ERROR_JSON_PARSING, statusCode: HttpStatusCode.DEFAULT.rawValue)))
                return
            }
        }
    }
    
    // get access token by social token
    public func getAccessToken(requestId: String, socialToken : String, provider: String, viewType: String, properties : Dictionary<String, String>, callback: @escaping (Result<SocialProviderEntity>) -> Void) {
        
        // local variables
        var urlString : String
        
        // assign base url
        let baseURL = (properties["DomainURL"]) ?? ""
        
        if (baseURL == "") {
            callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
            return
        }
        
        // assign token url
        urlString = baseURL + URLHelper.shared.getSocialURL(requestId: requestId, socialToken: socialToken, provider: provider, clientId: (properties["ClientId"]) ?? "", redirectURL: (properties["RedirectURL"]) ?? "", viewType: viewType)
        
        urlString = "\(urlString)&code_challenge=\(properties["Challenge"] ?? "")&code_challenge_method=\(properties["Method"] ?? "")"
        
        sharedSession.startSession(url: urlString, method: .get, parameters: nil) {  response, error in
            if error != nil {
                callback(Result.failure(error: error!))
                return
            }
            let decoder = JSONDecoder()
            do {
                let data = response!.data(using: .utf8)!
                let responseEntity = try decoder.decode(SocialProviderEntity.self, from: data)
                // return success
                callback(Result.success(result: responseEntity))
            }
            catch {
                // return failure
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.ERROR_JSON_PARSING.rawValue, errorMessage: StringsHelper.shared.ERROR_JSON_PARSING, statusCode: HttpStatusCode.DEFAULT.rawValue)))
                return
            }
        }
    }
}

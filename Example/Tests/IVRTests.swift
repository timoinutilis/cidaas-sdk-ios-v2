//
//  IVRTests.swift
//  Cidaas_Tests
//
//  Created by ganesh on 03/09/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Cidaas
import Mockingjay

class IVRTests: QuickSpec {
    override func spec() {
        describe("IVR Test cases") {
            
            let cidaas = Cidaas.shared
            
            context("IVR test") {
                
                it("call configure IVR from public") {
                    
                    cidaas.configureIVR(sub: "87267324") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.statusId)
                        }
                    }
                }
                
                it("call configure IVR failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    cidaas.configureIVR(sub: "87267324") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.statusId)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
                
                it("call enroll IVR from public") {
                    
                    IVRVerificationController.shared.sub = "asdasdasd"
                    
                    cidaas.enrollIVR(statusId: "766734563", code: "123456") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.trackingCode)
                        }
                    }
                }
                
                it("call enroll IVR failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    IVRVerificationController.shared.sub = "asdasdasd"
                    
                    cidaas.enrollIVR(statusId: "766734563", code: "123456") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.trackingCode)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
                
                it("call login with IVR from public") {
                    
                    let passwordlessEntity = PasswordlessEntity()
                    passwordlessEntity.email = "abc@gmail.com"
                    passwordlessEntity.mobile = "+919876543210"
                    passwordlessEntity.requestId = "382b6e72-3435-4724-8339-ea7907f253e9"
                    passwordlessEntity.sub = "87236482734"
                    passwordlessEntity.usageType = UsageTypes.MFA.rawValue
                    passwordlessEntity.trackId = "873472873482"
                    
                    cidaas.loginWithIVR(passwordlessEntity: passwordlessEntity) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.statusId)
                        }
                    }
                }
                
                it("call login with IVR failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    let passwordlessEntity = PasswordlessEntity()
                    passwordlessEntity.email = "abc@gmail.com"
                    passwordlessEntity.mobile = "+919876543210"
                    passwordlessEntity.requestId = "382b6e72-3435-4724-8339-ea7907f253e9"
                    passwordlessEntity.sub = "87236482734"
                    passwordlessEntity.usageType = UsageTypes.MFA.rawValue
                    passwordlessEntity.trackId = "873472873482"
                    
                    cidaas.loginWithIVR(passwordlessEntity: passwordlessEntity) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.statusId)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
                
                it("call verify IVR from public") {
                    
                    IVRVerificationController.shared.sub = "asdasdasd"
                    
                    cidaas.verifyIVR(statusId: "766734563", code: "123456") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.access_token)
                        }
                    }
                }
                
                it("call verify IVR failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    IVRVerificationController.shared.sub = "asdasdasd"
                    
                    cidaas.verifyIVR(statusId: "766734563", code: "123456") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.access_token)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
                
                
                it("call configure IVR controller") {
                    
                    let controller = IVRVerificationController.shared
                    
                    var entity = SetupIVRResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(SetupIVRResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(entity)
                        bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    self.stub(everything, json(bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    controller.configureIVR(sub: "kajshjasd", properties: properties!) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                            expect.fulfill()
                            break
                        case .success(let response):
                            print(response.success)
                            expect.fulfill()
                            break
                        }
                    }
                    
                    self.waitForExpectations(timeout: 120, handler: { (error) in
                        if error != nil{
                            print("Unexpected failure with getting the data ",error!)
                        }
                    })
                }
                
                it("call configure IVR failure controller") {
                    
                    let controller = IVRVerificationController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    var entity = LoginResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"123234232\",\"token_type\":\"BEARER\", \"expires_in\":86400,\"id_token_expires_in\":86400,\"access_token\":\"jdgfuygfdywe\",\"id_token\":\"jhgfjwguwgeyrwgeyrfwer\",\"refresh_token\":\"7tguegf\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(LoginResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(entity)
                        bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let acc_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: acc_urlString), json(bodyParams))
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let update_user_urlString = baseURL + URLHelper.shared.getSetupIVRURL()
                    
                    self.stub(http(.post, uri: update_user_urlString), failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.configureIVR(sub: "kajshjasd", properties: properties!) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                            expect.fulfill()
                            break
                        case .success(let response):
                            print(response.success)
                            expect.fulfill()
                            break
                        }
                    }
                    
                    self.waitForExpectations(timeout: 120, handler: { (error) in
                        if error != nil{
                            print("Unexpected failure with getting the data ",error!)
                        }
                    })
                }
                
                it("call configure IVR with domain url nil failure controller") {
                    
                    let controller = IVRVerificationController.shared
                    
                    var entity = SetupIVRResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"reset_initiated\":true,\"rprq\":\"jhgsdfj\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(SetupIVRResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(entity)
                        bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    self.stub(everything, json(bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    var properties = DBHelper.shared.getPropertyFile()
                    
                    properties!["DomainURL"] = ""
                    
                    controller.configureIVR(sub: "kajshjasd", properties: properties!) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                            expect.fulfill()
                            break
                        case .success(let response):
                            print(response.success)
                            expect.fulfill()
                            break
                        }
                    }
                    
                    self.waitForExpectations(timeout: 120, handler: { (error) in
                        if error != nil{
                            print("Unexpected failure with getting the data ",error!)
                        }
                    })
                }
                
                it("call configrue IVR with sub nil failure controller") {
                    
                    let controller = IVRVerificationController.shared
                    
                    var entity = SetupIVRResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"reset_initiated\":true,\"rprq\":\"jhgsdfj\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(SetupIVRResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(entity)
                        bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    self.stub(everything, json(bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    controller.configureIVR(sub: "", properties: properties!) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                            expect.fulfill()
                            break
                        case .success(let response):
                            print(response.success)
                            expect.fulfill()
                            break
                        }
                    }
                    
                    self.waitForExpectations(timeout: 120, handler: { (error) in
                        if error != nil{
                            print("Unexpected failure with getting the data ",error!)
                        }
                    })
                }
            }
        }
    }
}
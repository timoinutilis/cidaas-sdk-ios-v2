//
//  SetupTOTPResponseEntity.swift
//  sdkiOS
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class SetupTOTPResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 0
    public var data: SetupTOTPResponseDataEntity = SetupTOTPResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 0
        self.data = try container.decodeIfPresent(SetupTOTPResponseDataEntity.self, forKey: .data) ?? SetupTOTPResponseDataEntity()
    }
}

public class SetupTOTPResponseDataEntity : Codable {
    // properties
    public var secret: String = ""
    public var t: String = ""
    public var d: String = ""
    public var issuer: String = ""
    public var l: String = ""
    public var sub: String = ""
    public var rns: String = ""
    public var cid: String = ""
    public var rurl: String = ""
    public var st: String = ""
    public var udi: String = ""
    public var current_status: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.secret = try container.decodeIfPresent(String.self, forKey: .secret) ?? ""
        self.t = try container.decodeIfPresent(String.self, forKey: .t) ?? ""
        self.d = try container.decodeIfPresent(String.self, forKey: .d) ?? ""
        self.issuer = try container.decodeIfPresent(String.self, forKey: .issuer) ?? ""
        self.l = try container.decodeIfPresent(String.self, forKey: .l) ?? ""
        self.sub = try container.decodeIfPresent(String.self, forKey: .sub) ?? ""
        self.rns = try container.decodeIfPresent(String.self, forKey: .rns) ?? ""
        self.cid = try container.decodeIfPresent(String.self, forKey: .cid) ?? ""
        self.rurl = try container.decodeIfPresent(String.self, forKey: .rurl) ?? ""
        self.st = try container.decodeIfPresent(String.self, forKey: .st) ?? ""
        self.udi = try container.decodeIfPresent(String.self, forKey: .udi) ?? ""
        self.current_status = try container.decodeIfPresent(String.self, forKey: .current_status) ?? ""
    }
}

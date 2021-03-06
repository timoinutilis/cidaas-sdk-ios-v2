//
//  LoginResponse.swift
//  Cidaas
//
//  Created by ganesh on 01/07/19.
//

import Foundation

public class LoginResponse : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: AccessTokenEntity = AccessTokenEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent(AccessTokenEntity.self, forKey: .data) ?? AccessTokenEntity()
    }
}

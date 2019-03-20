//
//  MessageCode.swift
//  BridgingSwiftDemo
//
//  Created by 赵睿 on 3/7/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

import Foundation

@objc class SwfitDemoClass : NSObject {
    
}

@objc public enum MessageCode: Int {
    case LoginReq = 1001
    case LoginRsp
    case LogoutReq
    case LogoutRsp
    var name : String {
        switch self {
            case .LoginReq: return "LoginReq"
            case .LoginRsp: return "Loginrsp"
            case .LogoutReq: return "LogoutReq"
            case .LogoutRsp: return "LogoutRsp"
        }
    }
}

@objc public enum LogSeverity: Int, RawRepresentable {
    case Debug
    case Info
    case Warn
    case Error
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .Debug:
            return "DEBUG"
        case .Info:
            return "INFO"
        case .Warn:
            return "WARN"
        case .Error:
            return "ERROR"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "DEBUG":
            self = .Debug
        case "INFO":
            self = .Info
        case "WARN":
            self = .Warn
        case "ERROR":
            self = .Error
        default:
            self = .Debug
        }
    }
}

@objc public enum ConnectivityStatus: Int {
    case Wifi
    case Mobile
    case Ethernet
    case Off
    
    public func name() -> String {
        switch self {
        case .Wifi: return "wifi"
        case .Mobile: return "mobile"
        case .Ethernet: return "ethernet"
        case .Off: return "off"
        }
    }
}


@objc enum InventoryItemType: Int {
    private enum StringInventoryItemType: String {
        case vial
        case syringe
        case crystalloid
        case bloodProduct
        case supplies
    }
    
    case vial
    case syringe
    case crystalloid
    case bloodProduct
    case supplies
    case unknown
    
    static func fromString(_ string: String?) -> InventoryItemType {
        guard let string = string else {
            return .unknown
        }
        guard let stringType = StringInventoryItemType(rawValue: string) else {
            return .unknown
        }
        switch stringType {
        case .vial:
            return .vial
        case .syringe:
            return .syringe
        case .crystalloid:
            return .crystalloid
        case .bloodProduct:
            return .bloodProduct
        case .supplies:
            return .supplies
        }
}

    var stringValue: String? {
        switch self {
        case .vial:
            return StringInventoryItemType.vial.rawValue
        case .syringe:
            return StringInventoryItemType.syringe.rawValue
        case .crystalloid:
            return StringInventoryItemType.crystalloid.rawValue
        case .bloodProduct:
            return StringInventoryItemType.bloodProduct.rawValue
        case .supplies:
            return StringInventoryItemType.supplies.rawValue
        case .unknown:
            return nil
        }
    }
}

//
//  ServerCommunication.swift
//  Voink
//
//  Created by Jae Kyeong Ko on 2022/06/12.
//
import Foundation

@objc protocol ServerCommunication {
    @objc optional func getHandshake()
    @objc optional func postFacebookLoginToken()
    @objc optional func getLoginToken()
    @objc optional func postRecord()
    @objc optional func fetchRecord()
}

//
//  ServerCommunication.swift
//  Voink
//
//  Created by Jae Kyeong Ko on 2022/06/12.
//
import Foundation

@objc protocol ServerCommunication {
    @objc optional func getHandshake()
    @objc optional func postLoginToken()
    @objc optional func fetchLoginToken()
    @objc optional func postRecord()
    @objc optional func fetchRecord()
}

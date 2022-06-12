//
//  LoginViewModel.swift
//  Voink
//
//  Created by Jae Kyeong Ko on 2022/06/09.
//

import FirebaseFunctions

class LoginViewModel {
    private lazy var functions = Functions.functions()
    
    func fetchServerDomain() async throws -> String {
        let data = try await functions.httpsCallable("serverInfo").call().data as? [String: Any]
        let serverDomain = data?["server_url"] as? String
        return serverDomain ?? ""
    }
}

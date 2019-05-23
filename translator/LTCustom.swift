//
//  LTCustom.swift
//  translator
//
//  Created by TONY on 22/05/2019.
//  Copyright © 2019 TONY. All rights reserved.
//

import Foundation

class LTCustom {
    private let authorization = "Basic " + String("6987a48d-342e-4a69-8adc-e65b1cc0b9da:MxYSIi6nQP2Y").data(using: .utf8)!.base64EncodedString()
    private let serviceURL = "https://gateway.watsonplatform.net/language-translator/api/v3/"
    private let version = "?version=2019-05-21"
    
    private func getURLRequest(function: String) -> URLRequest {
        let urlStr = serviceURL + function + version
        let url = URL(string: urlStr)!
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue(authorization, forHTTPHeaderField: "Authorization")
        
        return urlRequest
    }
    
    func listIdentifiableLanguages(completion: @escaping(Result<[Language], LTError>) -> Void) {
        var urlRequest = getURLRequest(function: "identifiable_languages")
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response,_ in
            guard response != nil else {
                completion(.failure(LTError(error: "No response")))
                return
            }
            
            guard let json = try? JSONDecoder().decode(LanguageList.self, from: data!) else {
                let error = try! JSONDecoder().decode(LTError.self, from: data!)
                completion(.failure(error))
                return
            }
            completion(.success(json.languages))
        }
        dataTask.resume()
    }
    
    func identify(text: String, completion: @escaping(Result<String, LTError>) -> Void) {
        var urlRequest = getURLRequest(function: "identify")
        
        urlRequest.httpMethod = "POST"
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        
        guard let body = text.data(using: .utf8) else {return}
        urlRequest.httpBody = body
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response,_ in
            guard response != nil else {
                completion(.failure(LTError(error: "No response")))
                return
            }
            
            guard let json = try? JSONDecoder().decode(LanguageList.self, from: data!) else {
                let error = try! JSONDecoder().decode(LTError.self, from: data!)
                completion(.failure(error))
                return
            }
            completion(.success(json.languages.first!.language))
        }
        dataTask.resume()
    }
    
    func translate(text: String, source: String, target: String, completion: @escaping(Result<String, LTError>) -> Void) {
        var urlRequest = getURLRequest(function: "translate")

        urlRequest.httpMethod = "POST"
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let translateRequest = TranslateRequest(text: text, source: source, target: target)
        guard let body = try? JSONEncoder().encode(translateRequest) else {return}
        urlRequest.httpBody = body
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response,_ in
            guard response != nil else {
                completion(.failure(LTError(error: "No response")))
                return
            }
            
            guard let json = try? JSONDecoder().decode(TranslateResponse.self, from: data!) else {
                let error = try! JSONDecoder().decode(LTError.self, from: data!)
                completion(.failure(error))
                return
            }
            completion(.success(json.translations.first!.translation))
        }
        dataTask.resume()
    }
}

struct LanguageList: Decodable {
    var languages: [Language]
}

struct Language: Decodable {
    var language: String
    var name: String?
}

struct TranslateRequest: Encodable {
    var text: String
    var source: String
    var target: String
}

struct TranslateResponse: Decodable {
    var translations: [Translation]
}

struct Translation: Decodable {
    var translation: String
}

struct LTError: Decodable, Error {
    var error: String
}

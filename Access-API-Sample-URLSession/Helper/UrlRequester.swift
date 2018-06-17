//
//  UrlRequester.swift
//  Access-API-Sample-URLSession
//
//  Created by kawaharadai on 2018/06/17.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import Foundation

final class UrlRequester {
    
    /// ベースURL（エンドポイント）
    static let baseURLString = "https://api.flickr.com/services/rest"
        
    /// URLRequest型で変数を返す（３つのプロパティをenumのタイプによってセットした状態で）
    static func create(method: String, endPoint: String, parameters: [String: String]) -> URLRequest {
        // ヘッダーにパラメータ埋め込み
        if var urlComponents = URLComponents(string: UrlRequester.baseURLString),
            urlComponents.url != nil {
            // ここで空を代入しないとqueryItemsに値が入らない
            urlComponents.queryItems = []
            
            if !parameters.isEmpty {
                parameters.forEach { (key, value) in
                    let query = URLQueryItem(name: key, value: value)
                    urlComponents.queryItems?.append(query)
                }
            }
            
            var urlRequest = URLRequest(url: urlComponents.url!)
            urlRequest.httpMethod = method
            return urlRequest
        } else {
            fatalError("urlがnilです。")
        }
    }
}

//
//  ApiClient.swift
//  Access-API-Sample-URLSession
//
//  Created by kawaharadai on 2018/06/17.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import Foundation

/// API通信の結果ステータスコード
enum ApiStatusCode: Int {
    case success = 200
}

final class ApiClient {
    
    static func request(searchWord: String,
                        completionHandler: @escaping (Result<Data, Error>) -> Void = { _ in }) {
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        // パラメータなどのリクエストを作成
        let urlRequest = UrlRequester.create(method: "GET",
                                             endPoint: "",
                                             parameters: SearchParamsBuilder.create(searchWord: searchWord, page: 1))
        let task = session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
                switch response.statusCode {
                case ApiStatusCode.success.rawValue:
                    print("成功")
                    guard let data = data else {
                        fatalError("成功時にデータ取得に失敗")
                    }
                    completionHandler(.success(data))
                default:
                    print("失敗")
                    if let error = error {
                        completionHandler(.failure(error))
                    }
                }
            } else if let error = error {
                completionHandler(.failure(error))
            } else {
                fatalError("通信中に問題が発生しました。")
            }
            session.finishTasksAndInvalidate()
        }
        task.resume()
    }
}

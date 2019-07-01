//
//  UrlRequester.swift
//  Access-API-Sample-URLSession
//
//  Created by kawaharadai on 2018/06/17.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import UIKit
import Foundation

final class UrlRequester {
    
    /// ベースURL（エンドポイント）
    static let baseURLString = "https://api.flickr.com/services/rest"

    /// URLRequest型で変数を返す（３つのプロパティをenumのタイプによってセットした状態で）
    static func create(method: String, path: String, parameters: [String: String]) -> URLRequest {

        guard let url = UrlRequester.baseURLString.formalUrl,
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            fatalError("baseURL is invalid")
        }

        // ここで空を代入しないとqueryItemsに値が入らない
        urlComponents.queryItems = []

        // ヘッダーにパラメータ埋め込み
        parameters.forEach { (key, value) in
            let query = URLQueryItem(name: key, value: value)
            urlComponents.queryItems?.append(query)
        }

        var urlRequest = URLRequest(url: urlComponents.url ?? url)
        urlRequest.httpMethod = method

        return urlRequest
    }

}

private extension String {

    // URLとしての形式、有効性に問題があった場合はnilを返す
    var formalUrl: URL? {
        guard let url = URL(string: self) else { return nil }
        return UIApplication.shared.canOpenURL(url) ? url : nil
    }

}

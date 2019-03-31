//
//  PhotoSearchApi.swift
//  Access-API-Sample-URLSession
//
//  Created by kawaharadai on 2018/06/17.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import Foundation

/// API通信の結果
enum PhotoSearchAPIStatus {
    case successLoad(PhotoSearchResponse)
    case offline
    case emptyData
    case error(Error)
}

/// レスポンスのバリデーションチェックステータス
enum ValidationCheckStatus {
    case isEmpty
    case isOver
    case isIrregular
}

/// エラーコード種別
enum ErrorCode: Int {
    case offline = -1009
}

/// API通信の結果通知プロトコル
protocol PhotoSearchAPIDelegate: class {
    func searchResult(result: PhotoSearchAPIStatus)
}

/**
 APIと通信しAPIステータスをコントローラーへ返す
 */
final class PhotoSearchApi {
    
    weak var photoSearchAPIDelegate: PhotoSearchAPIDelegate?
    
    func requestAPI(seachWord: String) {
        
        // APIを叩く
        ApiClient.request(searchWord: seachWord) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let jsonData):
                do {
                    // Codableにてjsonをマッピング
                    let photoSearchResponse = try JSONDecoder().decode(PhotoSearchResponse.self, from: jsonData)

                    guard self.validationCheck(response: photoSearchResponse) else { return }

                    self.photoSearchAPIDelegate?.searchResult(result: .successLoad(photoSearchResponse))
                } catch let error {
                    self.photoSearchAPIDelegate?.searchResult(result: .error(error))
                }
            case .failure(let error):
                switch error.nsError.code {
                case ErrorCode.offline.rawValue:
                    self.photoSearchAPIDelegate?.searchResult(result: .offline)
                default:
                    self.photoSearchAPIDelegate?.searchResult(result: .error(error))
                }
                self.photoSearchAPIDelegate?.searchResult(result: .error(error))
            }
        }
    }
    
    /// 各種バリデーションチェック（必要に応じて追加）
    private func validationCheck(response: PhotoSearchResponse) -> Bool {
        if response.photos.photo.isEmpty {
            /// 取得件数が0の時
            self.photoSearchAPIDelegate?.searchResult(result: .emptyData)
            return false
        }
        return true
    }
    
}

// Error側をNSErrorも使えるように拡張
extension Error {
    fileprivate var nsError: NSError {
        return (self as NSError)
    }
}

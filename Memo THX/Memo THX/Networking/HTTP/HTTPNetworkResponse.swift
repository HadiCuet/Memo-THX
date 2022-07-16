//
//  HTTPNetworkResponse.swift
//  Memo THX
//

import Foundation

struct HTTPNetworkResponse {

    static func handleNetworkResponse(for response: HTTPURLResponse?) -> Result<String> {

        guard let res = response else {
            Log.info("[Error] response unwrapping error")
            return Result.failure(HTTPNetworkError.UnwrappingError)
        }

        Log.info("Network response status code - \(res.statusCode)")
        switch res.statusCode {
        case 200...299: return Result.success(HTTPNetworkError.success.rawValue)
        case 401:       return Result.failure(HTTPNetworkError.authenticationError)
        case 400...499: return Result.failure(HTTPNetworkError.badRequest)
        case 500...599: return Result.failure(HTTPNetworkError.serverSideError)
        default:        return Result.failure(HTTPNetworkError.failed)
        }
    }
}

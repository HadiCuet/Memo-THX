//
//  ClientServiceHelper.swift
//  Memo THX
//

import Foundation

struct ClientServiceHelper {

    func getListPhotosParameters(pageNumber: Int) -> [String: String] {
        var paramDict: [String: String] = [:]
        paramDict[kClientIdParam] = clientIdParamKeyValue
        paramDict[kPageNumberParam] = "\(pageNumber)"
        paramDict[kPerPageParam] = "\(perPagePhotoCount)"
        return paramDict
    }
}

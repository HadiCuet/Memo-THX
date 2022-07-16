//
//  ClientService.swift
//  Memo THX
//

import Foundation

protocol ClientServiceProtocol {
    func getListPhotos(pageNumber: Int, _ completion: @escaping (Result<[ImageInfo]>) -> ())
}

struct ClientService: ClientServiceProtocol {

    let session = URLSession(configuration: .default)
    let serviceHelper = ClientServiceHelper()

    func getListPhotos(pageNumber: Int, _ completion: @escaping (Result<[ImageInfo]>) -> ()) {

        let parameters = serviceHelper.getListPhotosParameters(pageNumber: pageNumber)
        do {
            let request = try HTTPNetworkRequest.configureHTTPRequest(from: .getListPhotos, with: parameters, includes: nil, contains: nil, and: .get)

            session.dataTask(with: request) { (data, res, err) in

                guard err == nil else {
                    completion(.failure(HTTPNetworkError.dataTaskFailed))
                    return
                }

                guard let response = res as? HTTPURLResponse, let unwrappedData = data else {
                    completion(Result.failure(HTTPNetworkError.noData))
                    return
                }

                let result = HTTPNetworkResponse.handleNetworkResponse(for: response)
                switch result {

                case .success:
                    guard let result = try? JSONDecoder().decode([ImageInfo].self, from: unwrappedData) else {
                        Log.info("[Error] Image info json decoding failed")
                        completion(.failure(HTTPNetworkError.decodingFailed))
                        return
                    }
                    Log.info("[Success] Photo list response count - \(result.count)")
                    completion(.success(result))

                case .failure (let cause):
                    Log.info("[Error] Network response failed - \(cause.localizedDescription)")
                    completion(.failure(cause))
                }
            }.resume()
        }
        catch (let ex) {
            Log.info("[Exception] Get photo list exception - \(ex.localizedDescription)")
            completion(.failure(HTTPNetworkError.badRequest))
        }
    }
}

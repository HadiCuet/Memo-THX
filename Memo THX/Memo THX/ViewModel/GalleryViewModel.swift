//
//  GalleryViewModel.swift
//  Memo THX
//
//  Created by Abdullah Al Hadi on 16/7/22.
//

import Foundation

protocol GalleryViewModelProtocol {
    var imageInfoList: Bindable<[ImageInfo]> { get }
    func fetchPhotoList()
}

class GalleryViewModel: NSObject, GalleryViewModelProtocol {
    var imageInfoList: Bindable<[ImageInfo]> = Bindable([])
    private var clientService: ClientService
    private var curPageNumber: Int
    public var isPaginating: Bool

    override init() {
        self.clientService = ClientService()
        self.curPageNumber = 0
        self.isPaginating = false
        super.init()
    }

    func fetchPhotoList() {
        self.isPaginating = true
        self.curPageNumber += 1
        Log.info("Fetch more data for page number - \(self.curPageNumber)")
        self.clientService.getListPhotos(pageNumber: curPageNumber) { [weak self] result in
            guard let `self` = self else {
                return
            }
            self.isPaginating = false
            switch result {
            case .success(let list):
                self.imageInfoList.value.append(contentsOf: list)
            case .failure(let error):
                Log.info(error.localizedDescription)
            }
        }
    }
}


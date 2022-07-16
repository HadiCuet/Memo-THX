//
//  Constants.swift
//  Memo THX
//

import Foundation
import UIKit

//MARK: URL
let baseURL: String = getBaseUrl()

//MARK: Key
let kClientIdParam = "client_id"
let kPageNumberParam = "page"
let kPerPageParam = "per_page"
let kPhotoPreviewViewController = "PhotoPreviewViewController"

//TODO: Storing client id in codebase is a security violation. Need to move it somewhere
let clientIdParamKeyValue = "cMmA1eqZpAhgh_WUzoN1-2GC7mSO50zESMfFN43Voos"

//MARK: String
let galleryViewCellName = "GalleryViewCell"
let galleryViewNavigationTitle = "Photo Gallery"
let defaultThumbnailImage = "Default_Image_Thumbnail"
let saveSystemImageName = "square.and.arrow.down.on.square"

//MARK: Number
let perPagePhotoCount = 30
let footerViewHeight: CGFloat = 100
let collectionViewEdgeInset: CGFloat = 10
let timeOutInterval: TimeInterval = 20.0

//MARK: Others
let imageCache = NSCache<AnyObject, UIImage>()

func getBaseUrl() -> String {
//    var baseUrlString = Bundle.main.infoDictionary?["BaseUrl"] as? String
//    baseUrlString = baseUrlString?.replacingOccurrences(of: "\\", with: "")
//    return baseUrlString ?? ""

    return "https://api.unsplash.com/"
}

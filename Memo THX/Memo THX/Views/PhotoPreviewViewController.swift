//
//  PhotoPreviewViewController.swift
//  Memo THX
//

import UIKit

class PhotoPreviewViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var previewImageView: UIImageView!

    var previewImageUrl: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        Log.info("PhotoPreviewViewController [+]")

        let image = UIImage(systemName: saveSystemImageName) ?? UIImage()
        let saveBarButtonItem = UIBarButtonItem(image: image,
                                                style: .plain,
                                                target: self,
                                                action: #selector(saveBtnPressed(sender:)))
        let shareBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                 target: self,
                                                 action: #selector(shareBtnPressed(sender:)))
        self.navigationItem.rightBarButtonItems = [shareBarButtonItem, saveBarButtonItem]

        self.scrollView.delegate = self
        if let imageUrl = previewImageUrl {
            self.previewImageView.loadImage(fromUrl: imageUrl)
        }
    }

    @objc func shareBtnPressed(sender: AnyObject) {
        Log.info("Share button pressed")
        if let image = self.previewImageView.image {
            let activityViewController = UIActivityViewController(activityItems: [image] , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
    }

    @objc func saveBtnPressed(sender: AnyObject) {
        Log.info("Save button pressed")
        if let image = self.previewImageView.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return previewImageView
    }
}

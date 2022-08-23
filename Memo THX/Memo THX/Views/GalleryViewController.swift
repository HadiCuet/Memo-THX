//
//  ViewController.swift
//  Memo THX
//

import UIKit

class GalleryViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var galleryCollectionView: UICollectionView!

    private var viewModel = GalleryViewModel()
    private var imageList = [ImageInfo]()
    private let footerIndicator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        Log.info("GalleryViewController - viewDidLoad [+]")
        self.title = galleryViewNavigationTitle

        self.bindViewModelData()
        self.galleryCollectionView.dataSource = self
        self.galleryCollectionView.delegate = self

        self.galleryCollectionView.contentInset = UIEdgeInsets(top: collectionViewEdgeInset,
                                                               left: collectionViewEdgeInset,
                                                               bottom: collectionViewEdgeInset,
                                                               right: collectionViewEdgeInset)

        self.galleryCollectionView.register(UINib(nibName: galleryViewCellName, bundle: nil),
                                            forCellWithReuseIdentifier: galleryViewCellName)
        self.galleryCollectionView.register(ActivityIndicatorFooterView.self,
                                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                            withReuseIdentifier: ActivityIndicatorFooterView.identifier)
        Log.info("GalleryViewController - )
    }

    func bindViewModelData() {
        viewModel.fetchPhotoList()
        viewModel.imageInfoList.bindAndFire { [weak self] imageInfoList in
            DispatchQueue.main.async {
                self?.footerIndicator.stopAnimating()
                self?.imageList = imageInfoList
                self?.galleryCollectionView.reloadData()
            }
        }
    }
}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellObject = collectionView.dequeueReusableCell(withReuseIdentifier: galleryViewCellName, for: indexPath)
        guard let cell = cellObject as? GalleryViewCell else {
            return UICollectionViewCell()
        }
        cell.galleryImageView.image = UIImage(named: defaultThumbnailImage)
        if let imageUrl = self.imageList[indexPath.row].urls.regularUrl {
            cell.galleryImageView.loadImage(fromUrl: imageUrl)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: kPhotoPreviewViewController) as? PhotoPreviewViewController {
            viewController.previewImageUrl = self.imageList[indexPath.row].urls.regularUrl
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 3
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            let totalSpace = flowLayout.sectionInset.left
                                + flowLayout.sectionInset.right
                                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
                                + (2 * collectionViewEdgeInset)
            let size = (collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow)
            return CGSize(width: size, height: size)
        }
        return CGSize(width: footerViewHeight, height: footerViewHeight)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: ActivityIndicatorFooterView.identifier,
                                                                         for: indexPath)
            footer.addSubview(footerIndicator)
            self.footerIndicator.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: footerViewHeight)
            return footer
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: footerViewHeight)
    }
}

extension GalleryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        if yPosition > (galleryCollectionView.contentSize.height - scrollView.frame.size.height - footerViewHeight) {
            if !viewModel.isPaginating {
                self.footerIndicator.startAnimating()
                viewModel.fetchPhotoList()
            }
        }
    }
}


import UIKit
import iOSIntPackage

class PhotosViewController: UIViewController {
    
    // MARK: - Properties
    private var allImages: [UIImage] = []
    private var processedImages: [UIImage] = []
    private let imageProcessor = ImageProcessor()
    
    // MARK: - UI Elements
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        
        collectionView.register(
            PhotosCollectionViewCell.self,
            forCellWithReuseIdentifier: "PhotosCell"
        )
        
        return collectionView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Photos"
        
        setupCollectionView()
        setupConstraints()
        loadImages()
    }
    
    // MARK: - Setup
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            
            collectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            
            collectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            
            collectionView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            )
        ])
        
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            
            activityIndicator.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            )
        ])
    }
    
    // MARK: - Load Images
    private func loadImages() {
        activityIndicator.startAnimating()
        
        for i in 1...20 {
            if let image = UIImage(named: "\(i)") {
                allImages.append(image)
            }
        }
        
        // fallback images
        if allImages.isEmpty {
            for i in 1...4 {
                if let image = UIImage(named: "cat\(i)") {
                    allImages.append(image)
                }
            }
        }
        
        print("📸 Загружено изображений: \(allImages.count)")
        
        processImagesWithQoS()
    }
    
    // MARK: - Multithreading
    private func processImagesWithQoS() {
        
        measureProcessingTime(
            qos: .userInteractive,
            filter: .chrome
        ) {
            
            self.measureProcessingTime(
                qos: .userInitiated,
                filter: .fade
            ) {
                
                self.measureProcessingTime(
                    qos: .default,
                    filter: .noir
                ) {
                    
                    self.measureProcessingTime(
                        qos: .background,
                        filter: .process
                    ) {
                        print("✅ Все тесты завершены")
                    }
                }
            }
        }
    }
    
    private func measureProcessingTime(
        qos: QualityOfService,
        filter: ColorFilter,
        completion: (() -> Void)? = nil
    ) {
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        imageProcessor.processImagesOnThread(
            sourceImages: allImages,
            filter: filter,
            qos: qos
        ) { cgImages in
            
            let endTime = CFAbsoluteTimeGetCurrent()
            let timeMs = (endTime - startTime) * 1000
            
            var uiImages: [UIImage] = []
            
            for cgImage in cgImages {
                if let cgImage = cgImage {
                    uiImages.append(UIImage(cgImage: cgImage))
                }
            }
            
            print(
                """
                ⏱️ QoS: \(self.qosString(qos)),
                Фильтр: \(filter),
                Время: \(String(format: "%.2f", timeMs)) мс,
                Изображений: \(uiImages.count)
                """
            )
            
            if qos == .background {
                DispatchQueue.main.async {
                    self.processedImages = uiImages
                    
                    self.activityIndicator.stopAnimating()
                    self.collectionView.reloadData()
                    
                    print("✅ Обработка завершена")
                }
            }
            
            completion?()
        }
    }
    
    private func qosString(_ qos: QualityOfService) -> String {
        switch qos {
        case .userInteractive:
            return "userInteractive"
            
        case .userInitiated:
            return "userInitiated"
            
        case .default:
            return "default"
            
        case .utility:
            return "utility"
            
        case .background:
            return "background"
            
        @unknown default:
            return "unknown"
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PhotosViewController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        
        return processedImages.isEmpty
        ? allImages.count
        : processedImages.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "PhotosCell",
            for: indexPath
        ) as? PhotosCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let image = processedImages.isEmpty
        ? allImages[indexPath.item]
        : processedImages[indexPath.item]
        
        cell.imageView.image = image
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let spacing: CGFloat = 8
        
        let width = (
            collectionView.bounds.width - spacing * 4
        ) / 3
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        
        return 8
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        
        return 8
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        
        return UIEdgeInsets(
            top: 8,
            left: 8,
            bottom: 8,
            right: 8
        )
    }
}

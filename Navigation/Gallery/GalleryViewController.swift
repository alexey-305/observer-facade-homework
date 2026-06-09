import UIKit
import PhotosUI

class GalleryViewController: UIViewController {

    private var images: [URL] = []
    private let fileManager = FileManager.default
    private let defaults = UserDefaults.standard

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .systemBackground
        collection.delegate = self
        collection.dataSource = self
        collection.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        return collection
    }()

    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Нет фотографий\nНажмите + чтобы добавить"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadImagesFromDocuments()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(sortingChanged),
            name: NSNotification.Name("SortingChanged"),
            object: nil
        )
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateCollectionViewLayout()
    }

    private func setupUI() {
        title = "Файлы"
        view.backgroundColor = .systemBackground

        view.addSubview(collectionView)
        view.addSubview(emptyStateLabel)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addPhotoTapped)
        )
    }

    private func updateCollectionViewLayout() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let itemWidth = (view.bounds.width - 32) / 3
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
    }

    private func getDocumentsDirectory() -> URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    private func loadImagesFromDocuments() {
        let documentsURL = getDocumentsDirectory()

        do {
            let contents = try fileManager.contentsOfDirectory(
                at: documentsURL,
                includingPropertiesForKeys: [.contentModificationDateKey],
                options: .skipsHiddenFiles
            )

            images = contents.filter { url in
                let ext = url.pathExtension.lowercased()
                return ext == "jpg" || ext == "jpeg" || ext == "png" || ext == "heic"
            }

            sortImages()
            collectionView.reloadData()
            emptyStateLabel.isHidden = !images.isEmpty
        } catch {
            print("Error loading images: \(error.localizedDescription)")
        }
    }

    private func sortImages() {
        let alphabeticalSort = defaults.bool(forKey: "alphabeticalSort")

        if alphabeticalSort {
            images.sort { $0.lastPathComponent < $1.lastPathComponent }
        } else {
            images.sort { url1, url2 in
                let date1 = (try? url1.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast
                let date2 = (try? url2.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast
                return date1 > date2
            }
        }
    }

    @objc private func sortingChanged() {
        sortImages()
        collectionView.reloadData()
    }

    private func saveImageToDocuments(_ image: UIImage) {
        let documentsURL = getDocumentsDirectory()
        let timestamp = Int(Date().timeIntervalSince1970)
        let fileName = "IMG_\(timestamp).jpg"
        let fileURL = documentsURL.appendingPathComponent(fileName)

        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            showAlert(title: "Ошибка", message: "Не удалось обработать изображение")
            return
        }

        do {
            try imageData.write(to: fileURL)
            print("Image saved to: \(fileURL.path)")
            loadImagesFromDocuments()
        } catch {
            print("Error saving image: \(error.localizedDescription)")
            showAlert(title: "Ошибка", message: "Не удалось сохранить фото")
        }
    }

    private func deleteImage(at url: URL) {
        do {
            try fileManager.removeItem(at: url)
            print("Image deleted: \(url.lastPathComponent)")
            loadImagesFromDocuments()
        } catch {
            print("Error deleting image: \(error.localizedDescription)")
            showAlert(title: "Ошибка", message: "Не удалось удалить фото")
        }
    }

    @objc private func addPhotoTapped() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        let imageURL = images[indexPath.item]

        DispatchQueue.global(qos: .userInitiated).async {
            if let imageData = try? Data(contentsOf: imageURL),
               let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    cell.configure(with: image)
                }
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageURL = images[indexPath.item]

        if let imageData = try? Data(contentsOf: imageURL),
           let image = UIImage(data: imageData) {
            let imageVC = ImagePreviewViewController(image: image)
            navigationController?.pushViewController(imageVC, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            guard let self = self else { return UIMenu(title: "", children: []) }

            let imageURL = self.images[indexPath.item]

            let deleteAction = UIAction(
                title: "Удалить",
                image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) { _ in
                self.confirmDelete(at: indexPath)
            }

            return UIMenu(title: "", children: [deleteAction])
        }
    }

    private func confirmDelete(at indexPath: IndexPath) {
        let alert = UIAlertController(
            title: "Удалить фото?",
            message: "Это действие нельзя отменить",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            let imageURL = self?.images[indexPath.item]
            if let url = imageURL {
                self?.deleteImage(at: url)
            }
        })

        present(alert, animated: true)
    }
}

extension GalleryViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let result = results.first else { return }

        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showAlert(title: "Ошибка", message: error.localizedDescription)
                    return
                }

                guard let image = object as? UIImage else {
                    self?.showAlert(title: "Ошибка", message: "Не удалось обработать изображение")
                    return
                }

                self?.saveImageToDocuments(image)
            }
        }
    }
}

class ImageCell: UICollectionViewCell {

    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .secondarySystemBackground
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        layer.cornerRadius = 8
        layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with image: UIImage) {
        imageView.image = image
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}

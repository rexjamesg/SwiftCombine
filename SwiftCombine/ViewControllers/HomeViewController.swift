//
//  HomeViewController.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2025/3/4.
//

import Combine
import UIKit

// MARK: - HomeViewModel

class HomeViewModel {
    
    @Published var urls = [URL]()
    var reveivedImagePublisher: PassthroughSubject<UIImage, Never> = .init()

    // MARK: - Private Properties

    private let downloadQueue = OperationQueue()
    private var operations = [Operation]()
    private(set) var downloadImages = [UIImage]()
    private var subscribers = Set<AnyCancellable>()

    init() {
        downloadQueue.maxConcurrentOperationCount = 1
        bind()
    }
}

// MARK: - Bind

private extension HomeViewModel {
    func bind() {
        $urls.sink { [weak self] urls in
            guard let self = self else { return }
            self.setDownloadQueue(urls: urls)
        }.store(in: &subscribers)
    }
}

// MARK: - Private Methods

private extension HomeViewModel {
    func setDownloadQueue(urls: [URL]) {
        operations.removeAll()
        for url in urls {
            let operation = DownloadOperation(url: url)
            operations.append(operation)
            operation.completionBlock = { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if let image = operation.downloadedImage {
                        print("圖片 下載完成")
                        self.downloadImages.append(image)
                        self.reveivedImagePublisher.send(image)
                    }
                }
            }
        }

        downloadQueue.addOperations(operations, waitUntilFinished: false)
    }
}

// MARK: - HomeViewController

class HomeViewController: BaseViewController {
    // MARK: - Private Properties

    private var imageView = UIImageView()
    private var viewModel = HomeViewModel()
    private var subscribers = [AnyCancellable]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        setupUI()
        bind()
        viewModel.urls = getFakeData()
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}

// MARK: - Bind

private extension HomeViewController {
    func bind() {
        viewModel.reveivedImagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let self = self else { return }
                self.imageView.image = image
            }.store(in: &subscribers)
    }
}

//MARK: - Private Methods
private extension HomeViewController {
    func setupUI() {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.width))
        imageView.center = view.center
        imageView.backgroundColor = .red
        view.addSubview(imageView)
    }
    
    func getFakeData() -> [URL] {
        var urls = [URL]()

        for _ in 0 ..< 10 {
            urls.append(URL(string: "https://picsum.photos/300/300")!)
        }

        return urls
    }
}

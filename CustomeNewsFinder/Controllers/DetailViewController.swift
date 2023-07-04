//
//  DeatailViewController.swift
//  CustomeNewsFinder
//
//  Created by алексей ганзицкий on 13.02.2023.
//

import UIKit

class DetailViewController: UIViewController {
    
    var urlToFullNews: String?
    var urlToImage: String?
    var labelTitle = UILabel()
    var labelDetailNews = UILabel()
    var labelDateNews = UILabel()
    var labelNewsSource = UILabel()
    let button = UIButton()
    var imageView = UIImageView()
    let labelLoading = UILabel()
    var networkManager: NetworkManager?
    var counterTEST = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatDate()
        setupConstraints()
        setupButton()
        view.backgroundColor = .systemGray4
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if imageView.image != nil {
            labelLoading.isHidden = true
        }
    }
    
    func setImage(urlImage: String) {
        networkManager?.loadImage(urlForImage: urlImage, completion: { [weak self] image in
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        })
    }
    
    func formatDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" //        "2023-02-05T12:00:00Z"
        guard let convertDate = formatter.date(from: labelDateNews.text ?? "") else { return }
        formatter.dateFormat = "dd.MMMM.yyyy"
        let newString = formatter.string(from: convertDate)
        labelDateNews.text = newString
    }
    
    func setValuesForController(saveObjectForSingleNews: SaveDataForSingleNews?) {
        urlToImage = saveObjectForSingleNews?.urlToImage
        labelTitle.text = saveObjectForSingleNews?.title
        labelDetailNews.text = saveObjectForSingleNews?.description
        labelDateNews.text = saveObjectForSingleNews?.publishedAt
        labelNewsSource.text = saveObjectForSingleNews?.author
        setImage(urlImage: saveObjectForSingleNews?.urlToImage ?? "")
        urlToFullNews = saveObjectForSingleNews?.url
    }
    
    @objc func buttonTapped() {
        animationTapt()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        let controller = WebViewController()
            if let url = self.urlToFullNews {
                controller.newsURL = url
                controller.selectedNews = self.labelTitle.text
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    private func animationTapt() {
        UIView.animate(withDuration: 0.3) {
            self.button.backgroundColor = .green
        } completion: { _ in
            self.button.backgroundColor = .red
        }
    }
    
}

extension DetailViewController {
    // MARK: - set constraints
    func setupConstraints() {
        setupButton()
        [labelTitle, labelDetailNews, labelDateNews, labelNewsSource].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textAlignment = .center
            $0.numberOfLines = 10
            $0.textColor = .black
            $0.font = UIFont.boldSystemFont(ofSize: 16)
            view.addSubview($0)
        }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        labelLoading.text = "LOADING..."
        labelLoading.textAlignment = .center
        labelLoading.textColor = .black
        labelLoading.font = UIFont.boldSystemFont(ofSize: 20)
        labelLoading.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(labelLoading)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            labelLoading.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            labelLoading.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            
        ])
        
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            labelTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            labelTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            labelDetailNews.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            labelDetailNews.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            labelDetailNews.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            labelDateNews.topAnchor.constraint(equalTo: labelDetailNews.bottomAnchor, constant: 16),
            labelDateNews.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            labelDateNews.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            labelNewsSource.topAnchor.constraint(equalTo: labelDateNews.bottomAnchor, constant: 16),
            labelNewsSource.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            labelNewsSource.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    func setupButton() {
        button.setTitle("Go to full news", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 20
        button.backgroundColor = .red
        button.layer.borderWidth = 5
        button.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

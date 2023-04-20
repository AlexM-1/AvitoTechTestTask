//
//  ViewController.swift
//  AvitoTechTestTask
//
//  Created by Alex M on 19.04.2023.
//

import UIKit

class AddServicesController: UIViewController {
    
    private let viewModel: AddServicesViewModel
    
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Arial-BoldMT", size: 28)
        label.numberOfLines = 2
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(AddServiceCell.self, forCellWithReuseIdentifier: String(describing: AddServiceCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Arial", size: 20)
        let action = UIAction {_ in
            self.viewModel.changeState(.buttonDidTap)
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    
    init(viewModel: AddServicesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        layout()
        bindViewModel()
        viewModel.changeState(.viewIsReady)
    }
    
    private func setButtonTitle() {
        var isSelected = false
        viewModel.addServices.result.list.forEach {
            if $0.isSelected {
                isSelected = true
            }
        }
        let title = isSelected ? viewModel.addServices.result.selectedActionTitle : viewModel.addServices.result.actionTitle
        button.setTitle(title, for: .normal)
    }
    
    private func initialize() {
        view.backgroundColor = .white
        [collectionView, titleLabel, button, activityIndicator].forEach {
            view.addSubview($0)
        }
        titleLabel.text = viewModel.addServices.result.title
        setButtonTitle()
        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .close)
        
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            button.heightAnchor.constraint(equalToConstant: 50),
            
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            collectionView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -12),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 12),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
        
    }
    
    private func bindViewModel() {
        viewModel.stateChanged = { [weak self] state in
            switch state {
            case .initial:
                print("")
            case .loading:
                DispatchQueue.main.async {
                    self?.activityIndicator.startAnimating()
                    self?.activityIndicator.isHidden = false
                }
            case .loaded:
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                    self?.collectionView.reloadData()
                    self?.setButtonTitle()
                }
            case .error:
                print("error")
            }
        }
    }
    
}



// MARK: - UICollectionViewDataSource
extension AddServicesController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.addServices.result.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AddServiceCell.self), for: indexPath) as! AddServiceCell
        cell.setupCell(list: viewModel.addServices.result.list[indexPath.item])
        return cell
    }
}


// MARK: - UIScrollViewDelegate
extension AddServicesController: UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.changeState(.cellIsSelected(indexPath.row))
        collectionView.reloadItems(at: [indexPath])
        setButtonTitle()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AddServicesController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 200)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
}



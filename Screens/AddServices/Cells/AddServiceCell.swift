
import UIKit

class AddServiceCell: UICollectionViewCell {
    
    private var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.frame.width / 2
        return imageView
    }()
    
    private var selectedIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemBlue
        imageView.backgroundColor = .systemGray6
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Arial-BoldMT", size: 25)
        label.numberOfLines = 1
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Arial", size: 18)
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Arial-BoldMT", size: 22)
        label.numberOfLines = 1
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    
    private lazy var textVStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 5
        stack.distribution = .equalSpacing
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(descriptionLabel)
        stack.addArrangedSubview(priceLabel)
        return stack
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemGray6
        layout()
    }
    
    func setupCell(list: List) {
        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        iconView.image = nil
        NetworkManager.shared.loadImageFromUrl(imageUrl: list.icon.the52X52) { image in
            if let image = image {
                DispatchQueue.main.async {
                    self.iconView.image = image
                }
            }
        }
        selectedIcon.image = list.isSelected ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
        titleLabel.text = list.title
        descriptionLabel.text = list.description
        priceLabel.text = list.price
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        [iconView, selectedIcon, textVStack].forEach {
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 60),
            iconView.widthAnchor.constraint(equalToConstant: 60),
            
            selectedIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            selectedIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            selectedIcon.heightAnchor.constraint(equalToConstant: 30),
            selectedIcon.widthAnchor.constraint(equalToConstant: 30),
            
            textVStack.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 20),
            textVStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            textVStack.trailingAnchor.constraint(equalTo: selectedIcon.leadingAnchor,constant: 10),
            textVStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
        ])
    }
}

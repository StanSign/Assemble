//
//  BannerCell.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/14.
//

import UIKit

import RxSwift
import RxGesture
import SnapKit

class BannerCell: UICollectionViewCell {
    private var disposeBag = DisposeBag()
    
    static let identifier = "BannerCell"
    
    lazy var upcomingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var gradientContainer: UIView = {
        let view = UIView()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.black.cgColor,
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        gradientLayer.locations = [0, 0.25, 0.35, 0.5, 1]
        self.layer.addSublayer(gradientLayer)
        gradientLayer.frame = self.bounds
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: TypeSize.largeTitle.rawValue, weight: .heavy)
        label.allowsDefaultTighteningForTruncation = true
        label.textColor = .white
        return label
    }()
    
    lazy var arrowIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_right_small")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: TypeSize.body.rawValue, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: TypeSize.body.rawValue, weight: .regular)
        label.textColor = .white
        label.layer.opacity = 0.7
        return label
    }()
    
    lazy var labelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        stack.contentMode = .scaleAspectFit
        return stack
    }()
    
    lazy var titleStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.contentMode = .scaleAspectFit
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
}

//MARK: - Private

private extension BannerCell {
    func configureUI() {
        contentView.addSubview(self.upcomingImageView)
        self.upcomingImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(self.gradientContainer)
        self.gradientContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        insertSubview(self.labelStack, aboveSubview: self.gradientContainer)
        self.labelStack.snp.makeConstraints { make in
            make.bottom.left.equalToSuperview().inset(32)
        }
        self.labelStack.addArrangedSubview(self.stateLabel)
        self.titleStack.addArrangedSubview(self.titleLabel)
        self.titleStack.addArrangedSubview(self.arrowIcon)
        self.labelStack.addArrangedSubview(self.titleStack)
        self.labelStack.addArrangedSubview(self.subtitleLabel)
    }
}

//
//  BannerCell.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/14.
//

import UIKit

import RxSwift
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
        label.textColor = .white
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: TypeSize.body.rawValue, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    lazy var labelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
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
            make.centerY.equalToSuperview()
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(self.gradientContainer)
        self.gradientContainer.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.edges.equalToSuperview()
        }
        
        insertSubview(self.labelStack, aboveSubview: gradientContainer)
        self.labelStack.snp.makeConstraints { make in
            make.bottom.left.equalToSuperview().inset(32)
        }
        labelStack.addArrangedSubview(stateLabel)
        labelStack.addArrangedSubview(titleLabel)
        labelStack.addArrangedSubview(subtitleLabel)
    }
}

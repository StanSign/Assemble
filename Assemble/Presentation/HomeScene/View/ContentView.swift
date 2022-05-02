//
//  ContentView.swift
//  Assemble
//
//  Created by 이창준 on 2022/05/01.
//

import UIKit

import SnapKit

@IBDesignable
class ContentView: UIView {
    lazy var titleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.1)
        return view
    }()
    
    lazy var titleStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        return stack
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: self.configureCollectionView()
        )
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.bounces = false
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    @IBInspectable var titleHeight: CGFloat {
        get {
            return self.titleContainerView.bounds.height
        } set {
            self.titleContainerView.snp.makeConstraints { make in
                make.height.equalTo(newValue)
            }
        }
    }
    
    @IBInspectable var contentHeight: CGFloat {
        get {
            return self.collectionView.bounds.height
        } set {
            self.collectionView.snp.makeConstraints { make in
                make.height.equalTo(newValue)
            }
        }
    }
    
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

private extension ContentView {
    func configureUI() {
        self.addSubview(self.titleContainerView)
        self.titleContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(12)
        }
        
        self.titleStack.addArrangedSubview(self.titleLabel)
        self.titleStack.addArrangedSubview(self.subtitleLabel)
        self.titleContainerView.addSubview(self.titleStack)
        self.titleStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(12)
        }
        
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.titleContainerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    func configureCollectionView() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return layout
    }
}

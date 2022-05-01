//
//  ContentView.swift
//  Assemble
//
//  Created by 이창준 on 2022/05/01.
//

import UIKit

import RxSwift
import SnapKit

class ContentView: UIView {
    private var disposebag = DisposeBag()
    
    lazy var titleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
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

private extension ContentView {
    func configureUI() {
        self.addSubview(self.titleContainerView)
        self.titleContainerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(48)
        }
        
        self.titleContainerView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(12)
        }
    }
}

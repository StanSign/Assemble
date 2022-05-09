//
//  News.swift
//  Assemble
//
//  Created by 이창준 on 2022/05/02.
//

import UIKit

import RxSwift
import RxGesture
import SwiftUI

class NewsCell: UICollectionViewCell {
    
    static let identifier = "NewsCell"
    
    let viewModel = NewsCellViewModel(
        newsUseCase: DefaultNewsUseCase(
            newsRepository: DefaultNewsRepository()
        )
    )
    
    let url: PublishSubject = PublishSubject<String>()
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var videoIconView: UIImageView!
    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configureUI()
        self.bindViewModel()
    }
    
    private func configureUI() {
        self.containerView.backgroundColor = #colorLiteral(red: 0.08463992923, green: 0.09003034979, blue: 0.09286475927, alpha: 1)
        self.tagLabel.layer.opacity = 0
        self.containerView.layer.cornerRadius = 8
    }
    
    private func bindViewModel() {
        let input = NewsCellViewModel.Input(
            cellDidTapEvent: self.containerView.rx.tapGesture().when(.recognized).asObservable(),
            urlString: self.url
        )
        
        let output = self.viewModel.transform(with: input, disposeBag: self.disposeBag)
    }
}

//
//  NewsView.swift
//  Assemble
//
//  Created by 이창준 on 2022/05/02.
//

import Foundation

import RxSwift
import RxDataSources
import Kingfisher

class NewsView: ContentView {
    private var disposeBag = DisposeBag()
    
    let viewModel = NewsViewModel(
        newsUseCase: DefaultNewsUseCase(
            newsRepository: DefaultNewsRepository()
        )
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
        self.bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
        self.bindViewModel()
    }
}

private extension NewsView {
    func configureUI() {
        self.collectionView.delegate = self
        let nib = UINib(nibName: NewsCell.identifier, bundle: nil)
        self.collectionView.register(
            nib,
            forCellWithReuseIdentifier: NewsCell.identifier
        )
    }
    
    func bindViewModel() {
        let input = NewsViewModel.Input(
            viewDidInit: Observable.just(()).asObservable()
        )
        
        let output = self.viewModel.transform(with: input, disposeBag: self.disposeBag)
        
        output.newsData
            .bind(to: self.collectionView.rx.items(cellIdentifier: NewsCell.identifier, cellType: NewsCell.self)) { index, news, cell in
                cell.imageView.kf.setImage(with: URL(string: news.thumbnail))
                cell.typeLabel.text = news.type.rawValue
                cell.titleLabel.text = news.title
                cell.url.onNext(news.urlString)
                if news.type == .youtube {
                    cell.videoIconView.isHidden = false
                }
            }
            .disposed(by: self.disposeBag)
    }
}

extension NewsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - 40
        return .init(width: width, height: 160)
    }
}

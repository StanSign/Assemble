//
//  InformationViewController.swift
//  Assemble
//
//  Created by 이창준 on 2022/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher
import SnapKit

class InformationViewController: UIViewController {
    
    //MARK: - Constants
    private let infoHeight: CGFloat = 120.0
    
    //MARK: - Variables
    private var isSwipeNotRecognized = true
    var id: Int?
    var type: AssembleAPIManager.contentType?
    // Rx
    var disposeBag = DisposeBag()
    var headerCellModel: HeaderCellModel = HeaderCellModel(id: 0, type: "", headLabel: "", subHeadLabel: "")
    var detailCellModel: DetailCellModel = DetailCellModel()
    
    private var headerOpenHeight: CGFloat = 0.0
    private var headerClosedHeight: CGFloat = 0.0
    private var lowerLimit: CGFloat = 0.0
    private var upperLimit: CGFloat = 0.0
    private var isHeaderOpen = true

    //MARK: - IBOutlets
    @IBOutlet weak var topMenuContainer: UIView!
    @IBOutlet weak var backIcon: UIImageView!
    @IBOutlet weak var shareIcon: UIImageView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var gradientContainerView: UIView!
    @IBOutlet weak var blurContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var screenEdgePanRecognizer: UIScreenEdgePanGestureRecognizer!
    
    //MARK: - Life Cycle
    
    convenience init(id: Int, type: AssembleAPIManager.contentType) {
        self.init()
        self.id = id
        self.type = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupEdgePanGesture()
        setupGradientLayer()
        setupGestures()
        registerXib()
        
        setupTableView()
        requestAPI()
        tableViewDidScroll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        openHeaderView()
    }
    
    //MARK: - Setup
    
    private func setupEdgePanGesture() {
        screenEdgePanRecognizer.edges = .left
    }
    
    private func setupGestures() {
        let backIconTap = UITapGestureRecognizer(target: self, action: #selector(backIconTapped))
        backIcon.addGestureRecognizer(backIconTap)
        let shareIconTap = UITapGestureRecognizer(target: self, action: #selector(shareIconTapped))
        shareIcon.addGestureRecognizer(shareIconTap)
    }
    
    @objc private func backIconTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func shareIconTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        print("Share Icon Tapped")
    }
    
    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0, 0.5, 0.7, 1]
        
        gradientContainerView.isUserInteractionEnabled = false
        gradientContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        gradientContainerView.layer.addSublayer(gradientLayer)
        
        gradientLayer.frame = imageContainerView.bounds
    }
    
    @IBAction func screenEdgePanned(_ sender: Any) {
        if isSwipeNotRecognized {
            isSwipeNotRecognized = false
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - Network
    
    private func requestAPI() {
        AssembleAPIManager.shared.requestDetailInfo(id, type) { data in
            var imageString: String?
            switch self.type {
            case .films:
                do {
                    let res = try JSONDecoder().decode(AssembleAPIManager.FilmResult.self, from: data)
                    let dataModel = res.results.first!
                    imageString = dataModel.fImage
                    self.headerCellModel.type = "films"
                    self.headerCellModel.headLabel = dataModel.fNM
                    self.headerCellModel.subHeadLabel = dataModel.fNM_en
                    self.headerCellModel.childImage1 = dataModel.fUniv
                    self.headerCellModel.childImage3 = dataModel.fRating
                    let endIdx: String.Index = dataModel.fReleaseDate!.index(dataModel.fReleaseDate!.startIndex, offsetBy: 3)
                    let releaseYear = String(dataModel.fReleaseDate![...endIdx])
                    self.headerCellModel.childLabel1 = releaseYear
                    let runTime = Int(dataModel.fRunTime!)
                    let runTimeHour = runTime! / 60
                    let runTimeMinute = runTime! % 60
                    self.headerCellModel.childLabel2 = "\(runTimeHour)시간 \(runTimeMinute)분"
                    self.detailCellModel.body = dataModel.fPlot
                } catch { }
            case .tvSeries:
                print("TV Series")
            case .actors:
                do {
                    let res = try JSONDecoder().decode(AssembleAPIManager.ActorResult.self, from: data)
                    let dataModel = res.results.first!
                    imageString = dataModel.aImage
                    self.headerCellModel.type = "actors"
                    self.headerCellModel.headLabel = dataModel.aNM_en
                    self.headerCellModel.subHeadLabel = dataModel.aNM_en
                } catch { }
            case .characters:
                print("Character")
            default:
                print("Default")
            }
            AssembleAPIManager.shared.requestAndSetImage(to: self.imageView, with: imageString)
            self.bindDataToTableView()
        }
    }
    
    //MARK: - TableView
    
    private func registerXib() {
        let headerCellNib = UINib(nibName: HeaderCell().identifier, bundle: nil)
        tableView.register(headerCellNib, forCellReuseIdentifier: HeaderCell().identifier)
        
        let menuCellNib = UINib(nibName: MenuCell().identifier, bundle: nil)
        tableView.register(menuCellNib, forCellReuseIdentifier: MenuCell().identifier)
        
        let detailCellNib = UINib(nibName: DetailCell().identifier, bundle: nil)
        tableView.register(detailCellNib, forCellReuseIdentifier: DetailCell().identifier)
    }
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionOfInfoCell> { [weak self] dataSource, tableView, indexPath, item in
        switch item {
        case let .headerCell(cellModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderCell().identifier, for: indexPath) as! HeaderCell
            cell.backgroundColor = .clear
            cell.nameLabel.text = cellModel.headLabel
            cell.nameEnLabel.text = cellModel.subHeadLabel
            let childImages = [cellModel.childImage1, cellModel.childImage2, cellModel.childImage3]
            for (index, imageView) in cell.childImages.enumerated() {
                if childImages[index] != nil {
                    imageView.isHidden = false
                    imageView.image = UIImage(named: childImages[index]!)
                }
            }
            let childLabels = [cellModel.childLabel1, cellModel.childLabel2, cellModel.childLabel3]
            for (index, label) in cell.childLabels.enumerated() {
                if childLabels[index] != nil {
                    label.isHidden = false
                    label.text = childLabels[index]!
                }
            }
            return cell
        case .menuCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell().identifier, for: indexPath) as! MenuCell
            return cell
        case let .detailCell(cellModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell().identifier, for: indexPath) as! DetailCell
            cell.backgroundColor = .clear
            cell.detailLabel.text = cellModel.body
            return cell
        case .none:
            let cell = UITableViewCell()
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        }
    }
    
    private let data = BehaviorRelay<[SectionOfInfoCell]>(value: [])
    
    private func bindDataToTableView() {
        let item0 = CellType.none
        let item1 = CellType.headerCell(headerCellModel)
        let item2 = CellType.menuCell
        let item3 = CellType.detailCell(detailCellModel)
        let section = SectionOfInfoCell(items: [item0, item1, item2, item3, item0, item0, item0, item0, item0, item0, item0, item0, item0, item0, item0])
        
        data
          .bind(to: tableView.rx.items(dataSource: dataSource))
          .disposed(by: disposeBag)
        
        data.accept([section])
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        // UI Constants
        headerOpenHeight = imageContainerView.frame.height
        headerClosedHeight = 0.0
        lowerLimit = 0.0
        upperLimit = headerOpenHeight / 2
        
        tableViewDidEndDragging()
        tableViewDidEndDecelerating()
    }
    
    //MARK: - Did Scroll
    
    private func tableViewDidScroll() {
        tableView.rx.contentOffset.subscribe { contentOffset in
            let contentOffsetY = contentOffset.y
            print(contentOffsetY)
            self.updateHeader(with: contentOffsetY)
        } onError: { error in
            print(error)
        }
        .disposed(by: disposeBag)
    }
    
    private func updateHeader(with contentOffsetY: CGFloat) {
        let percentage: CGFloat = contentOffsetY / upperLimit

        imageContainerView.alpha = 1 - percentage
        topMenuContainer.alpha = 1 - percentage
    }
    
    private func openHeaderView() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self = self else { return }
            self.tableView.setContentOffset(CGPoint(x: 0, y: self.lowerLimit), animated: false)
            self.updateHeader(with: self.lowerLimit)
        })
    }
    
    private func closeHeaderView(_ offset: CGFloat) {
        if offset > upperLimit {
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                guard let self = self else { return }
                self.updateHeader(with: self.upperLimit)
            })
        } else {
            tableView.setContentOffset(CGPoint(x: 0, y: upperLimit), animated: true)
        }
        isHeaderOpen = false
    }
    
    //MARK: - End Scroll
    
    private func tableViewDidEndDragging() {
        tableView.rx.didEndDragging
            .subscribe(onNext: {_ in
                self.snapBack(self.tableView.contentOffset.y)
            })
            .disposed(by: disposeBag)
    }
    
    private func tableViewDidEndDecelerating() {
        tableView.rx.didEndDecelerating
            .subscribe(onNext: {
                self.snapBack(self.tableView.contentOffset.y)
            })
            .disposed(by: disposeBag)
    }
    
    private func snapBack(_ offSet: CGFloat) {
        if offSet > upperLimit / 4 {
            closeHeaderView(offSet)
        } else {
            openHeaderView()
        }
    }
}

extension InformationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return imageContainerView.frame.height * 0.7
        case 1:
            return infoHeight
        case 2:
            return 60
        case 3:
            return UITableView.automaticDimension
        default:
            return infoHeight
        }
    }
}

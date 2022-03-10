//
//  Network.swift
//  Assemble
//
//  Created by 이창준 on 2022/03/01.
//

import NVActivityIndicatorView
import SnapKit
import Alamofire
import AlamofireObjectMapper
import Kingfisher
import RealmSwift

class Network {
    
    //MARK: - Constants
    let realm = try! Realm()
    
    //MARK: - Variables
    class var baseURL: String {
        return "https://rxsvl8lvm8.execute-api.ap-northeast-2.amazonaws.com/beta-1/"
    }
    
    //MARK: - Functions
//    public func getFilmData(fromID fID: String) {
//        let url = "films/" + fID
//        Alamofire.request(Network.baseURL + url).responseObject { (response: DataResponse<FilmResponse>) in
//            switch response.result {
//            case .success(_):
//                let filmResponse = response.result.value
//                let results = filmResponse?.results
//                let imgURL = results?.first?.fImage
//                print(imgURL ?? "No URL")
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
    
    public func getUpcomingData(completion: @escaping () -> ()) {
        let url = "films/upcoming"
        Alamofire.request(Network.baseURL + url).responseJSON { response in
            guard let jsonString = String(data: response.data!, encoding: .utf8) else { return }
//            print(jsonString.utf8)
            // parse json to realm object
            let upcoming = responseFilm(JSONString: jsonString)
            guard let upcomingList = upcoming?.results else { return }
            // store realm object
            let realm = self.realm
            for upcomingFilm in upcomingList {
                realm.beginWrite()
                realm.add(upcomingFilm, update: .modified)
                if realm.isInWriteTransaction {
                    try! realm.commitWrite()
                }
            }
            completion()
        }
    }
    
    func loadImageToBanner(atIndex index: Int, to cell: Banner) {
        let upcomingData = realm.objects(Upcoming.self).sorted(byKeyPath: "fReleaseDate", ascending: false)
        let imgURL = URL(string: upcomingData[index].fImage)
        let fNM = upcomingData[index].fNM
        let releaseDate = upcomingData[index].fReleaseDate
        let fID = upcomingData[index].fID
        
        let imgIndicator = CustomIndicator()
        cell.bannerImage.kf.indicatorType = .custom(indicator: imgIndicator)
        cell.bannerImage.kf.setImage(with: imgURL, options: [
            .processor(DownsamplingImageProcessor(size: cell.bannerImage.bounds.size)),
            .scaleFactor(UIScreen.main.scale),
            .cacheOriginalImage
        ]) { result in
            switch result {
            case .success(let value):
                break
            case .failure(let error):
                print(error)
            }
        }
        
        let split_fNM = fNM.components(separatedBy: [":"])
        // Title
        cell.titleLabel.text = split_fNM.first
        // Subtitle
        if split_fNM.first != split_fNM.last {
            cell.subLabel.text = split_fNM.last
        } else {
            cell.subLabel.text = ""
        }
        // D-Day Counter
        let D_Day = DateTime().calculateDday(fromDate: releaseDate)
        switch D_Day {
        case Int.min ..< 0:
            cell.D_DayLabel.text = "D+\(abs(D_Day))"
        case 0 ..< Int.max:
            cell.D_DayLabel.text = "D-\(abs(D_Day))"
        case 0:
            cell.D_DayLabel.text = "D-Day"
        default:
            print("Smthing wrong")
        }
        // Tag
        cell.bannerView.tag = fID
    }
    
    func imagePrefetch() {
        let upcomingData = realm.objects(Upcoming.self).sorted(byKeyPath: "fReleaseDate", ascending: false)
        let imgStrings: [String] = upcomingData.value(forKey: "fImage") as! [String]
        let imgURLs: [URL] = imgStrings.compactMap { URL(string: $0)! }
        ImagePrefetcher(urls: imgURLs).start()
    }
}

//MARK: - Custom Indicator
struct CustomIndicator: Indicator {
    let view: UIView = UIView()
    var subView: NVActivityIndicatorView
    
    func startAnimatingView() { view.isHidden = false }
    func stopAnimatingView() { view.isHidden = true }
    
    init() {
        subView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 32, height: 32), type: .ballBeat, color: .white, padding: nil)
        subView.startAnimating()
        view.addSubview(subView)
        
        subView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

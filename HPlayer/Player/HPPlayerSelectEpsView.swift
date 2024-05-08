//
//  HPPlayerSelectEpsView.swift
//  HPPlixor
//
//  Created by HF on 2023/12/21.
//


import UIKit

class HPPlayerSelectEpsView: UIView {
    @IBOutlet weak var bView: UIView!
    
    @IBOutlet weak var epsView: UIView!
    @IBOutlet weak var ssnCollectionView: UICollectionView!
    
    @IBOutlet weak var epsCollectionView: UICollectionView!
    let ssnCellId = "HPPlayerSelectSsnCell"
    let epsCellId = "HPPlayerSelectEpsCell"
    typealias clickBlock = (_ list: [AVEpsModel], _ ssnId: String, _ epsId: String) -> Void
    var clickHandle : clickBlock?
    private var videoId: String = ""
    private var ssnId: String = ""
    private var midSsnId: String = ""
    private var epsId: String = ""
    private var ssnList: [AVInfoSsnlistModel?] = []
    private var epsList: [AVEpsModel] = []
    class func view() -> HPPlayerSelectEpsView {
        let view = Bundle.main.loadNibNamed(String(describing: HPPlayerSelectEpsView.self), owner: nil)?.first as! HPPlayerSelectEpsView
        return view
    }
    
    @objc func dismissSelf() {
        self.removeFromSuperview()
    }
    
    func setModel(_ id: String, _ ssnList: [AVInfoSsnlistModel], _ epsList: [AVEpsModel], _ epsId: String, clickBlock: clickBlock?) {
        self.bView.backgroundColor = UIColor.hexColor("#FFFFFF", alpha: 0.05)
        self.bView.setEffectView(CGSize(width: 356 + 48, height: kScreenWidth))
        self.ssnCollectionView.register(UINib(nibName: String(describing: HPPlayerSelectSsnCell.self), bundle: nil), forCellWithReuseIdentifier: ssnCellId)
        self.epsCollectionView.register(UINib(nibName: String(describing: HPPlayerSelectEpsCell.self), bundle: nil), forCellWithReuseIdentifier: epsCellId)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissSelf))
        self.addGestureRecognizer(tap)
        tap.delegate = self
        self.clickHandle = clickBlock
        self.videoId = id
        self.ssnList = ssnList
        self.epsList = epsList
        self.epsId = epsId
        self.ssnId = ssnList.first(where: {$0.isSelect == true})?.id ?? ""
        self.ssnCollectionView.reloadData()
        self.epsCollectionView.reloadData()
        for (index, item) in self.ssnList.enumerated() {
            if let m = item, m.isSelect {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                    guard let self = self else { return }
                    self.ssnCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: false)
                }
            }
        }
        for (index, item) in self.epsList.enumerated() {
            if item.isSelect {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                    guard let self = self else { return }
                    self.epsCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: false)
                }
            }
        }
    }
    
    func getEpsListData(_ ssnId: String) {
        if let _ = self.ssnList.first(where: {$0?.isSelect == true && $0?.id == ssnId}) {
            return
        } else {
            let _ = self.ssnList.map({$0?.isSelect = false})
            self.ssnList.first(where: {$0?.id == ssnId})??.isSelect = true
            self.ssnCollectionView.reloadData()
        }
        HPProgressHUD.show()
        PlayerNetAPI.share.AVTVEpsData(id: self.videoId, ssnId: ssnId) { [weak self] success, list in
            guard let self = self else { return }
            HPProgressHUD.dismiss()
            list.first(where: {$0.id == self.epsId})?.isSelect = true
            self.epsList = list
            DispatchQueue.main.async {
                self.epsCollectionView.reloadData()
            }
        }
    }
}

extension HPPlayerSelectEpsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == ssnCollectionView {
            return self.ssnList.count
        } else {
            return self.epsList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == ssnCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ssnCellId, for: indexPath) as! HPPlayerSelectSsnCell
            if let model = self.ssnList.indexOfSafe(indexPath.item), let m = model {
                cell.model = m
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: epsCellId, for: indexPath) as! HPPlayerSelectEpsCell
            if let model = self.epsList.indexOfSafe(indexPath.item) {
                cell.model = model
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == ssnCollectionView {
            if let model = self.ssnList.indexOfSafe(indexPath.item), let m = model {
                self.midSsnId = m.id
                self.getEpsListData(m.id)
            }
        } else {
            if let model = self.epsList.indexOfSafe(indexPath.item) {
                if self.midSsnId.count > 0 {
                    self.ssnId = self.midSsnId
                }
                self.epsId = model.id
                self.clickHandle?(self.epsList, self.ssnId, self.epsId)
                let _ = self.epsList.map({$0.isSelect = false})
                self.epsList.first(where: {$0.id == model.id})?.isSelect = true
                self.epsCollectionView.reloadData()
                self.dismissSelf()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == ssnCollectionView {
            var width: CGFloat = 0
            if let model = self.ssnList.indexOfSafe(indexPath.item), let m = model {
                if m.isSelect {
                    width = m.title.getStrW(font: .font(weigth: .medium, size: 18), h: 36)
                } else {
                    width = m.title.getStrW(font: .font(size: 14), h: 36)
                }
            }
            return CGSize(width: width + 2, height: 36)
        } else {
            return CGSize(width: 48, height: 48)
        }
    }
}

extension HPPlayerSelectEpsView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view {
            if view.isDescendant(of: self.ssnCollectionView) || view.isDescendant(of: self.epsCollectionView) {
                return false
            }
        }
        return true
    }
}

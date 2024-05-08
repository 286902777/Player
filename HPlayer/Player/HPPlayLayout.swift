//
//  HPPlayLayout.swift
//  HPlayer
//
//  Created by HF on 2023/1/3.
//


import UIKit
import SnapKit

protocol HPPlayLayoutDelegate: NSObjectProtocol {
    func playLayoutSizeForItem(atIndexPath indexPath: IndexPath) -> CGSize
    func playLayoutLineHeight() -> CGFloat
    func playLayoutSizeForHeader(inSection section: Int) -> CGSize
    func playLayoutSizeForFooter(inSection section: Int) -> CGSize
    func playLayoutSpacingBetweenItems(inSection section: Int) -> CGFloat
    func playLayoutSpacingBetweenLines(inSection section: Int) -> CGFloat
    func playLayoutLineWidth() -> CGFloat
    func playLayoutLineInsetLeft(inSection section: Int) -> CGFloat
    func playLayoutLineInsetRight(inSection section: Int) -> CGFloat
}

extension HPPlayLayoutDelegate {

    func playLayoutSpacingBetweenItems(inSection section: Int) -> CGFloat {
        return 0
    }
    func playLayoutSpacingBetweenLines(inSection section: Int) -> CGFloat {
        return 0
    }
    
    func playLayoutSizeForHeader(inSection section: Int) -> CGSize {
        return CGSize.zero
    }
       
    func playLayoutSizeForFooter(inSection section: Int) -> CGSize {
        return CGSize.zero
    }
    func playLayoutLineWidth() -> CGFloat {
        return 0
    }
    func playLayoutLineInsetLeft(inSection section: Int) -> CGFloat {
        return 0
    }
    func playLayoutLineInsetRight(inSection section: Int) -> CGFloat {
        return 0
    }
}


class HPPlayLayout: UICollectionViewFlowLayout {
    var cacheWidth: [IndexPath: CGFloat] = [:]
    var cellAttributes: [UICollectionViewLayoutAttributes] = []
    var isLoadData: Bool = false
    weak var delegate: HPPlayLayoutDelegate?
    var isHorizon = true {
        didSet {
            self.scrollDirection = isHorizon ? .horizontal : .vertical
        }
    }
    
    func reloadData() {
        self.cellAttributes.removeAll()
        self.cacheWidth.removeAll()
        self.isLoadData = false
        self.prepare()
    }
    
    override func prepare() {
        guard let collectionView = self.collectionView, let delegate = self.delegate else { return }
        
        self.cellAttributes.removeAll()
        self.cacheWidth.removeAll()
        
        let sectionContentWidth = delegate.playLayoutLineWidth()
        let sections = collectionView.numberOfSections
        var lastOffsetY: CGFloat = 0

        for s in 0 ..< sections {
            let leftInset = delegate.playLayoutLineInsetLeft(inSection: s)
            let rightInset = delegate.playLayoutLineInsetRight(inSection: s)

            let itemSpacing = delegate.playLayoutSpacingBetweenItems(inSection: s)
            let lineSpacing = delegate.playLayoutSpacingBetweenLines(inSection: s)
            /// header
            let headerSize = delegate.playLayoutSizeForHeader(inSection: s)
            if headerSize.height > 0 {
                let sectionHeaderAttri = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                                                            with: IndexPath(item: 0, section: s))
                sectionHeaderAttri.frame = CGRect(x: leftInset, y: lastOffsetY, width: headerSize.width, height: headerSize.height)
                self.cellAttributes.append(sectionHeaderAttri)
                lastOffsetY += headerSize.height
            }
            /// cells
            let items = collectionView.numberOfItems(inSection: s)
            var lastOffsetX: CGFloat = leftInset
            var cellHeight: CGFloat = 0
            for item in 0 ..< items {
                let indexPath = IndexPath(item: item, section: s)
                let itemSize = delegate.playLayoutSizeForItem(atIndexPath: indexPath)
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                var x: CGFloat = lastOffsetX
                var y: CGFloat = lastOffsetY
                let leftSpacing = sectionContentWidth - leftInset - rightInset - lastOffsetX - itemSize.width - itemSpacing
                if leftSpacing >= 0 {
                    /// 继续拼接
                    x = lastOffsetX
                    y = lastOffsetY
                    lastOffsetX = (x + itemSize.width + itemSpacing)
                    cellHeight = itemSize.height
                } else {
                    /// 换行
                    lastOffsetY += (cellHeight + lineSpacing)
                    x = leftInset
                    y = lastOffsetY
                    lastOffsetX = (x + itemSize.width + itemSpacing)
                }
                attr.frame = CGRect(origin: CGPoint(x: x, y: y), size: itemSize)
                self.cellAttributes.append(attr)
            }
            if items > 0 {
                lastOffsetY += (lineSpacing + delegate.playLayoutLineHeight())
            }
            /// footer
            let footerSize = delegate.playLayoutSizeForFooter(inSection: s)
            if footerSize.height > 0 {
                let sectionFooterAttri = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                                                      with: IndexPath(item: items + 1, section: s))
                sectionFooterAttri.frame = CGRect(x: leftInset, y: lastOffsetY + delegate.playLayoutLineHeight(), width: footerSize.width, height: footerSize.height)
                lastOffsetY += footerSize.height + delegate.playLayoutLineHeight()
                self.cellAttributes.append(sectionFooterAttri)
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.cellAttributes
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = self.collectionView, let last = self.cellAttributes.last else { return CGSize.zero }
        return CGSize(width: collectionView.bounds.width - sectionInset.left - sectionInset.right - collectionView.contentInset.left - collectionView.contentInset.right, height: last.frame.maxY)
    }
}

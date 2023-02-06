import UIKit
import Foundation

class CollectionViewCustomLayout: UICollectionViewFlowLayout {

    required override init() {super.init(); common()}
    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder); common()}

    private func common() {
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        minimumLineSpacing = 10
        minimumInteritemSpacing = 10
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let att = super.layoutAttributesForElements(in: rect) else {return []}
        var xAxis: CGFloat = sectionInset.left
        var yAxis: CGFloat = -1.0
        for item in att {
            if item.representedElementCategory != .cell { continue }
            if item.frame.origin.y >= yAxis { xAxis = sectionInset.left }
            item.frame.origin.x = xAxis
            xAxis += item.frame.width + minimumInteritemSpacing
            yAxis = item.frame.maxY
        }
        return att
    }
}

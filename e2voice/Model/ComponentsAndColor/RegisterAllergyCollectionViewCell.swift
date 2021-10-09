import UIKit

final class RegisterAllergyCollectionViewCell: UICollectionViewCell {
    

    //CollectionView内のcellに描画するUIImageViewの作成
    private let menuImg : UIImageView = {
        let img = UIImageView()
        return img
    }()
    
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.addSubview(menuImg)
    }

    //UILabelのセットアップ
    func setupContents(image:UIImage) {
        menuImg.image = image
        menuImg.frame.size = CGSize(width: contentView.frame.width, height: contentView.frame.width)
        menuImg.center = CGPoint(x: contentView.frame.width/2, y: contentView.frame.height/2)

    }
}

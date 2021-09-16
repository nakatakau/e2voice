import UIKit

final class MainCollectionViewCell: UICollectionViewCell {
    
    //CollectionView内のcellに描画するUIlabelの作成
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()

    //CollectionView内のcellに描画するUIImageViewの作成
    private let img : UIImageView = {
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
        contentView.addSubview(img)
        contentView.addSubview(label)
    }

    //UILabelのセットアップ
    func setupContents(textName: String, image: UIImage) {
        img.image = image
        img.frame.size = CGSize(width: contentView.frame.width * 2/3, height: contentView.frame.width * 2/3)
        img.center = CGPoint(x: contentView.frame.width/2, y: contentView.frame.height*0.40)
        label.font = originalFontSize
        label.frame.size = CGSize(width: contentView.frame.width , height: contentView.frame.height/3)
        label.center = CGPoint(x: contentView.frame.width/2, y: contentView.frame.height*0.84)
        label.text = textName
    }
    
}

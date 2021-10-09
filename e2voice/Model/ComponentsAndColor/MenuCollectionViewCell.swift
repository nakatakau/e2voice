import UIKit

protocol MenuCollectionViewCellBtnDelegate {
    func tapCellBtn()
}

final class MenuCollectionViewCell: UICollectionViewCell {
    
    var menuCollectionViewCellBtnDelegate : MenuCollectionViewCellBtnDelegate?
    
    //CollectionView内のcellに描画するUIlabelの作成
    private let title: UILabel = {
        let label = UILabel()
        label.textColor = black
        label.textAlignment = .left
        return label
    }()
    
    //CollectionView内のcellに描画するUIlabelの作成
    private let price: UILabel = {
        let label = UILabel()
        label.textColor = black
        label.textAlignment = .left
        return label
    }()

    //CollectionView内のcellに描画するUIImageViewの作成
    private let menuImg : UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    @objc func tap(){
        menuCollectionViewCellBtnDelegate?.tapCellBtn()
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.addSubview(menuImg)
        contentView.addSubview(title)
        contentView.addSubview(price)
    }

    //UILabelのセットアップ
    func setupContents(textName:String, priceTag:Int, image:UIImage, number:Int) {
        menuImg.image = image
        menuImg.frame.size = CGSize(width: contentView.frame.width, height: contentView.frame.width)
        menuImg.center = CGPoint(x: contentView.frame.width/2, y: contentView.frame.height*0.3)
        
        title.font =  smallFontSize
        title.frame.size = CGSize(width: contentView.frame.width , height: contentView.frame.height/6)
        title.center = CGPoint(x: contentView.frame.width/2, y: contentView.frame.height*0.65)
        title.text = textName
        
        price.font =  smallFontSize
        price.frame.size = CGSize(width: contentView.frame.width , height: contentView.frame.height/6)
        price.center = CGPoint(x: contentView.frame.width/2, y: contentView.frame.height*0.75)
        price.text = "金額:\(priceTag)"

    }
}

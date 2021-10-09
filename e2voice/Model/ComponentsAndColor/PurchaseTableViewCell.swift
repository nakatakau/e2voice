import UIKit

class PurchaseTableViewCell: UITableViewCell {

    //tableView内のcellに描画するUIImageViewの作成
    private let menuImg : UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    //tableView内のCellに描画するUIImageテキスト
    private let menuTitle = UILabel()
    
    //tableView内のCellに描画するUIImageテキスト
    private let purchaseNumberTitle = UILabel()
    
    //tableView内のCellに描画するUIImageテキスト
    private let priceTitle = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    private func setup() {
        contentView.addSubview(menuImg)
        contentView.addSubview(menuTitle)
        contentView.addSubview(purchaseNumberTitle)
        contentView.addSubview(priceTitle)
    }

    //セットアップを行う処理
    func setupContents(image:UIImage,title:String,purchaseNumber:String,price:String) {
        menuImg.image = image
        menuImg.frame = CGRect(x:contentView.frame.height * 0.05, y:contentView.frame.height * 0.05,width: contentView.frame.height * 0.9, height: contentView.frame.height * 0.9)
        menuTitle.text = title
        menuTitle.font = smallFontSize
        menuTitle.frame = CGRect(x:contentView.frame.height * 1.1, y:0 , width: contentView.frame.width * 0.6, height: contentView.frame.height * 0.4)
        purchaseNumberTitle.text = purchaseNumber
        purchaseNumberTitle.font = smallFontSize
        purchaseNumberTitle.frame = CGRect(x:contentView.frame.height * 1.1, y:contentView.frame.height * 0.5 , width: contentView.frame.width * 0.3, height: contentView.frame.height * 0.4)
        priceTitle.text = price
        priceTitle.font = smallFontSize
        priceTitle.textAlignment = .right
        priceTitle.frame = CGRect(x:contentView.frame.height * 1.1 + contentView.frame.width * 0.3, y:contentView.frame.height * 0.5 , width: contentView.frame.width * 0.35, height: contentView.frame.height * 0.4)
        
    }

}

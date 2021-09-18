import UIKit

//ラベルを生成し描画する関数
//幅:画面幅,高さは48(絶対値)
//中央位置で描画場所を決める
public func createUILabel(text:String,CGRectX:CGFloat,CGRectY:CGFloat,mainView:UIViewController,rgba:UIColor,fontSize:UIFont){
    let label = UILabel()
    label.frame.size = CGSize(width:mainView.view.bounds.width, height:48)
    label.center =  CGPoint(x: CGRectX, y: CGRectY)
    label.text = text
    label.textColor = rgba
    label.font = fontSize
    label.textAlignment = NSTextAlignment.center
    mainView.view.addSubview(label)
}

//ボタンを生成する関数
//サイズは幅144, 高さ64
public func createLoginUIButton(text:String,CGRectX:CGFloat,CGRectY:CGFloat,mainView:UIViewController,rgba:UIColor,fontSize:UIFont) -> UIButton{
    let button = UIButton()
    button.frame.size = CGSize(width:144, height:64)
    button.center =  CGPoint(x: CGRectX, y: CGRectY)
    button.setTitle(text, for:UIControl.State.normal)
    button.titleLabel?.font =  fontSize
    button.setTitleColor(UIColor.white, for: .normal)
    button.backgroundColor = rgba
    button.layer.cornerRadius = 10.0
    return button
}

//テキストフィールドを実装
//幅:画面幅 * 2/3,高さは48(絶対値)
//中央位置で描画場所を決める
//
public func createUITextField(text:String,CGRectX:CGFloat,CGRectY:CGFloat,mainView:UIViewController,rgba:UIColor,fontSize:UIFont) -> UITextField{
    let textField = UITextField()
    textField.placeholder = text
    textField.frame.size = CGSize(width:mainView.view.bounds.width * 2 / 3, height:48)
    textField.center = CGPoint(x: CGRectX, y: CGRectY)
    textField.layer.borderWidth = 1
    textField.layer.borderColor = rgba.cgColor
    textField.layer.cornerRadius = 5
    // border線と文字を離す
    textField.leftView = UIView(frame: .init(x: 0, y: 0, width: 5, height: 0))
    textField.leftViewMode = .always
    
    return textField
    
}

//UICollectionViewの実装
public func createUICollectionView(CGRectX:CGFloat,CGRectY:CGFloat,flowLayout:UICollectionViewFlowLayout,mainView:UIViewController) -> UICollectionView{
    let frameSize = CGRect(x: CGRectX, y: CGRectY, width: mainView.view.bounds.width , height: mainView.view.bounds.height);
    let collectionView = UICollectionView(frame:frameSize,collectionViewLayout:flowLayout)
    collectionView.backgroundColor = .white
    return collectionView
}

//UICollectionViewFlowLayoutの実装
//セルサイズは画面の半分を指定
public func createUICollectionViewFlowLayout(mainView:UIViewController) -> UICollectionViewFlowLayout{
    let flowLayout = UICollectionViewFlowLayout()
    //1セルあたりのサイズ
    flowLayout.itemSize = CGSize(width: mainView.view.frame.width * 0.4 , height: mainView.view.frame.width * 0.40)
    //セル同士の間隔
    flowLayout.minimumInteritemSpacing = mainView.view.frame.width * 0.05
    //セル同士の行間
    flowLayout.minimumLineSpacing = mainView.view.frame.width * 0.05
    //余白
    flowLayout.sectionInset = UIEdgeInsets(
        top: mainView.view.frame.width * 0.05,
        left: mainView.view.frame.width * 0.05,
        bottom: mainView.view.frame.width * 0.05,
        right: mainView.view.frame.width * 0.05
    )
    return flowLayout
}

//Menu用のUICollectionViewFlowLayoutの実装
public func createMenuUICollectionViewFlowLayout(mainView:UIViewController) -> UICollectionViewFlowLayout{
    let flowLayout = UICollectionViewFlowLayout()
    //1セルあたりのサイズ
    flowLayout.itemSize = CGSize(width: mainView.view.frame.width * 0.45 , height: mainView.view.frame.height * 0.4)
    //セル同士の間隔
    flowLayout.minimumInteritemSpacing = mainView.view.frame.width * 0.03
    //セル同士の行間
    flowLayout.minimumLineSpacing = mainView.view.frame.width * 0.05
    //余白
    flowLayout.sectionInset = UIEdgeInsets(
        top: mainView.view.frame.width * 0,
        left: mainView.view.frame.width * 0.03,
        bottom: mainView.view.frame.width * 0,
        right: mainView.view.frame.width * 0.03
    )
    return flowLayout
}

//navigationBarの生成
public func createNavigationBar(safeAreaHeght:CGFloat) -> UINavigationBar{
    let screenSize: CGRect = UIScreen.main.bounds
    let navBar = UINavigationBar(frame: CGRect(x: 0, y:safeAreaHeght , width: screenSize.width, height: 44))
    navBar.barTintColor = .white
    return navBar 
}

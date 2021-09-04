import UIKit

//UIラベルを生成する関数
//幅:画面の3/4(相対),高さは48(絶対値)
//中央位置で描画場所を決める
public func createUILabel(text:String,CGRectX:CGFloat,CGRectY:CGFloat,mainView:UIViewController,rgba:UIColor,fontSize:UIFont){
    let label = UILabel()
    label.frame.size = CGSize(width:mainView.view.bounds.width * 3/4, height:48)
    label.center =  CGPoint(x: CGRectX, y: CGRectY)
    label.text = text
    label.textColor = rgba
    label.font = fontSize
    label.textAlignment = NSTextAlignment.center
    mainView.view.addSubview(label)
}



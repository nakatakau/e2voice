import UIKit

//アラートを呼び出す
public func showAlert(title:String,message:String,mainVC:UIViewController){
    let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    mainVC.present(alertVC, animated: true, completion: nil)
}

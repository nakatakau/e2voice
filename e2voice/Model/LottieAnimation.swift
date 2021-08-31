import Foundation
import Lottie

//Lottieのアニメーションを実行する関数
//引数にlottieファイルを指定して、描画したいUIViewControllerに描画する
public func doLottieAnimation (fileName:String, CGRectX:CGFloat, CGRectY:CGFloat, mainView:UIViewController) -> Void{
    let animationView = AnimationView(name: fileName)
    animationView.frame = CGRect(x: CGRectX, y: CGRectY, width: mainView.view.bounds.width, height: mainView.view.bounds.height)
    animationView.center = mainView.view.center
    animationView.loopMode = .loop
    animationView.contentMode = .scaleAspectFit
    animationView.animationSpeed = 1
    mainView.view.addSubview(animationView)
    animationView.play()

}


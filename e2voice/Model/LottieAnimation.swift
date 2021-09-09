import Foundation
import Lottie

//Lottieのアニメーションを実行する関数
//引数にlottieファイルを指定して、対象のUIViewControllerに描画する
public func doLottieAnimation (fileName:String, CGRectX:CGFloat, CGRectY:CGFloat, mainView:UIViewController){
    let animationView = AnimationView(name: fileName)
    animationView.frame.size = CGSize(width: mainView.view.bounds.width, height: mainView.view.bounds.height)
    animationView.center = CGPoint(x: CGRectX, y: CGRectY)
    animationView.loopMode = .loop
    animationView.contentMode = .scaleAspectFit
    animationView.animationSpeed = 1
    mainView.view.addSubview(animationView)
    animationView.play()
}


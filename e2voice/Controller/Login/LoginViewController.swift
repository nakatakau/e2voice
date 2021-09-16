import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //ログインができていなければ下記を実行
        if checkIsLoginState() != true {
            //LoginViewControllerの通常処理
            //テキストの描画１
            createUILabel(text: "ようこそ!", CGRectX: self.view.frame.width/2, CGRectY: self.view.frame.height/6, mainView: self, rgba: black, fontSize: bigFontSize)
            //テキストの描画２
            createUILabel(text: "E2Voiceへ", CGRectX: self.view.frame.width/2, CGRectY: self.view.frame.height/6 * 1.5, mainView: self, rgba: black, fontSize: bigFontSize)
            
            //Lottieアニメーションを実行
            doLottieAnimation(fileName:"LoginViewAnimation", CGRectX:view.frame.width/2, CGRectY:view.frame.height/2, mainView:self)
            
            //ログインボタンの描画
            setupSignInButton()
            
            //新規登録ボタンの描画
            setupSignUpButton()
            
        }
       
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //ユーザーがログイン状態であればMainViewControllerへ遷移する
        if checkIsLoginState() == true {
            //遷移処理
            let nextVC = self.storyboard?.instantiateViewController(identifier: "MainMenuView") as! MainMenuViewController
            nextVC.modalPresentationStyle = .fullScreen
            self.present(nextVC, animated: true, completion: nil)
        }
    }
    
    //ログインボタンの描画
    func setupSignInButton(){
        let button = createLoginUIButton(text: "ログイン", CGRectX: self.view.frame.width/4, CGRectY: self.view.frame.height/6 * 5, mainView: self, rgba: blue, fontSize: originalFontSize)
        //SignInViewControllerへ画面遷移する
        button.addTarget(self, action: #selector(segueSignInViewController), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    //ログイン画面へ遷移（既にログイン処理済であれば）
    @objc func segueSignInViewController(){
        let nextVC = storyboard?.instantiateViewController(identifier: "SignInView") as! SignInViewController
        nextVC.modalPresentationStyle =  .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
    
    //新規登録ボタンの描画
    func setupSignUpButton(){
        let button =  createLoginUIButton(text: "新規登録", CGRectX: self.view.frame.width/4 * 3, CGRectY: self.view.frame.height/6 * 5, mainView: self, rgba: orange, fontSize: originalFontSize)
        //SignUpViewControllerへ画面遷移する
        button.addTarget(self, action: #selector(segueSignUpViewController), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    //新規登録画面へ遷移
    @objc func segueSignUpViewController(){
        let nextVC = storyboard?.instantiateViewController(identifier: "SignUpView") as! SignUpViewController
        nextVC.modalPresentationStyle =  .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
    
    
    //ユーザーがログイン状態を判断する
    func checkIsLoginState() -> Bool {
        if Auth.auth().currentUser != nil {
            return true
        }else{
            return false
        }
    }
    
}

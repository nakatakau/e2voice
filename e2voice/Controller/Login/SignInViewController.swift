import UIKit
import FirebaseAuth

class SignInViewController: UIViewController,UITextFieldDelegate {
    
    //email入力用のtextField
    var emailTextField    = UITextField()
    //password用のtextField
    var passwordTextField = UITextField()
    
    //ログインデータを格納する変数
    let loginData = SignUpData(email: "", password: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //emailテキストの描画１
        createUILabel(text: "Emailアドレスを入力", CGRectX: self.view.frame.width/2, CGRectY: self.view.frame.height/6, mainView: self, rgba: black, fontSize: originalFontSize)
        
        //emailテキストフィールドの描画
        setUpEmailTextFiled()
        
        //passwordテキストの描画
        createUILabel(text: "パスワードを入力", CGRectX: self.view.frame.width/2, CGRectY: self.view.frame.height/6 * 2.5, mainView: self, rgba: black, fontSize: originalFontSize)
        
        //passwordテキストフィールドの描画
        setUpPasswordTextFiled()
        
        //setupview2へ遷移するボタンの描画
        setupNextButton()
        
        //前の画面へ戻るボタンの描画
        setupDismissButton()
        

    }
    //emailのテキストフィールドの描画
    func setUpEmailTextFiled(){
        //textfiledを描画
        emailTextField = createUITextField(text: "例 : test@test.com", CGRectX: self.view.frame.width/2, CGRectY: self.view.frame.height/6 * 1.5, mainView: self, rgba: black, fontSize: originalFontSize)
        // デリゲートを委譲
        emailTextField.delegate = self
        //ログインデータのemailプロパティにtextfieldの値を代入
        self.view.addSubview(emailTextField)
    }
    
    
    //passwordのテキストフィールドの描画
    func setUpPasswordTextFiled(){
        //textfiledを描画
        passwordTextField = createUITextField(text: "例 : パスワード（6文字以上）", CGRectX: self.view.frame.width/2, CGRectY: self.view.frame.height/6 * 3, mainView: self, rgba: black, fontSize: originalFontSize)
        //テキストフィールドを非表示モードにする
        passwordTextField.isSecureTextEntry = true
        // デリゲートを委譲
        passwordTextField.delegate = self
        self.view.addSubview(passwordTextField)
    }
    
    //リターンキーを押すとキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //キーボードを閉じるタイミングでloginDataにテキストフィールドのテキストを代入
        loginData.email = emailTextField.text ?? ""
        loginData.password = passwordTextField.text ?? ""
       // キーボードを閉じる
       textField.resignFirstResponder()
       //キーボードを閉じる際にtextDataへ入力値を渡す
       return true
    }
    
    //ボタンを描画し次の画面へ遷移する
    func setupNextButton(){
        let button = createLoginUIButton(text: "次へ", CGRectX: self.view.frame.width/4 * 3, CGRectY: self.view.frame.height/6 * 4.8, mainView: self, rgba: orange, fontSize: originalFontSize)
        button.addTarget(self, action: #selector(segueSignUpView2), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    //MainMenuViewControllerへ遷移する関数
    @objc func segueSignUpView2(){
        if loginData.email == ""  || loginData.password == ""{
            showAlert(title: "エラー", message: "メールアドレスかパスワードが入力できていません", mainVC: self)
        } else {
            emailLogin(email:loginData.email,password:loginData.password)
        }
    }
    
    //Firebaseのログイン処理
    func emailLogin(email:String,password:String){
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error as NSError?{
                //エラー発生時の処理
                let errorMessage = self.loginErrorMessage(error)
                showAlert(title: "エラー", message: errorMessage, mainVC: self)
            }
            //ログイン成功時の処理
            let nextVC = self.storyboard?.instantiateViewController(identifier: "MainMenuView") as! MainMenuViewController
            nextVC.modalPresentationStyle = .fullScreen
            self.present(nextVC, animated: true, completion: nil)
        }
    }
    
    //ログイン時にエラーが発生した際の処理
    func loginErrorMessage(_ error:NSError) -> String {
        var message = ""
        if let errCode = AuthErrorCode(rawValue: error.code) {
            switch errCode {
            case .userNotFound:  message = "アカウントが見つかりませんでした"
            case .wrongPassword: message = "パスワードが違います"
            case .userDisabled:  message = "アカウントが無効です"
            case .invalidEmail:  message = "メールアドレスが無効です"
            default: message = "エラー: \(error.localizedDescription)"
            }
        }
        return message
     }

    //ボタンを描画し前の画面へ戻る
    func setupDismissButton(){
        let button = createLoginUIButton(text: "戻る", CGRectX: self.view.frame.width/4, CGRectY: self.view.frame.height/6 * 4.8, mainView: self, rgba: gray, fontSize: originalFontSize)
        button.addTarget(self, action: #selector(dissmissVC), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    //前の画面へ戻る処理
    @objc func dissmissVC(){
        self.dismiss(animated: true, completion: nil)
    }

}

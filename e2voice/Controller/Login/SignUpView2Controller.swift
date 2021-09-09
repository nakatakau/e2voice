import UIKit
import FirebaseAuth

class SignUpView2Controller: UIViewController,UITextFieldDelegate {

    //サインアップに必要な構造体をインスタンス化
    let signUpData = SignUpData(email: "", password: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //テキストの描画１
        createUILabel(text: "パスワードを入力してください", CGRectX: self.view.frame.width/2, CGRectY: self.view.frame.height/6, mainView: self, rgba: black, fontSize: originalFontSize)
        
        //Lottieを描画
        doLottieAnimation(fileName:"SignUpViewAnimation", CGRectX:view.frame.width/2, CGRectY:view.frame.height/6 * 2, mainView:self)
        
        //テキストフィールドの描画
        setUpTextFiled()
        
        //setupview2へ遷移するボタンの描画
        setupNextButton()
        
        //前の画面へ戻るボタンの描画
        setupDismissButton()

    }
    
    //テキストフィールドの描画
    func setUpTextFiled(){
        //textfiledを描画
        let textField = createUITextField(text: "パスワードを入力(6文字以上)", CGRectX: self.view.frame.width/2, CGRectY: self.view.frame.height/6 * 3.1, mainView: self, rgba: black, fontSize: bigFontSize)
        //テキストフィールドを非表示モードにする
        textField.isSecureTextEntry = true
        // デリゲートを委譲
        textField.delegate = self
        self.view.addSubview(textField)
    }

    //リターンキーを押すとキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       // キーボードを閉じる
       textField.resignFirstResponder()
       //キーボードを閉じる際にtextDataへ入力値を渡す
        signUpData.password = textField.text ?? ""
       return true
    }

    //ボタンを描画し次の画面へ遷移する
    func setupNextButton(){
        let button = createLoginUIButton(text: "次へ", CGRectX: self.view.frame.width/4 * 3, CGRectY: self.view.frame.height/6 * 4.8, mainView: self, rgba: orange, fontSize: originalFontSize)
        button.addTarget(self, action: #selector(segueSignUpView2), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    //SignUpView2Controllerへ遷移する関数
    @objc func segueSignUpView2(){
        let paswword = signUpData.password
        if paswword == "" {
            showAlert(title: "エラー", message: "パスワードが入力できていません。", mainVC: self)
        } else {
            //textfieldのテキストをsignUpDateへ渡す
            emailSignUp(email: signUpData.email, password: signUpData.password,mainVC: self)
        }
    }
    
    //Firebaseへアカウント情報を新規登録する
    func emailSignUp (email:String, password:String,mainVC:UIViewController){
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error as NSError?{
                //アカウント作成が失敗時の処理
                let errorMessage = self.showFirebaseSignUpEroor(error)
                showAlert(title: "エラー", message: errorMessage, mainVC: self)
            }else{
                //アカウント作成が成功時の処理
                let nextVC = self.storyboard?.instantiateViewController(identifier: "CompletionSignUpView") as! CompletionSignUpViewController
                nextVC.modalPresentationStyle = .fullScreen
                mainVC.present(nextVC, animated: true, completion: nil)
            }
        }
    }
    
    //新規登録時にエラーが発生した際のメッセージを表示
    func showFirebaseSignUpEroor(_ error:NSError) -> String{
        var message = ""
        if let errCode = AuthErrorCode(rawValue: error.code){
            switch errCode {
            //AuthErrorCode.invalidEmailといった書き方を省略
            case .invalidEmail:      message = "有効なメールアドレスを入力してください"
            case .emailAlreadyInUse: message = "既に登録されているメールアドレスです"
            case .weakPassword:      message = "パスワードは6文字以上で入力してください"
            default:                 message = "エラー: \(error.localizedDescription)"
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

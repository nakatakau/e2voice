import UIKit

class SignUpViewController: UIViewController,UITextFieldDelegate {
    
    //テキストフィールド(email)の値を格納する変数
    var textData = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //テキストの描画１
        createUILabel(text: "Emailアドレスを教えてください", CGRectX: self.view.frame.width/2, CGRectY: self.view.frame.height/6, mainView: self, rgba: black, fontSize: originalFontSize)
        
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
        let textField = createUITextField(text: "例 : test@test.com", CGRectX: self.view.frame.width/2, CGRectY: self.view.frame.height/6 * 3.1, mainView: self, rgba: black, fontSize: bigFontSize)
        // デリゲートを委譲
        textField.delegate = self
        self.view.addSubview(textField)
    }

    //リターンキーを押すとキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       // キーボードを閉じる
       textField.resignFirstResponder()
       //キーボードを閉じる際にtextDataへ入力値を渡す
       textData = textField.text ?? ""
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
        let nextVC = storyboard?.instantiateViewController(identifier: "SignUpView2") as! SignUpView2Controller
        nextVC.modalPresentationStyle = .fullScreen
        let emailAdress = textData
        if emailAdress == "" {
            showAlert(title: "エラー", message: "メールアドレスが入力できていません", mainVC: self)
        } else {
            //textfieldのテキストをsignUpDateへ渡す
            nextVC.signUpData.email = emailAdress
            self.present(nextVC, animated: true, completion: nil)
        }
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

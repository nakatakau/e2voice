import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class EditProfileViewController: UIViewController,UITextFieldDelegate {
    
    //ユーザーの名前を表示するテキストフィールド
    var userNameTextField = UITextField()
    
    //住所を表示するテキストフィールド
    var addressTextField = UITextField()
    
    //生年月日を表示するテキストフィールド
    var birthDayTextField = UITextField()
    
    //ユーザー情報のインスタンス
    var userAuthInfo = UserAuthInfo()
    var userInfo = UserInfo()
    
    //datepicker
    var datePicker: UIDatePicker = UIDatePicker()
    
    //Firestoreのインスタンス
    let db = Firestore.firestore()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //テキストの描画１
        createUILabel(text: "登録した情報を変更できます。", CGRectX: self.view.frame.width/2, CGRectY: self.view.frame.height/7, mainView: self, rgba: black, fontSize: originalFontSize)
        
        //テキストの描画3
        createLeftUILabel(text: "名前の変更", CGRectX: self.view.frame.width/2, CGRectY: self.view.frame.height*1.5/7, mainView: self, rgba: black, fontSize: smallFontSize)
        
        //テキストの描画4
        createLeftUILabel(text: "生年月日の変更", CGRectX: self.view.frame.width/2, CGRectY: self.view.frame.height*2.5/7, mainView: self, rgba: black, fontSize: smallFontSize)
        
        //テキストの描画5
        createLeftUILabel(text: "住所の変更", CGRectX: self.view.frame.width/2, CGRectY: self.view.frame.height*3.5/7, mainView: self, rgba: black, fontSize: smallFontSize)
        
        //テキストフィールドのセットアップ
        setupTextFieldData()
        
        //Firebaseからデータを取得しテキストフィールドを描画
        getUserInfoFromFirestore()
        
        //登録ボタンを描画
        setupRegisterBtn()
        
    }
    
    override func viewWillLayoutSubviews() {
        //navigationbarの設定
        setNavigationBar(title: "ユーザー情報")
    }
    
    //テキストフィールドをセットアップする
    func setupTextFieldData(){
        userNameTextField = createUITextField(text: "", CGRectX: self.view.frame.width/2, CGRectY: self.view.frame.height * 2/7, mainView: self, rgba: black, fontSize: originalFontSize)
        birthDayTextField = createUITextField(text: "", CGRectX: self.view.frame.width/2, CGRectY: self.view.frame.height * 3/7, mainView: self, rgba: black, fontSize: originalFontSize)
        addressTextField = createUITextField(text: "", CGRectX: self.view.frame.width/2, CGRectY: self.view.frame.height * 4/7, mainView: self, rgba: black, fontSize: originalFontSize)
        
        //ユーザー情報のtextFiledに描画する
        userNameTextField.text = userAuthInfo.userName
        birthDayTextField.text = userInfo.birthDay
        addressTextField.text  = userInfo.address
        
        //textfieldをdelegate委譲
        userNameTextField.delegate = self
        birthDayTextField.delegate = self
        addressTextField.delegate = self
        
        //birthdayFieldにUIDatePickerを使用できるようにする
        setupUIDatePicker()
        
        self.view.addSubview(userNameTextField)
        self.view.addSubview(birthDayTextField)
        self.view.addSubview(addressTextField)
    }
    
    //リターンキーを押すとキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //キーボードを閉じるタイミングでuserInfoとUserAuthINInfoにテキストフィールドのテキストを代入
        userAuthInfo.userName = userNameTextField.text ?? ""
        userInfo.address = addressTextField.text ?? ""
       // キーボードを閉じる
       textField.resignFirstResponder()
       //キーボードを閉じる際にtextDataへ入力値を渡す
       return true
    }
    
    //ナビゲーションバーの設定
    func setNavigationBar(title:String) {
        //safeAreaの高さを考慮する
        let navBar = createNavigationBar(safeAreaHeght: self.view.safeAreaInsets.top)
        let navItem = UINavigationItem(title: title)
        
        //buttonにアクションを埋め込む
        let backItem = UIBarButtonItem(title: "戻る", style: .plain, target: self, action: #selector(segueMainMenu))
        navItem.leftBarButtonItem = backItem
        
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
    }
    
    //前の画面に戻る
    @objc func segueMainMenu(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //ピッカービューの作成
    func setupUIDatePicker(){
        // ピッカー設定
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        // インプットビュー設定(紐づいているUITextfieldへ代入)
        birthDayTextField.inputView = datePicker
        birthDayTextField.inputAccessoryView = toolbar
    }
    
    // UIDatePickerのDoneを押したら発火
    @objc func done() {
        birthDayTextField.endEditing(true)

        // 日付のフォーマット
        let formatter = DateFormatter()

        //"yyyy年MM月dd日"を"yyyy/MM/dd"したりして出力の仕方を好きに変更できるよ
        formatter.dateFormat = "yyyy年MM月dd日"

        //(from: datePicker.date))を指定してあげることで
        //datePickerで指定した日付が表示される
        birthDayTextField.text = "\(formatter.string(from: datePicker.date))"
        
        //userInfoのアドレスをdatepickerと同じ値にする
        userInfo.birthDay =  birthDayTextField.text ?? ""

    }
    
    
    //firestoreからデータを取得し、userInfoとuserAuthInfoにデータを格納
    func getUserInfoFromFirestore(){
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.db.collection("users").document(String(user.uid)).getDocument { document, error in
                    if let err = error {
                        //エラーが発生した際の処理
                        print ("エラー: \(err)")
                    }else{
                        do{
                            let userData = try Firestore.Decoder().decode(UserInfo.self, from: document!.data()!)
                            //userInfoとuserAuthに取得したデータを渡す
                            self.userInfo = userData
                            self.userAuthInfo.userName = user.displayName ?? ""
                            self.userAuthInfo.userEamil = user.email ?? ""
                            
                            //テキストフィールドのセットアップ
                            self.setupTextFieldData()
                            
                        }catch let error as NSError{
                            print("エラー２:\(error)")
                        }
                    }
                }
            }
        }
    }
    
    //Firestoeに登録するためのボタンを生成
    func setupRegisterBtn(){
        let btn = createRegisterUIButton()
        btn.frame.size = CGSize(width: self.view.bounds.width * 1/3, height: 48)
        btn.center = CGPoint(x: self.view.bounds.width * 1/2, y: self.view.bounds.height * 6/7)
        self.view.addSubview(btn)
        btn.addTarget(self, action: #selector(changeProfileData), for: .touchUpInside)
    }
    
    //ボタンを押した時に登録する
    @objc func changeProfileData(){
        //userNameを変更
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = self.userAuthInfo.userName
        changeRequest?.commitChanges { error in
          print(self.userAuthInfo.userName)
          print(error)
        }
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                do{
                    //ユーザーデータを更新する
                    try self.db.collection("users").document(String(user.uid)).setData(from: self.userInfo)
                        showAlert(title: "更新完了", message: "プロフィールデータの更新が完了しました。", mainVC: self)
                }catch let error as NSError{
                    print(error)
                }
            }
        }
    }

}

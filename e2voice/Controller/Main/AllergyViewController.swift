import UIKit
import FirebaseAuth
import FirebaseFirestore

class AllergyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //アレルギーの画像
    let allergy = ["egg","milk","peanut","wheat","shrimp","crab","soba"]
    
    //Firestoreのインスタンス
    let db = Firestore.firestore()
    
    //ユーザー情報
    var userInfo = UserInfo()
    
    //コレクションビュー
    var collectionView:UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //コレクションビューの生成
        setupRegisterAllergy()
        
        //テキストの描画１
        createUILabel(text: "ご自身のアレルギーを", CGRectX: self.view.frame.width/2, CGRectY: self.view.frame.height * 1.2/7, mainView: self, rgba: black, fontSize: originalFontSize)
        
        //テキストの描画１
        createUILabel(text: "タップしてください", CGRectX: self.view.frame.width/2, CGRectY: self.view.frame.height * 1.8/7, mainView: self, rgba: black, fontSize: originalFontSize)
        
        //Firebaseから登録ユーザー情報を取得
        getUserInfo()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //navigationBarの生成
        setNavigationBar(title: "アレルギー登録")
    }
    
    
    //アレルギー登録用のレイアウトを構成
    func setupRegisterAllergy(){
        let flowLayout = createRegisterAllergyCollectionView(mainView: self)
        collectionView = createUICollectionView(CGRectX:0,CGRectY:self.view.frame.height/3,flowLayout: flowLayout, mainView: self)
        collectionView?.register(RegisterAllergyCollectionViewCell.self, forCellWithReuseIdentifier: "AllergyCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        self.view.addSubview(collectionView!)
    }
    
    //collectionViewの設定
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    //collectionViewの設定
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllergyCell", for: indexPath) as? RegisterAllergyCollectionViewCell
        cell?.layer.cornerRadius = 15
        
        //アレルギーがtrueならば、枠線をオレンジに変更する(通常はgray)
        if (checkAllergy(obj: userInfo, name: allergy[indexPath.row])){
            cell?.layer.borderWidth = 3
            cell?.layer.borderColor = orange.cgColor
        }else{
            cell?.layer.borderWidth = 1
            cell?.layer.borderColor = gray.cgColor
        }
        let image = UIImage(named: allergy[indexPath.row])
        cell?.setupContents(image: image!)
        return cell!
    }
    
    //タップされたcellのアクション
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //アレルギーがtrueならば、枠線をオレンジに変更する(通常はgray)
        if (allergy[indexPath.row] == "egg"){
            userInfo.egg = !userInfo.egg
        }else if (allergy[indexPath.row] == "milk"){
            userInfo.milk = !userInfo.milk
        }else if (allergy[indexPath.row] == "peanut"){
            userInfo.peanut = !userInfo.peanut
        }else if (allergy[indexPath.row] == "wheat"){
            userInfo.wheat = !userInfo.wheat
        }else if (allergy[indexPath.row] == "shrimp"){
            userInfo.shrimp = !userInfo.shrimp
        }else if (allergy[indexPath.row] == "crab"){
            userInfo.crab = !userInfo.crab
        }else if (allergy[indexPath.row] == "soba"){
            userInfo.soba = !userInfo.soba
        }
        self.collectionView?.reloadData()
    }
    
    //user内のアレルギー源をboolで返す
    func checkAllergy(obj:UserInfo,name:String) -> Bool{
        switch name {
            case "egg"    : return obj.egg
            case "milk"   : return obj.milk
            case "peanut" : return obj.peanut
            case "wheat"  : return obj.wheat
            case "shrimp" : return obj.shrimp
            case "crab"   : return obj.crab
            case "soba"   : return obj.soba
            default: return false
        }
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
    
    //Firestoreのユーザーデータを更新後に前の画面に戻る処理
    @objc func segueMainMenu(){
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                do{
                    //ユーザーデータを更新する
                    try self.db.collection("users").document(String(user.uid)).setData(from: self.userInfo)
                    self.dismiss(animated: true)
                }catch let error as NSError{
                    print(error)
                }
            }
        }
    }
    
    //Firebaseのuidを取得後、firestoreのユーザー情報をgetする
    func getUserInfo(){
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.db.collection("users").document(String(user.uid)).getDocument { document, error in
                    if let err = error {
                        //エラーが発生した際の処理
                        print ("エラー: \(err)")
                    }else{
                        do{
                            let userData = try Firestore.Decoder().decode(UserInfo.self, from: document!.data()!)
                            self.userInfo = userData
                            //ユーザー情報の更新が終わったらcollectionViewを再読み込み
                            self.collectionView?.reloadData()
                        }catch let error as NSError{
                            print(error)
                        }
                    }
                }
            }
        }
    }
    
    
}

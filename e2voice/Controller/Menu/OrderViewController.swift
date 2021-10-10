import UIKit

class OrderViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //Menuのインスタンス
    var menu:[Menu] = []
    let allergy = ["egg","milk","peanut","wheat","shrimp","crab","soba"]
    
    //userDefalutのデータ
    var purchaseData = UserDefault.loadFromUserDefalut()
    
    //purchaseのデータ
    var purchase = Purchase()
    
    
    //ユーザー情報の取得
    var userInfo:UserInfo?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //アレルギー警告メッセージ
        let alertAllergyMessage = allergyMessage(user : userInfo, menu : menu[0])
        
        //UIImageの描画
        setupUIImageView()
        //テキストの描画１
        createLeftUILabel(text: menu[0].title, CGRectX: self.view.frame.width/2, CGRectY: self.view.frame.height * 3.1/5, mainView: self, rgba: black, fontSize: originalFontSize)
        //テキストの描画2
        createRightUILabel(text: String(menu[0].price), CGRectX: self.view.frame.width/2, CGRectY: self.view.frame.height * 3.3/5, mainView: self, rgba: black, fontSize: originalFontSize)
        
        //アレルギー源の表示
        setupOrderCollectionView()
        
        //テキストの描画3
        createLeftUILabel(text: alertAllergyMessage, CGRectX: self.view.frame.width/2, CGRectY: self.view.frame.height * 4.1/5, mainView: self, rgba: black, fontSize: smallFontSize)
        
        //btnの作成
        setupPurchaseButton()
        
    }
    
    override func viewWillLayoutSubviews() {
        //ナビゲーションバーの描画
        setNavigationBar(title: "商品ページ")
    }

    
    //商品画像の設定
    func setupUIImageView(){
        let uiImageView = createUIImage(imgName: menu[0].imgName, mainView: self)
        uiImageView.center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2.9)
        self.view.addSubview(uiImageView)
    }
    
    //アレルギー源の表示
    func setupOrderCollectionView(){
        let flowLayout = createOrderUICollectionViewFlowLayout(mainView: self)
        let collectionView = createUICollectionView(CGRectX:0,CGRectY:self.view.frame.height * 3.6/5,flowLayout: flowLayout, mainView: self)
        collectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: "OrderCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderCell", for: indexPath)
        cell.layer.cornerRadius = 15
        //アレルギー源があれば枠線に色をつける
        if checkAllergy(obj: menu, name: allergy[indexPath.row]) {
            cell.layer.borderColor = orange.cgColor
            cell.layer.borderWidth = 2.0
        }else{
            cell.layer.borderColor = gray.cgColor
            cell.layer.borderWidth = 1.0
        }
        let img = UIImage(named:allergy[indexPath.row])
        let imgView = UIImageView(image: img)
        imgView.frame.size = CGSize(width:cell.contentView.frame.width,height:cell.contentView.frame.width)
        cell.contentView.addSubview(imgView)
        return cell
    }
    
    //menu内のアレルギー源をboolで返す
    func checkAllergy(obj:[Menu],name:String) -> Bool{
        switch name {
            case "egg"    : return obj[0].egg
            case "milk"   : return obj[0].milk
            case "peanut" : return obj[0].peanut
            case "wheat"  : return obj[0].wheat
            case "shrimp" : return obj[0].shrimp
            case "crab"   : return obj[0].crab
            case "soba"   : return obj[0].soba
            default: return false
        }
    }

    //アレルギーがある商品に注意書きを表示する
    func allergyMessage(user : UserInfo?, menu : Menu) -> String {
        if user?.crab == menu.crab && user?.crab == true { return "あなたのアレルギー対象の商品です"}
        if user?.soba == menu.soba && user?.soba == true { return "あなたのアレルギー対象の商品です"}
        if user?.egg == menu.egg && user?.egg == true { return "あなたのアレルギー対象の商品です"}
        if user?.milk == menu.milk && user?.milk == true { return "あなたのアレルギー対象の商品です"}
        if user?.peanut == menu.peanut && user?.peanut == true { return "あなたのアレルギー対象の商品です"}
        if user?.wheat == menu.wheat && user?.wheat == true { return "あなたのアレルギー対象の商品です"}
        if user?.shrimp == menu.shrimp && user?.shrimp == true { return "あなたのアレルギー対象の商品です"}
        return "あなたのアレルギー対象ではありません"
    }
    
    //購入ボタンのセットアップ
    func setupPurchaseButton(){
        let btn = createMenuUIButton()
        btn.frame.size = CGSize(width: self.view.frame.width/2, height: 48)
        btn.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height * 9.3/10)
        btn.addTarget(self, action: #selector(order), for: .touchUpInside)
        self.view.addSubview(btn)
    }
    
    //注文ボタンを押した時のアクション
    
    @objc func order(){
        self.askNumber(title: "購入数を入力", question: "いくつ購入しますか？", placeholder: "購入数を決める") { purchaseNumber in
            //購入数の入力値が0かnilではない場合に、userDefalutに購入データを保存する
            if let purchaseNumber = purchaseNumber {
                if purchaseNumber > 0 {
                    self.purchase.number = Int(purchaseNumber)
                    self.purchase.title  = self.menu[0].title
                    self.purchase.price  = self.menu[0].price
                    self.purchase.imgName = self.menu[0].imgName
                    
                    //purchaseDataの中に同一の商品があれば
                    if self.purchaseData.filter({ $0.title == self.purchase.title }).count > 0  {
                        for i in 0..<self.purchaseData.count {
                            if self.purchaseData[i].title == self.purchase.title {
                                self.purchaseData[i].number += self.purchase.number
                                break
                            }
                        }
                    }else{
                        self.purchaseData.append(self.purchase)
                    }
                    
                    print("😃")
                    print(self.purchaseData)
                    UserDefault.savePurchaseData(self.purchaseData)
                }
            }
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
    
    //前の画面に戻る処理
    @objc func segueMainMenu(){
        self.dismiss(animated: true, completion: nil)
    }
}

//購入ボタンを押した時の処理を継承
extension UIViewController {
    func ask(title: String?, question: String?, placeholder: String?, keyboardType: UIKeyboardType = .default, delegate: @escaping (_ answer: String?) -> Void) {
        let alert = UIAlertController(title: title, message: question, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = placeholder
            textField.keyboardType = keyboardType
        }
        alert.addAction(UIAlertAction(title: "購入", style: .default) { (_) in
            let answer = alert.textFields?.first?.text
            delegate(answer)
        })
        alert.addAction(UIAlertAction(title: "やめる", style: .cancel) { (_) in
            delegate(nil)
        })
        present(alert, animated: true, completion: nil)
    }
    
    func askNumber(title: String?, question: String?, placeholder: String?, delegate: @escaping (_ answer: Int?) -> Void) {
        self.ask(title: title, question: question, placeholder: placeholder, keyboardType: .numberPad) { (result) in
                if let result = result,
                   let iResult = Int(result) {
                    delegate(iResult)
                } else {
                    delegate(nil)
                }
            }
        }
}

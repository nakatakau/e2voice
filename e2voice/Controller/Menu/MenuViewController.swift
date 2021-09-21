import UIKit
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage

class MenuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    //Firestoreのインスタンスを作成
    let db = Firestore.firestore()
    
    //CollectionView
    var collectionView:UICollectionView?
    
    //Menuインスタンスを格納する配列
    var menus:[Menu] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //CollectionViewの描画
        self.setUpCollectionView()
        //FireStoreから呼び出し
        readMenuFromFireStore()
        
    }
    
    override func viewWillLayoutSubviews() {
        //navigationbarの設定
        setNavigationBar(title: "注文")
    }
    
    
    //CollectionViewの生成
    func setUpCollectionView() {
        let flowlayout = createMenuUICollectionViewFlowLayout(mainView: self)
        collectionView = createUICollectionView(CGRectX:0,CGRectY:70,flowLayout: flowlayout, mainView: self)
        collectionView?.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: "MenuCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        self.view.addSubview(collectionView!)
    }
    
    //セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //セルの数
        return menus.count
    }
    
    //セルの設定
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as? MenuCollectionViewCell
                
        //ボタンの生成
        let btn = createMenuUIButton()
        btn.tag = indexPath.row
        btn.frame.size = CGSize(width: (cell?.contentView.frame.width)! * 0.6, height: (cell?.contentView.frame.height)!/7)
        btn.center = CGPoint(x: (cell?.contentView.frame.width)!/2, y: (cell?.contentView.frame.height)!*0.9)
        //デリゲートメソッドを追加
        btn.addTarget(self, action: #selector(tapCellBtn(_:)), for: .touchUpInside)
        
        cell?.contentView.addSubview(btn)
        
        cell?.backgroundColor =  .white
        cell?.layer.cornerRadius = 10
        
        // セルの境界からはみ出ているものを見えるようにする
        cell?.layer.masksToBounds = false
        // 影をつける
        cell?.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell?.layer.shadowOpacity = 0.2
        cell?.layer.shadowRadius = 1.0
        
        let image = UIImage(named: self.menus[indexPath.row].imgName)!

        cell?.setupContents(textName: self.menus[indexPath.row].title, priceTag:self.menus[indexPath.row].price, image: image, number: indexPath.row)
        return cell!
    }
    
    
    //collectionViewBtnのタップ処理を行う
    @objc func tapCellBtn(_ sender: UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(identifier: "OrderView") as! OrderViewController
        nextVC.modalPresentationStyle = .fullScreen
        //既にあるデータは消す
        nextVC.menu.removeAll()
        nextVC.menu.append(menus[sender.tag])
        self.present(nextVC, animated: true, completion: nil)
    }
    
    
    //FireStoreからデータを取得する処理
    func readMenuFromFireStore(){
        db.collection("menu").getDocuments { (querySnapshot, error) in
            if let err = error {
                //エラーが発生した際の処理
                print ("エラー: \(err)")
            }else{
                for document in querySnapshot!.documents {
                    ////各DocumentからはDocumentIDとその中身のdataを取得できる
                    print("\(document.documentID) => \(document.data())")
                    
                    do {
                        let decodedTask = try Firestore.Decoder().decode(Menu.self, from: document.data())
                        //変換に成功
                        print("decodetask\(decodedTask)")
                        self.menus.append(decodedTask)
                    } catch let error as NSError{
                        print("エラー:\(error)")
                    }
                }
            }
            self.collectionView!.reloadData()
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
    
    @objc func segueMainMenu(){
        self.dismiss(animated: true, completion: nil)
    }
    
}


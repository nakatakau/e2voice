import UIKit
import Firebase
import FirebaseFirestoreSwift

class MenuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MenuCollectionViewCellBtnDelegate {
    
    //CollectionViewCellに描画する画像
    let imageName = ["lunch1","lunch1","lunch1","lunch1"]

    override func viewDidLoad() {
        super.viewDidLoad()
        //CollectionViewの設定
        setUpCollectionView()
    }
    
    override func viewWillLayoutSubviews() {
        //navigationbarの設定
        setNavigationBar(title: "注文")
    }
    
    //CollectionViewの生成
    func setUpCollectionView() {
        let flowlayout = createMenuUICollectionViewFlowLayout(mainView: self)
        let collectionView = createUICollectionView(CGRectX:0,CGRectY:70,flowLayout: flowlayout, mainView: self)
        collectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: "MenuCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
    }
    
    //セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //セルの数
        return 8
    }
    
    //セルの設定
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as? MenuCollectionViewCell
        
        //デリゲートの呼び出し
        cell?.menuCollectionViewCellBtnDelegate = self
        
        
        cell?.backgroundColor =  .white
        cell?.layer.cornerRadius = 10
        
        // セルの境界からはみ出ているものを見えるようにする
        cell?.layer.masksToBounds = false
        // 影をつける
        cell?.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell?.layer.shadowOpacity = 0.2
        cell?.layer.shadowRadius = 1.0
        
        let cellText = "aaa"
        let image = UIImage(named: imageName[indexPath.row % 4])!
        
        cell?.setupContents(textName: cellText, priceTag:1000, image: image)
        return cell!
    }
    
    
    //collectionViewBtnのタップ処理を行う
    func tapCellBtn() {
        let nextVC = self.storyboard?.instantiateViewController(identifier: "OrderView") as! OrderViewController
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
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


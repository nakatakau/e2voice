import UIKit

class OrderViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //Menuのインスタンス
    var menu:[Menu] = []
    let allergy = ["egg","milk","peanut","wheat","shrimp","crab","soba"]

    override func viewDidLoad() {
        super.viewDidLoad()
        //UIImageの描画
        setupUIImageView()
        //テキストの描画１
        createLeftUILabel(text: menu[0].title, CGRectX: self.view.frame.width/2, CGRectY: self.view.frame.height * 3.1/5, mainView: self, rgba: black, fontSize: originalFontSize)
        //テキストの描画2
        createRightUILabel(text: String(menu[0].price), CGRectX: self.view.frame.width/2, CGRectY: self.view.frame.height * 3.3/5, mainView: self, rgba: black, fontSize: originalFontSize)
        
        setupOrderCollectionView()
        
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

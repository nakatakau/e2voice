import UIKit

class PurchaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Purchaseのインスタンス
    var purchase:[Purchase] = UserDefault.loadFromUserDefalut()
    
    //UITableview
    var tableView : UITableView?
    
    //navigationBar
    var navBar : UINavigationBar?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillLayoutSubviews() {
        setNavigationBar(title:"購入")
        setupTabeleView()
    }
    
    //テーブルビューの設定
    func setupTabeleView() {
        tableView = createTableView(width: self.view.bounds.width, height: self.view.bounds.height * 0.8, x: 0, y: self.view.safeAreaInsets.top + (navBar?.frame.height)!)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(PurchaseTableViewCell.self, forCellReuseIdentifier: "cell")
//        tableView?.rowHeight = 100
        self.view.addSubview(tableView!)
    }
    
    //セルの数を決める
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchase.count
    }
    //セルの描画を決める
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PurchaseTableViewCell
        let img = UIImage(named: "lunch1")
        cell.setupContents(image: img!,title:"タイトル",purchaseNumber: "数量○個",price: "小計〇〇円")
        return cell
    }
    //セルの高さを決める
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.height * 0.16
    }
    
    //ナビゲーションバーの設定
    func setNavigationBar(title:String) {
        //safeAreaの高さを考慮する
        navBar = createNavigationBar(safeAreaHeght: self.view.safeAreaInsets.top)
        let navItem = UINavigationItem(title: title)
        
        //buttonにアクションを埋め込む
        let backItem = UIBarButtonItem(title: "戻る", style: .plain, target: self, action: #selector(segueMainMenu))
        navItem.leftBarButtonItem = backItem
        
        navBar?.setItems([navItem], animated: false)
        self.view.addSubview(navBar!)
    }
    
    //前の画面に戻る処理
    @objc func segueMainMenu(){
        self.dismiss(animated: true, completion: nil)
    }

    
}

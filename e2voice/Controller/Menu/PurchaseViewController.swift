import UIKit
import Firebase
import FirebaseFirestoreSwift

class PurchaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //FIrestoreのインスタンス
    let db = Firestore.firestore()
    
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
        tableView?.rowHeight =  self.view.bounds.height * 0.16
        self.view.addSubview(tableView!)
    }
    
    //セルの数を決める
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchase.count
    }
    
    //セルの描画を決める
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PurchaseTableViewCell
        let img:UIImage? = UIImage(named: purchase[indexPath.row].imgName)
        cell.setupContents(image: img,title:purchase[indexPath.row].title,purchaseNumber: "数量: \(purchase[indexPath.row].number)",price: "小計\(purchase[indexPath.row].price * purchase[indexPath.row].number)")
        return cell
    }
    
    //セルの高さを決める
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.height * 0.16
    }
    
    //セルをタップした時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ask2 {
            do {
                try self.db.collection("purchase").document().setData(from: self.purchase[indexPath.row])
                self.purchase.remove(at: indexPath.row)
                UserDefault.savePurchaseData(self.purchase)
                tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            }catch let error as NSError{
                print(error)
            }
        }
    }
    
    //セルの編集許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //スワイプしたセルを削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            purchase.remove(at: indexPath.row)
            UserDefault.savePurchaseData(purchase)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
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

//セルを押した時の処理を継承
extension UIViewController {
    func ask2(delegate: @escaping () -> Void) {
        let alert = UIAlertController(title: "確認", message: "こちらの商品を購入しますか？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "購入", style: .default) { (_) in
            delegate()
        })
        alert.addAction(UIAlertAction(title: "やめる", style: .cancel) { (_) in
            alert.dismiss(animated: true, completion: nil)
        })
        present(alert, animated: true, completion: nil)
    }
}


import UIKit
import FirebaseAuth
import Lottie

class MainMenuViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate  {

    //CollectionViewCellに描画するテキスト
    let cellText = ["注文","ユーザー情報","アレルギー","ログアウト"]
    //CollectionViewCellに描画する画像
    let imageName = ["food","house","allergy","logout"]
    
    //アニメーション
    var animationView:AnimationView? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //テキストの描画１
        createUILabel(text: "何をしますか？", CGRectX: self.view.frame.width/2, CGRectY: self.view.frame.height/7, mainView: self, rgba: black, fontSize: bigFontSize)
        
        //lottieアニメーションの描画
        doLottieAnimation(fileName:"MainMenuAnimation", CGRectX:view.frame.width/2, CGRectY:view.frame.height/3, mainView:self)
        
        //collectionViewの描画
        setUpCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //lottieアニメーションの描画
        animationView?.play()
    }
    
    //引数にlottieファイルを指定して、対象のUIViewControllerに描画する
    func doLottieAnimation (fileName:String, CGRectX:CGFloat, CGRectY:CGFloat, mainView:UIViewController){
        animationView = AnimationView(name: fileName)
        animationView?.frame.size = CGSize(width: mainView.view.bounds.width * 0.9, height: mainView.view.bounds.height * 0.9)
        animationView?.center = CGPoint(x: CGRectX, y: CGRectY)
        animationView?.loopMode = .loop
        animationView?.contentMode = .scaleAspectFit
        animationView?.animationSpeed = 1
        mainView.view.addSubview(animationView!)
        animationView?.play()
    }
    

    //CollectionViewの生成
    func setUpCollectionView() {
        let flowlayout = createUICollectionViewFlowLayout(mainView: self)
        let collectionView = createUICollectionView(CGRectX:0,CGRectY:self.view.frame.height/2.3,flowLayout: flowlayout, mainView: self)
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
    }
    
    //セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //セルの数
        return 4
    }
    
    //セルの描画
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? MainCollectionViewCell
        cell?.backgroundColor =  orange
        cell?.layer.cornerRadius = 10
        let cellText = cellText[indexPath.row]
        let image = UIImage(named: imageName[indexPath.row])!
        cell?.setupContents(textName: cellText, image: image)
        return cell!
    }
    
    //セルのアクション
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            segueMenuViewController()
        case 1:
            segueEditProfileViewController()
        case 2:
            segueAllergyViewController()
        case 3:
            signOut()
        default:
            print("None")
        }
    }
    
    //MenuViewControllerへ遷移
    func segueMenuViewController(){
        let nextVC = storyboard?.instantiateViewController(identifier: "MenuView") as! MenuViewController
        //fullScrenで表示
        nextVC.modalPresentationStyle = .fullScreen
        //遷移を実施
        self.present(nextVC, animated: true, completion: nil)
    }
    
    //EditProfileViewControllerへ遷移
    func segueEditProfileViewController(){
        let nextVC = storyboard?.instantiateViewController(identifier: "EditProfileView") as! EditProfileViewController
        //fullScrenで表示
        nextVC.modalPresentationStyle = .fullScreen
        //遷移を実施
        self.present(nextVC, animated: true, completion: nil)
    }
    
    //AllergyViewControllerへ遷移
    func segueAllergyViewController(){
        let nextVC = storyboard?.instantiateViewController(identifier: "AllergyView") as! AllergyViewController
        //fullScrenで表示
        nextVC.modalPresentationStyle = .fullScreen
        //遷移を実施
        self.present(nextVC, animated: true, completion: nil)
    }
    
    
    //ログアウト処理
    func signOut(){
        do{
            try Auth.auth().signOut()
            //サインアウトが成功したらログイン画面へ遷移
            let nextVC = storyboard?.instantiateViewController(identifier: "LoginView") as! LoginViewController
            //fullScrenで表示
            nextVC.modalPresentationStyle = .fullScreen
            //遷移を実施
            self.present(nextVC, animated: true, completion: nil)
        }catch let signOutError as NSError{
            print("サインアウトエラー : \(signOutError)")
        }
    }
    
    
}

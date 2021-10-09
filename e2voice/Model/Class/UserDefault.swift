import Foundation

class UserDefault {
    //UserDefaultsで使用するキー
    static let userDefaulyKey = "menu"
    
    //保存処理
    static func savePurchaseData (_ purchase : [Purchase]) {
        let encoder = JSONEncoder()
        do{
            let data = try encoder.encode(purchase)
            UserDefaults.standard.set(data,forKey: userDefaulyKey)
        }catch{
            print(error)
        }
    }
    
    //出力処理
    static func loadFromUserDefalut () -> [Purchase] {
        let decoder = JSONDecoder()
        do { //dataはnilの可能性があるので、アンラップする
            guard let data = UserDefaults.standard.data(forKey: userDefaulyKey) else {
            //nilの場合は、新規の配列を返す
            return []
        }
            //dataを[Task]型に変換
            let purchase = try decoder.decode([Purchase].self, from: data)
            //変換できたら値を返す
            return purchase
        } catch {
            //失敗したら新規の配列を返す
            return []
        }
    }
}

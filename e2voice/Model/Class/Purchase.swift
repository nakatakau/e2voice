import Foundation

//class Purchase : Codable{
//    var purchaseMenus:[Menu]
//    var purchaseNumber:[Int]
//
//    init(){
//        self.purchaseMenus = []
//        self.purchaseNumber = []
//    }
//}

struct Purchase : Codable{
    var title : String
    var price : Int
    var number : Int
    init(){
        self.title = ""
        self.price = 0
        self.number = 0
    }
}


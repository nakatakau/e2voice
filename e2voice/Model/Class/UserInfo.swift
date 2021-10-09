import Foundation

struct UserInfo :Codable {
    var address : String
    var birthDay    : String
    var crab   : Bool
    var egg    : Bool
    var milk   : Bool
    var peanut : Bool
    var shrimp : Bool
    var soba   : Bool
    var wheat  : Bool
    
    init(){
        self.address = ""
        self.birthDay = ""
        self.crab = false
        self.egg = false
        self.milk = false
        self.peanut = false
        self.shrimp = false
        self.soba = false
        self.wheat = false
    }
}


import Foundation

struct APIError:Codable{

    var statusCode:Int?
    var message:String?
    var error:String?
    var timestamp : String?
    var path : String?
    
}

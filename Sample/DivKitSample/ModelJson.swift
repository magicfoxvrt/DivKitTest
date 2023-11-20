import UIKit
import DivKit
import Serialization
import LayoutKit

struct DivJson1: Deserializable {
    public let templates: [String: Any]
    public let cards: [String: Any]
    
    public init(dictionary: [String: Any]) throws {
        templates = try! dictionary.getOptionalField("templates") ?? [:]
        cards = try! dictionary.getOptionalField("card") ?? [:]
    }
    
    static func loadCards() throws -> ([String: Any], [String: Any]) {
        let url = Bundle.main.url(forResource: "div_json", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let divJson = try DivJson1(JSONData: data)
        return (divJson.cards, divJson.templates)
    }
}

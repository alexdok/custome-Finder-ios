
import Foundation


protocol SaveManager {
    func save(_ link: String, count: Int)
    func loadCount(_ link: String) -> Int
    func saveSettingsList(arrayOfLabels: [String?], linkForNews: String)
    func loadSettingsList(linkForNews: String) -> [String?]
}

class SaveManagerImpl: SaveManager {
    static let shared = SaveManagerImpl()
    private init() {}
    
    func save(_ link: String, count: Int) {
        UserDefaults.standard.set(count, forKey: "\(link)")
    }
    
    func loadCount(_ link: String) -> Int {
      let count = UserDefaults.standard.integer(forKey: "\(link)")
        return count
    }
    
    func saveSettingsList(arrayOfLabels: [String?], linkForNews: String) {
        UserDefaults.standard.setValue(arrayOfLabels, forKey: linkForNews)
    }
    
    func loadSettingsList(linkForNews: String) -> [String?] {
        let array = UserDefaults.standard.value(forKey: linkForNews)
        return array as? [String?] ?? [""]
    }
}

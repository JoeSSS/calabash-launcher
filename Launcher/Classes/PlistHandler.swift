import Foundation

class PlistHandler {
    let plistPath: String
    let fileManager = FileManager.default
    
    public init(path: String = Constants.FilePaths.InternalResources.defaultPlist) {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as String
        plistPath = documentDirectory.appending(path)
        
        if let integratedSettingsPath = Bundle.main.path(forResource: "CalabashLauncherSettings", ofType: "plist"), !fileManager.fileExists(atPath: plistPath){
            self.copyFile(atPath: integratedSettingsPath, toPath: plistPath)
        }
    }
    
    func copyFile(atPath: String, toPath: String) {
        do {
            try fileManager.copyItem(atPath: atPath, toPath: toPath)
        }
        catch let error {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
    func removePlist() {
        try? fileManager.removeItem(atPath: plistPath)
    }
    
    func create(from dictionary: [String: Any]) {
        let someData = NSDictionary(dictionary: dictionary)
        someData.write(toFile: plistPath, atomically: true)
    }
    
    private func read(forKey key: String) -> [NSDictionary] {
        guard
            fileManager.fileExists(atPath: plistPath),
            let dictionary = NSDictionary(contentsOfFile: plistPath) else { return [] }

        return dictionary.mutableArrayValue(forKey: key).flatMap { element -> NSDictionary? in
            guard let dictionary = element as? NSDictionary else { return nil }
            return dictionary
        }
    }
    
    func readValues(forKey key: String) -> [String] {
        return read(forKey: key).flatMap { $0.allValues } as? [String] ?? []
    }
    
    func readKeys(forKey key: String) -> [String] {
        return read(forKey: key).flatMap { $0.allKeys } as? [String] ?? []
    }
}

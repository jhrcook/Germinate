import Foundation

/// The path to the JSON with the information from Jazzy.
let filePath = "docs/undocumented.json"
let url = URL(fileURLWithPath: filePath)


/// Structure to extract from the JSON.
struct UndocumentedFile: Codable {
    var file: String?
    var line: Int?
    var symbol: String?
    var symbolKind: String?
    var warning: String?
}

struct JazzyWarning: Codable {
    var warnings = [UndocumentedFile]()
    
    var fileNames: [String] {
        get {
            let allFileNames = warnings.map { $0.file! }
            return Array(Set(allFileNames))
        }
    }
    
    var linesForFiles: [String: [Int]] {
        get {
            var lff = [String: [Int]]()
            for fileName in fileNames {
                var lines = [Int]()
                for warning in warnings {
                    if warning.file == fileName {
                        lines.append(warning.line!)
                    }
                }
                lines.sort()
                lff[fileName] = lines
            }
            return lff
        }
    }
}


var jazzyWarning = JazzyWarning()

do {
    let data = try Data(contentsOf: url)
    let json = try JSONSerialization.jsonObject(with: data, options: [])
    if let dictionary = json as? [String: Any], let warningsArray = dictionary["warnings"] as? [Any] {
        for warningArray in warningsArray {
            if let warning = warningArray as? [String: Any] {
                jazzyWarning.warnings.append(UndocumentedFile(
                    file: warning["file"] as? String,
                    line: warning["line"] as? Int,
                    symbol: warning["symbol"] as? String,
                    symbolKind: warning["symbol_kind"] as? String,
                    warning: warning["warning"] as? String
                ))
            }
        }
    }
} catch {
    print(error)
}


if jazzyWarning.warnings.count == 0 {
    print("No undocumented objects.")
} else {
    print("-------\nThe following lines contain undocumented objects:\n")
    for file in jazzyWarning.linesForFiles.keys.sorted() {
        let fileName = (file as NSString).lastPathComponent
        print("  \(fileName): \(jazzyWarning.linesForFiles[file]!)")
    }
    print("-------")
}

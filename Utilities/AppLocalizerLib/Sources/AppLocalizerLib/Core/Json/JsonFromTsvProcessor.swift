//
//  JsonFromTsvProcessor.swift
//  AppLocalizerLib
//
//

import Foundation

/// JsonFromTsvProcessor updates an exsiting JSON structure from provided TSV data 
struct JsonFromTsvProcessor {
    
    //  Data
    var dozeInfo: DozeDetailInfo! /// Read in from "DozeDetailData.json" file
    var tweakInfo: TweakDetailInfo! /// Read in from "TweakDetailData.json" file
    // Paths
    let dozeJsonUrlIn: URL
    let dozeJsonUrlOut: URL
    let tweakJsonUrlIn: URL
    let tweakJsonUrlOut: URL
    // Processing Results
    var keysAppleJsonAll: Set<String>       // read from input JSON data
    var keysAppleJsonMatched: Set<String>   // results based on apple_key mapping
    var keysAppleJsonUnmatched: Set<String> // results based on apple_key mapping
    
    /// baseJsonDirUrl `English_US` json for keyword set.
    /// 
    /// - parameter: baseInDirUrl
    /// - parameter: 
    init(jsonBaseDir: URL, jsonOutputDir: URL) {
        keysAppleJsonAll = Set<String>()
        keysAppleJsonMatched = Set<String>()
        keysAppleJsonUnmatched = Set<String>()
        
        dozeJsonUrlIn = jsonBaseDir.appendingPathComponent("DozeDetailData.json")
        tweakJsonUrlIn = jsonBaseDir.appendingPathComponent("TweakDetailData.json")
        dozeJsonUrlOut = jsonOutputDir.appendingPathComponent("DozeDetailData.json")
        tweakJsonUrlOut = jsonOutputDir.appendingPathComponent("TweakDetailData.json")

        read(dozeJsonUrl: dozeJsonUrlIn, tweakJsonUrl: tweakJsonUrlIn)
        
        // All JSON Keys
        queryAllAppleJsonKeys()
        let keysExpectedString = keysAppleJsonAll.sorted().joined(separator: "\n")
        do {
            let url = jsonOutputDir
                .appendingPathComponent("keysAppleJsonAll_\(Date.datestampyyyyMMddHHmm).txt")
            try keysExpectedString.write(to: url, atomically: true, encoding: .utf8)
        } catch {
           print("JsonFromTsvProcessor init() writing expected keys. \(error)")
        }
    }
    
    init(xliffUrl: URL) {
        keysAppleJsonAll = Set<String>()
        keysAppleJsonMatched = Set<String>()
        keysAppleJsonUnmatched = Set<String>()
        
        let languageCode = xliffUrl
            .deletingPathExtension()
            .lastPathComponent
        let baseJsonUrl = xliffUrl
            .deletingLastPathComponent()
            .appendingPathComponent("DailyDozen")
            .appendingPathComponent("App")
            .appendingPathComponent("Texts")
            .appendingPathComponent("LocalStrings")
            .appendingPathComponent("\(languageCode).lproj")
        
        dozeJsonUrlIn = baseJsonUrl.appendingPathComponent("DozeDetailData.json")
        tweakJsonUrlIn = baseJsonUrl.appendingPathComponent("TweakDetailData.json")
        dozeJsonUrlOut = dozeJsonUrlIn.deletingPathExtension()
            .appendingPathExtension("_\(Date.datestampyyyyMMddHHmm).json")
        tweakJsonUrlOut = tweakJsonUrlIn.deletingPathExtension()
            .appendingPathExtension("_\(Date.datestampyyyyMMddHHmm).json")

        read(dozeJsonUrl: dozeJsonUrlIn, tweakJsonUrl: tweakJsonUrlIn)
        
        // All JSON Keys
        queryAllAppleJsonKeys()
        let keysExpectedString = keysAppleJsonAll.sorted().joined(separator: "\n")
        do {
            let url = xliffUrl
                .deletingLastPathComponent()
                .appendingPathComponent("keysAppleJsonAll_\(Date.datestampyyyyMMddHHmm).txt")
            try keysExpectedString.write(to: url, atomically: true, encoding: .utf8)
        } catch {
           print("JsonFromTsvProcessor init() writing expected keys. \(error)")
        }
    }

    mutating func read(dozeJsonUrl: URL, tweakJsonUrl: URL) {
        do {
            let decoder = JSONDecoder()
            let jsonDozeStr = try String(contentsOf: dozeJsonUrl, encoding: .utf8)
            let jsonDozeData = jsonDozeStr.data(using: .utf8)!
            dozeInfo = try decoder.decode(DozeDetailInfo.self, from: jsonDozeData)
            
            let jsonTweakStr = try String(contentsOf: tweakJsonUrl, encoding: .utf8)
            let jsonTweakData = jsonTweakStr.data(using: .utf8)!
            tweakInfo = try decoder.decode(TweakDetailInfo.self, from: jsonTweakData)
        } catch {            
            print("\(error)")
            fatalError()
        }
    }
    
    // Query all keys from data which has been read in from the JSON files. 
    mutating func queryAllAppleJsonKeys() {
        for entry in dozeInfo.itemsDict {
            let key = entry.key
            guard let dozeDetailInfo = dozeInfo.itemsDict[key] else { continue }
            
            keysAppleJsonAll.insert("\(key).heading")
            keysAppleJsonAll.insert("\(key).topic")
            for i in 0 ..< dozeDetailInfo.servings.count {
                keysAppleJsonAll.insert("\(key).Serving.Imperial.\(i)")                
                keysAppleJsonAll.insert("\(key).Serving.Metric.\(i)")                
            }
            for i in 0 ..< dozeDetailInfo.varieties.count {
                keysAppleJsonAll.insert("\(key).Variety.Text.\(i)")                
                keysAppleJsonAll.insert("\(key).Variety.Topic.\(i)")                
            }
        }
        
        for entry in tweakInfo.itemsDict {
            let key = entry.key
            guard let tweakDetailInfo = tweakInfo.itemsDict[key] else { continue }
            
            keysAppleJsonAll.insert("\(key).heading")
            keysAppleJsonAll.insert("\(key).topic")
            keysAppleJsonAll.insert("\(key).Activity.Imperial")                
            keysAppleJsonAll.insert("\(key).Activity.Metric")                
            for i in 0 ..< tweakDetailInfo.description.count {
                keysAppleJsonAll.insert("\(key).Description.\(i)")                
            }
        }
    }
    
    mutating func processTsvToJson(tsvSheet: TsvSheet) {  
        let lookupTable: [String: String] = tsvSheet.getLookupDictApple()
        for (key, value) in lookupTable {
            if key.hasPrefix("doze") {
                if processTsvToJsonDoze(key: key, value: value) {
                    keysAppleJsonMatched.insert(key)
                } else {
                    keysAppleJsonUnmatched.insert(key)
                }
            } else if key.hasPrefix("tweak") {
                if processTsvToJsonTweak(key: key, value: value) {
                    keysAppleJsonMatched.insert(key)
                } else {
                    keysAppleJsonUnmatched.insert(key)
                }
            } 
            // Note: all JSON related keys begin with either "doze" or "tweak".
        }        
    }
    
    private mutating func processTsvToJsonDoze(key: String, value: String) -> Bool {
        let parts = key.components(separatedBy: ".")
        
        let keyBase = parts[0]
        if dozeInfo.itemsDict[keyBase] != nil {
            if parts.count == 2 {
                switch parts[1] {
                case "heading":
                    // `dozeBeans`
                    dozeInfo.itemsDict[keyBase]?.heading = value
                    keysAppleJsonMatched.insert(key)
                    return true
                default:
                    return false
                }
            } else if parts.count == 4 {
                guard let idx = Int(parts[3]) else { return false }
                switch parts[1] {
                case "Serving":
                    switch parts[2] {
                    case "imperial":
                        // `dozeBeans.Serving.imperial.1`
                        dozeInfo.itemsDict[keyBase]?.servings[idx].imperial = value
                        keysAppleJsonMatched.insert(keyBase)
                        return true
                    case "metric":
                        // `dozeBeans.Serving.metric.1`
                        dozeInfo.itemsDict[keyBase]?.servings[idx].metric = value
                        keysAppleJsonMatched.insert(keyBase)
                        return true
                    default:
                        return false
                    }
                case "Variety":
                    switch parts[2] {
                    case "Text":
                        // dozeBerries.Variety.Text.5
                        dozeInfo.itemsDict[keyBase]?.varieties[idx].text = value
                        keysAppleJsonMatched.insert(keyBase)
                        return true                        
                    case "Topic":
                        // dozeBerries.Variety.Text.5
                        dozeInfo.itemsDict[keyBase]?.varieties[idx].topic = value
                        keysAppleJsonMatched.insert(keyBase)
                        return true                        
                    default:
                        return false
                    }
                default:
                    return false
                } 
            } 
        }
        
        return false
    }

    private mutating func processTsvToJsonTweak(key: String, value: String) -> Bool {
        let parts = key.components(separatedBy: ".")
        
        let keyBase = parts[0]
        if tweakInfo.itemsDict[keyBase] != nil {
            if parts.count == 2 {
                switch parts[1] {
                case "heading":
                    // `tweakDailyCumin.heading`
                    tweakInfo.itemsDict[parts[0]]?.heading = value
                    keysAppleJsonMatched.insert(keyBase)
                    return true
                case "short":
                    // `tweakDailyCumin.short`
                    tweakInfo.itemsDict[keyBase]?.activity.imperial = value
                    tweakInfo.itemsDict[keyBase]?.activity.metric = value
                    keysAppleJsonMatched.insert(keyBase)
                    return true
                case "text":
                    // `tweakDailyCumin.text`
                    tweakInfo.itemsDict[keyBase]?.description = [value]
                    keysAppleJsonMatched.insert(keyBase)
                    return true
                default:
                    return false
                } 
            } 
        }
        
        return false
    }
    
    func writeJsonFiles() {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = [.prettyPrinted]
        jsonEncoder.outputFormatting.insert(.sortedKeys)
        jsonEncoder.outputFormatting.insert(.withoutEscapingSlashes)
        
        var data = try! jsonEncoder.encode(dozeInfo)
        var string = String(data: data, encoding: .utf8)!
        try? string.write(to: dozeJsonUrlOut, atomically: true, encoding: .utf8)
        
        data = try! jsonEncoder.encode(tweakInfo)
        string = String(data: data, encoding: .utf8)!
        try? string.write(to: tweakJsonUrlOut, atomically: true, encoding: .utf8)
    }
        
}

//
//  BatchNormal.swift
//  
//

import Foundation

struct BatchNormal {
 
    static var shared = BatchNormal()
    
    /// normalizes `*.strings` only
    func doNormalize(sourceStrings: [URL], resultsDir: URL) {
        guard sourceStrings.count > 0, let stringsFirstUrl = sourceStrings.first else {
            print("ERROR: sourceStrings is an empty list")
            return
        }
        
        // to normalized *.strings files
        // …/App/InfoPlist/en.lproj/InfoPlist.strings"
        let langCode = stringsFirstUrl
            .deletingLastPathComponent() // *.strings
            .deletingPathExtension()     // .lproj
            .lastPathComponent           // en

        var stringz = StringzProcessor()
        for url in sourceStrings {
            stringz.parse(url: url)
        }
        let stringsDictionary = stringz.toStringSplitByFile(langCode: langCode)
                
        writeNormalStrings(stringsDictionary, langCode: langCode, resultsDir: resultsDir)
    }
    
    /// normalizes `*.tsv` and generates normalized `*.json`, `*.strings`, `*.xml`
    ///  
    /// - parameter sourceseTSV: …[…/Portuguese/tsv/Portuguese_pt.tsv] (example)
    /// - parameter topicsTSV: …/English_US/tsv/English_US_en.url_topics.tsv (example)
    /// - parameter resultsDir: …/_Normal__LOCAL/StringsViaTsvIntake example (example)
    /// - parameter inputJsonDir: …/English_US/ios/json/LocalStrings/en.lproj (example)
    /// - parameter inputXmlUrl: …/English_US/android/values/strings.xml (example)
    func doNormalize(
        sourceTSV: [URL], 
        topicsTSV: URL, 
        resultsDir: URL,
        baseJsonDir: URL,
        baseXmlUrl: URL
    ) {
        guard sourceTSV.count > 0, let tsvFirstUrl = sourceTSV.first else {
            print("ERROR: BatchNormal.doNormalize(…) sourceTSV is an empty list")
            return
        }
        
        // -- to TSV --
        let tsvSheet = TsvSheet(urlList: sourceTSV)
        
        // -- to /Localizable.strings --
        let nameParts = getTsvFilenameParts(tsvFirstUrl)
        let langCode = nameParts.lang
        let modifier = nameParts.modifier

        let stringz = StringzProcessor(tsvRowList: tsvSheet.tsvRowList)
        let stringsDictionary = stringz.toStringSplitByFile(langCode: langCode)
        
        writeNormalStrings(stringsDictionary, langCode: langCode, modifier: modifier, resultsDir: resultsDir)

        // write out updated *.tsv file
        writeNormalTsv(tsvSheet, urlTsvIn: tsvFirstUrl, resultsDir: resultsDir)
        
        // -- to JSON --
        // add url topic links
        let allTSV: [URL] = sourceTSV + [topicsTSV]
        let tsvSheetWithTopics = TsvSheet(urlList: allTSV)
        
        let jsonOutputDir = resultsDir
            .appendingPathComponent("Localizable")
            .appendingPathComponent("\(langCode).lproj", isDirectory: true)
        var jsonFromTsv = JsonFromTsvProcessor(
            jsonBaseDir: baseJsonDir, 
            jsonOutputDir: jsonOutputDir)
        jsonFromTsv.processTsvToJson(tsvSheet: tsvSheetWithTopics)
        jsonFromTsv.writeJsonFiles()
        
        // to XML
        let valuesPathFragment = langCode == "en" ? "values" : "values-\(langCode)"
        let xmlOutputUrl = resultsDir
            .appendingPathComponent("android")
            .appendingPathComponent(valuesPathFragment)
            .appendingPathComponent("strings.xml", isDirectory: false)
        let droidLookup = tsvSheetWithTopics.getLookupDictAndroid()
        var xmlFromTsv = XmlFromTsvProcessor(lookupTable: droidLookup)
        guard let droidXmlDocument = try? XMLDocument(contentsOf: baseXmlUrl, options: [.nodePreserveAll, .nodePreserveWhitespace]) 
        else {
            print("ERROR:doNormalize: baseXmlUrl not found \(baseXmlUrl.path)")
            return
        }
        xmlFromTsv.processXmlFromTsv(
            droidXmlOutputUrl: xmlOutputUrl, 
            droidXmlDocument: droidXmlDocument
        )
    }
    
    private func getTsvFilenameParts(_ url: URL) -> (lang: String, modifier: String, name: String) {
        // Pattern: FILE_NAME_LANG-REGION.modifier.modifier.tsv
        // Examples:
        //     Spanish_es.20210309.Apple.20210629_1639.tsv
        //     Chinese_Traditional_zh-Hant.appstore.20201028.tsv
        var langStr = ""
        var modifierStr = ""
        var nameStr = ""
        
        let basename = url
            .deletingPathExtension() // .tsv
            .lastPathComponent
        
        let dotParts = basename.components(separatedBy: ".")
        for i in 1 ..< dotParts.count {
            modifierStr.append(".\(dotParts[i])")
        }

        var underscoreParts = dotParts[0].components(separatedBy: "_")
        langStr = underscoreParts.removeLast()
        nameStr = underscoreParts.joined(separator: "_")
        
        return (langStr, modifierStr, nameStr)
    }
    
    /// XLIFF to normalized `*.strings` file
    /// 
    /// Note: input `en.xliff` has output `en.normal.strings`
    func doNormalize(sourceXLIFF: URL, resultsDir: URL) {
        // to TSV
        let xliff = XliffIntoTsvProcessor(url: sourceXLIFF)
        
        // to normalized *.strings files
        let langCode = sourceXLIFF
            .deletingPathExtension() // .xliff
            .lastPathComponent       // en
        
        let stringz = StringzProcessor(tsvRowList: xliff.tsvRowList)
        let stringsDictionary = stringz.toStringSplitByFile(langCode: langCode)
        
        writeNormalStrings(stringsDictionary, langCode: langCode, resultsDir: resultsDir)
    }
    
    private func writeNormalStrings(
        _ stringsDictionary: [StringzProcessor.SplitFile : String], 
        langCode: String,
        modifier: String = "", 
        resultsDir: URL) {
        for (key, content) in stringsDictionary {
            let outputDirUrl = resultsDir
                .appendingPathComponent(key.name)
                .appendingPathComponent("\(langCode).lproj", isDirectory: true)
            let outputFileUrl = outputDirUrl
                .appendingPathComponent("\(key.name)\(modifier).strings", isDirectory: false)
            
            do {
                try FileManager.default.createDirectory(
                    at: outputDirUrl,
                    withIntermediateDirectories: true, 
                    attributes: nil)
                try content.write(to: outputFileUrl, atomically: false, encoding: .utf8)
            } catch {
                print("ERROR: failed to write \(outputFileUrl.path) \(error)")
            }
        }
    }
    
    private func writeNormalTsv(_ tsvSheet: TsvSheet, urlTsvIn: URL, resultsDir: URL) {
        let tsvFilename = urlTsvIn.lastPathComponent
        let tsvLangName = urlTsvIn
            .deletingLastPathComponent() // filename.tsv
            .deletingLastPathComponent() // tsv
            .lastPathComponent           // language name e.g. English_US
        let outputTsvDirUrl = resultsDir
            .appendingPathComponent("Languages_tsv_normal")
            .appendingPathComponent(tsvLangName)
            .appendingPathComponent("tsv")
        let outputTsvFileUrl = outputTsvDirUrl
            .appendingPathComponent(tsvFilename, isDirectory: false)
        do {
            try FileManager.default.createDirectory(
                at: outputTsvDirUrl,
                withIntermediateDirectories: true, 
                attributes: nil)
            tsvSheet.writeTsvFile(fullUrl: outputTsvFileUrl)            
        } catch {
            print("ERROR: failed to write \(outputTsvFileUrl.path) \(error)")
        }
    }
    
}

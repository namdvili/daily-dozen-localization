//
//  BatchNormal.swift
//  
//

import Foundation

struct BatchNormal {
 
    static var shared = BatchNormal()
    
    // 
    func doNormalize(sourceStrings: [URL], dir: URL) {
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
                
        writeNormalStrings(stringsDictionary, langCode: langCode, dir: dir)
    }
    
    func doNormalize(sourceTSV: [URL], dir: URL) {
        guard sourceTSV.count > 0, let tsvFirstUrl = sourceTSV.first else {
            print("ERROR: BatchNormal.doNormalize(…) sourceTSV is an empty list")
            return
        }
        
        // to TSV
        let tsvSheet = TsvSheet(urlList: sourceTSV)
        
        // to /Localizable.strings file
        let nameParts = getTsvFilenameParts(tsvFirstUrl)
        let langCode = nameParts.lang
        let modifier = nameParts.modifier

        let stringz = StringzProcessor(tsvRowList: tsvSheet.tsvRowList)
        let stringsDictionary = stringz.toStringSplitByFile(langCode: langCode)
        
        writeNormalStrings(stringsDictionary, langCode: langCode, modifier: modifier, dir: dir)

        // write out updated *.tsv file
        writeNormalTsv(tsvSheet, urlTsvIn: tsvFirstUrl, uslDirOut: dir)        
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
    func doNormalize(sourceXLIFF: URL, dir: URL) {
        // to TSV
        let xliff = XliffIntoTsvProcessor(url: sourceXLIFF)
        
        // to normalized *.strings files
        let langCode = sourceXLIFF
            .deletingPathExtension() // .xliff
            .lastPathComponent       // en
        
        let stringz = StringzProcessor(tsvRowList: xliff.tsvRowList)
        let stringsDictionary = stringz.toStringSplitByFile(langCode: langCode)
        
        writeNormalStrings(stringsDictionary, langCode: langCode, dir: dir)
    }
    
    private func writeNormalStrings(
        _ stringsDictionary: [StringzProcessor.SplitFile : String], 
        langCode: String,
        modifier: String = "", 
        dir: URL) {
        for (key, content) in stringsDictionary {
            let outputDirUrl = dir
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
    
    private func writeNormalTsv(_ tsvSheet: TsvSheet, urlTsvIn: URL, uslDirOut: URL) {
        let tsvFilename = urlTsvIn.lastPathComponent
        let tsvLangName = urlTsvIn
            .deletingLastPathComponent() // filename.tsv
            .deletingLastPathComponent() // tsv
            .lastPathComponent           // language name e.g. English_US
        let outputTsvDirUrl = uslDirOut
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

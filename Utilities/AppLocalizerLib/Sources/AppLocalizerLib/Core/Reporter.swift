//
//  Reporter.swift
//  AppLocalizerLib
//

import Foundation

struct Reporter {
    
    static var shared = Reporter()
    //
    var inactiveAppleDict: [String: String] // key : reason
    var inactiveDroidDict: [String: String] // key : reason
    
    init() {
        inactiveAppleDict = [String: String]()
        inactiveAppleDict["ERa-UT-Rni.text"] = "DozeEntryLayout '0 / 24' programmatically set"
        inactiveAppleDict["pYb-py-Qqh.text"] = "DozeEntryPagerLayout 'Today' programmatically set"
        inactiveAppleDict["qWl-8e-sO6.text"] = "DozeEntryLayout 'DozeItemHeadingLabel' prototype cell, programmatically set"
        inactiveAppleDict["yct-Iw-M3s.text"] = "DozeDetailLayout dozeDetailSizeCell 'Title Label'  programmatically set"
        inactiveAppleDict["m5s-0r-St1.text"] = "DozeDetailLayout dozeDetailTypeCell 'Title Label' programmatically set"
        inactiveAppleDict["iJb-Vn-TS0.text"] = "DozeDetailLayout 'Title Label' programmatically set"
        inactiveAppleDict["dld-jq-Etq.text"] = "DozeHistoryLayout '2017'  programmatically set"

        inactiveAppleDict["6m3-hV-PBi.text"] = "TweakDetailLayout 'Title Label' programmatically set"
        inactiveAppleDict["5eb-qC-Ke5.text"] = "TweakHistoryLayout '2017' programmatically set"
        inactiveAppleDict["7XY-Lo-Hwf.normalTitle"] = "TweakEntryPagerLayout `tweakBackButton` uses `dateBackButtonTitle`"
        inactiveAppleDict["OFE-S4-S9b.text"] = "TweakDetailLayout ActivityCell 'Title Label' programmatically set"
        inactiveAppleDict["Qfe-bW-SP4.normalTitle"] = "DozeEntryPagerLayout `dozeBackButton` uses `dateBackButtonTitle`"
        inactiveAppleDict["YGb-Uj-J69.text"] = "TweakEntryLayout 'TweakItemHeadingLabel' prototype cell, programmatically set"
        inactiveAppleDict["YWB-e7-bAF.text"] = "TweakEntryPagerLayout 'Today' programmatically set"
        inactiveAppleDict["Zgt-w4-qQw.text"] = "InfoMenuAbout '…app created by…' manual edit?"
        inactiveAppleDict["dxC-TB-3hz.text"] = "TweakDetailLayout DescriptionCell 'Title Label' programmatically set"

        inactiveAppleDict["FTS-2y-Iil.text"] = "WeightHistoryLayout '2017' programmatically set"
        inactiveAppleDict["OIQ-oh-3QN.normalTitle"] = "WeightEntryPagerLayout `weightBackButton` uses `dateBackButtonTitle`"
        inactiveAppleDict["pKR-lY-XXM.text"] = "WeightEntryPagerLayout 'Today' programmatically set"
        inactiveAppleDict["zV0-lA-zHj.text"] = "WeightEntryLayout 'lbs' ???"

        inactiveAppleDict["pUm-f4-zm1.text"] = "InfoMenuAboutLayout '…open source libraries…' manual edit?"
        
        // Superceded random values
        
        // Daily Reminder (alert title, settings section heading)
        inactiveAppleDict["GiY-ao-2ee.headerTitle"] = "superceded by reminder.heading"
        /* Enable Reminders (toggle switch label) */
        inactiveAppleDict["pjz-An-Ls5.text"] = "superceded by reminder.settings.enable"
        inactiveAppleDict["itH-G7-Kal.text"] = "superceded by reminder.settings.enable"
        inactiveAppleDict["kR3-Sa-Fpt.text"] = "superceded by reminder.settings.time"
        inactiveAppleDict["YP6-dP-Y62.text"] = "superceded by reminder.settings.sound"
        inactiveAppleDict["XFw-2q-BdT.text"] = "superceded by reminder.state.on"
        
        inactiveAppleDict["IFs-g0-SPV.headerTitle"] = "superceded by setting_units_header"
        inactiveAppleDict["WdR-XV-IyP.headerTitle"] = "superceded by setting_tweak_header"

        inactiveAppleDict["cW5-dD-Zy0.text"] = "superceded by format_num_days %d days" 
        inactiveAppleDict["Vbn-R9-kuu.text"] = "superceded by format_num_days %d days"
        
        inactiveAppleDict["nRL-iG-Wnd.text"] = "month (pager, doze) programatically set" 
        inactiveAppleDict["UCg-Rc-mLf.text"] = "month (pager, doze) programatically set"
        inactiveAppleDict["lTR-i5-Tn0.text"] = "month (pager, doze) programatically set"
        
        // Not currently in use
        inactiveAppleDict["otherOmega3.heading"] = "not currently in use" 
        inactiveAppleDict["otherVitaminD.headin"] = "not currently in use" 
                
        // ---- Special Case: URL mappings
        // Apple URLs
        inactiveAppleDict["urlSegment.base"] = "Special case: url mappings"
        inactiveAppleDict["urlSegment.lang"] = "Special case: url mappings"
        inactiveAppleDict["urlSegmentInfoMenu.book"] = "Special case: url mappings"
        inactiveAppleDict["urlSegmentInfoMenu.challenge"] = "Special case: url mappings"
        inactiveAppleDict["urlSegmentInfoMenu.cookbook"] = "Special case: url mappings"
        inactiveAppleDict["urlSegmentInfoMenu.diet"] = "Special case: url mappings"
        inactiveAppleDict["urlSegmentInfoMenu.donate"] = "Special case: url mappings"
        inactiveAppleDict["urlSegmentInfoMenu.source"] = "Special case: url mappings"
        inactiveAppleDict["urlSegmentInfoMenu.subscribe"] = "Special case: url mappings"
        inactiveAppleDict["urlSegmentInfoMenu.team"] = "Special case: url mappings"
        inactiveAppleDict["urlSegmentInfoMenu.videos"] = "Special case: url mappings"
        // Android URLs
        inactiveAppleDict["urlSegment.base"] = "Special case: url mappings"
        inactiveAppleDict["url_cookbook"] = "Special case: url mappings"
        inactiveAppleDict["url_daily_dozen_challenge"] = "Special case: url mappings"
        inactiveAppleDict["url_donate"] = "Special case: url mappings"
        inactiveAppleDict["url_how_not_to_die"] = "Special case: url mappings"
        inactiveAppleDict["url_how_not_to_diet"] = "Special case: url mappings"
        inactiveAppleDict["url_latest_videos"] = "Special case: url mappings"
        inactiveAppleDict["url_open_source"] = "Special case: url mappings"
        inactiveAppleDict["url_subscribe"] = "Special case: url mappings"
        
        // ======================================
        inactiveDroidDict = [String: String]()
    }
    
    func writeReport(batchImport: BatchImport,
              datestamp: String = Date.datestampyyyyMMddHHmm,
              verbose: Bool = false) {
        let verboseTag = verbose ? "_verbose" : ""
        guard let url = batchImport._tsvImportSheet.urlLanguage?
            .appendingPathComponent("Report_\(datestamp)\(verboseTag).txt")
        else {
            fatalError("writeReport(batchImport:datestamp) _tsvImportSheet.urlLanguage in nil")
        }
        
        let s = reportString(batchImport: batchImport, datestamp: datestamp, verbose: verbose)
        try? s.write(to: url, atomically: true, encoding: .utf8)
    }
    
    func reportString(batchImport: BatchImport,
                      datestamp: String = Date.datestampyyyyMMddHHmm,
                      verbose: Bool = false) -> String {
        
        var s = "Report: \(datestamp)\n"
        s.append("\n")
        s.append("###########################\n")
        s.append("## TSV STANDALONE CHECKS ##\n")
        s.append("###########################\n")
        s.append("\n")
        s.append("********************************\n")
        s.append("** TSV: Target Language Empty **\n")
        s.append("********************************\n")
        
        let missing = batchImport._tsvImportSheet.checkTsvKeysTargetValueMissing()
        for r in missing {
            s.append("\(r.key_android)\t\(r.key_apple)\t\(r.base_value)\t\(r.lang_value)\n")
        }
        
        s.append("\n")
        s.append("*******************************************\n")
        s.append("** TSV: Target Language == Base Language **\n")
        s.append("*******************************************\n")
        let unchanged = batchImport._tsvImportSheet.checkTsvKeysTargetValueSameAsBase()        
        for r in unchanged {
            s.append("\(r.key_android)\t\(r.key_apple)\t\(r.base_value)\t\(r.lang_value)\n")
        }
        
        if let processor = batchImport._xmlProcessor {
            s.append("\n")
            s.append("####################\n")
            s.append("## ANDROID CHECKS ##\n")
            s.append("####################\n")
            s.append("\n")
            s.append("********************************************\n")
            s.append("** TSV: Android Key Unmatched (key_droid) **\n")
            s.append("********************************************\n")
            let unusedDroid = batchImport._tsvImportSheet.checkTsvKeysNotused(platformKeysUsed: processor.keysDroidXmlMatched, platform: .android)
            s.append(unusedDroid.sorted().joined(separator: "\n"))
            s.append("\n\n")
            s.append("********************************\n")
            s.append("** Android XML Keys UnMatched **\n")
            s.append("********************************\n")
            let unmatchedXmlKeys = processor.keysDroidXmlUnmatched.sorted()
            s.append(unmatchedXmlKeys.joined(separator: "\n"))
            if verbose {
                s.append("\n\n")
                s.append("******************************\n")
                s.append("** Android XML Keys Matched **\n")
                s.append("******************************\n")
                let matchedXmlKeys = processor.keysDroidXmlMatched.sorted()
                s.append(matchedXmlKeys.joined(separator: "\n"))
            }
        }
        
        if let xliffProcessor = batchImport._xliffProcessor, let jsonprocessor = batchImport._jsonProcessor {
            s.append("\n\n")
            s.append("##################\n")
            s.append("## APPLE CHECKS ##\n")
            s.append("##################\n")
            s.append("\n")
            s.append("******************************************\n")
            s.append("** TSV: Apple Key Unmatched (key_apple) **\n")
            s.append("******************************************\n")
            let usedKeys = xliffProcessor
                .keysAppleXliffMatched
                .union(jsonprocessor.keysAppleJsonMatched)
            let unusedApple = batchImport._tsvImportSheet.checkTsvKeysNotused(platformKeysUsed: usedKeys, platform: .apple)
            let unusedAppleRandomStated = String.randomStatedJoinedStrings(list: unusedApple.sorted())
            s.append("\(unusedAppleRandomStated.stated)\n")
            s.append("----- RANDOM KEYS: TSV Unused -----\n")
            s.append("\(unusedAppleRandomStated.random)\n")
            s.append("\n\n")
            s.append("*******************************\n")
            s.append("** Apple JSON Keys UnMatched **\n")
            s.append("*******************************\n")
            let unmatchedJsonKeys = jsonprocessor.keysAppleJsonUnmatched.sorted()
            s.append(unmatchedJsonKeys.joined(separator: "\n"))
            s.append("\n\n")
            s.append("********************************\n")
            s.append("** Apple XLIFF Keys UnMatched **\n")
            s.append("********************************\n")
            let inactiveAppleKeys = Set<String>(inactiveAppleDict.keys)
            let unmatchedXliffKeys = xliffProcessor.keysAppleXliffUnmatched
                .subtracting(inactiveAppleKeys)
                .sorted()
            let unmatchedXliffRandomStated = String.randomStatedJoinedStrings(list: unmatchedXliffKeys)
            s.append("\(unmatchedXliffRandomStated.stated)\n")
            s.append("----- RANDOM KEYS: XLIFF Unmatched -----\n")
            s.append("\(unmatchedXliffRandomStated.random)\n")
            s.append("\n\n")
            s.append("**************************************\n")
            s.append("** Apple XLIFF Keys Marked Inactive **\n")
            s.append("**************************************\n")
            let inactiveAppleKeysInXliff = inactiveAppleKeys
                .intersection(xliffProcessor.keysAppleXliffAll)
                .sorted()
            for key in inactiveAppleKeysInXliff {
                s.append("\(key) : \(inactiveAppleDict[key] ?? "DESCRIPTION_NOT_FOUND")\n")
            }

            if verbose {
                s.append("\n\n")
                s.append("*****************************\n")
                s.append("** Apple JSON Keys Matched **\n")
                s.append("*****************************\n")
                let matchedJsonKeys = jsonprocessor.keysAppleJsonMatched.sorted()
                s.append(matchedJsonKeys.joined(separator: "\n"))
                s.append("\n\n")
                s.append("******************************\n")
                s.append("** Apple XLIFF Keys Matched **\n")
                s.append("******************************\n")
                let matchedXliffKeys = xliffProcessor.keysAppleXliffMatched.sorted()
                let matchedXliffRandomStated = String.randomStatedJoinedStrings(list: matchedXliffKeys)
                s.append("\(matchedXliffRandomStated.stated)\n")
                s.append("----- RANDOM KEYS: XLIFF Matched -----\n")
                s.append("\(matchedXliffRandomStated.random)\n")
                s.append("\n\n")
            }
        }
        
        return s
    }
    
}

//
//  SettingData.swift
//  012-NotificationTimer
//
//  Created by Takatoshi Miura on 2020/09/02.
//  Copyright © 2020 Takatoshi Miura. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class SettingData: NSObject, NSSecureCoding {
    
    //MARK:- 保持データ
    
    var dataNumber:Int = 0              // データ番号
    //var backgroundImage:UIImage?    // 背景画像
    var count:Float = 0.0               // 設定時間
    var mannerMode:Bool = false         // マナーモード（true:ON / false:OFF）
    var audioFinish:String = ""         // 終了時通知用 音声ファイル名
    var audioElapsed5min:String = ""    // 5分経過通知用 音声ファイル名
    var audioElapsed10min:String = ""   // 10分経過通知用 音声ファイル名
    var audioElapsed15min:String = ""   // 15分経過通知用 音声ファイル名
    var audioElapsed20min:String = ""   // 20分経過通知用 音声ファイル名
    var audioElapsed25min:String = ""   // 25分経過通知用 音声ファイル名
    var audioElapsed30min:String = ""   // 30分経過通知用 音声ファイル名
    var audioElapsed35min:String = ""   // 35分経過通知用 音声ファイル名
    var audioElapsed40min:String = ""   // 40分経過通知用 音声ファイル名
    var audioElapsed45min:String = ""   // 45分経過通知用 音声ファイル名
    var audioElapsed50min:String = ""   // 50分経過通知用 音声ファイル名
    var audioRemaining30sec:String = "" // 残り30秒通知用 音声ファイル名
    var audioRemaining1min:String = ""  // 残り1分通知用 音声ファイル名
    var audioRemaining3min:String = ""  // 残り3分通知用 音声ファイル名
    var audioAppStartUp:String = ""     // アプリ起動音 音声ファイル名
    var audioAppFinish:String = ""      // アプリ終了音 音声ファイル名
    
    
    
    //MARK:- イニシャライザ
    
    init(dataNumber num:Int) {
        self.dataNumber = num
    }
    
    
    
    //MARK:- セッター
    
    func setDataNumber(number:Int) {
        self.dataNumber = number
    }
    
//    func setBackgroundImage(image:UIImage) {
//        self.backgroundImage = image
//    }
    
    func setCount(time:Float) {
        self.count = time
    }
    
    func setMannerMode(bool:Bool) {
        self.mannerMode = bool
    }
    
    func setAudioFinish(fileName:String) {
        self.audioFinish = fileName
    }
    
    func setAudioElapsed5min(fileName:String) {
        self.audioElapsed5min = fileName
    }
    
    func setAudioElapsed10min(fileName:String) {
        self.audioElapsed10min = fileName
    }
    
    func setAudioElapsed15min(fileName:String) {
        self.audioElapsed15min = fileName
    }
    
    func setAudioElapsed20min(fileName:String) {
        self.audioElapsed20min = fileName
    }
    
    func setAudioElapsed25min(fileName:String) {
        self.audioElapsed25min = fileName
    }
    
    func setAudioElapsed30min(fileName:String) {
        self.audioElapsed30min = fileName
    }
    
    func setAudioElapsed35min(fileName:String) {
        self.audioElapsed35min = fileName
    }
    
    func setAudioElapsed40min(fileName:String) {
        self.audioElapsed40min = fileName
    }
    
    func setAudioElapsed45min(fileName:String) {
        self.audioElapsed45min = fileName
    }
    
    func setAudioElapsed50min(fileName:String) {
        self.audioElapsed50min = fileName
    }
    
    func setAudioRemaining30sec(fileName:String) {
        self.audioRemaining30sec = fileName
    }
    
    func setAudioRemaining1min(fileName:String) {
        self.audioRemaining1min = fileName
    }
    
    func setAudioRemaining3min(fileName:String) {
        self.audioRemaining3min = fileName
    }
    
    func setAudioAppStartUp(fileName:String) {
        self.audioAppStartUp = fileName
    }
    
    func setAudioAppFinish(fileName:String) {
        self.audioAppFinish = fileName
    }
    
    
    
    //MARK:- ゲッター
    
    func getDataNumber() -> Int {
        return self.dataNumber
    }
    
//    func getBackgroundImage() -> UIImage? {
//        return self.backgroundImage
//    }
    
    func getCount() -> Float {
        return self.count
    }
    
    func getMannerMode() -> Bool {
        return self.mannerMode
    }
    
    func getAudioFinish() -> String? {
        return self.audioFinish
    }
    
    func getAudioElapsed5min() -> String? {
        return self.audioElapsed5min
    }
    
    func getAudioElapsed10min() -> String? {
        return self.audioElapsed10min
    }
    
    func getAudioElapsed15min() -> String? {
        return self.audioElapsed15min
    }
    
    func getAudioElapsed20min() -> String? {
        return self.audioElapsed20min
    }
    
    func getAudioElapsed25min() -> String? {
        return self.audioElapsed25min
    }
    
    func getAudioElapsed30min() -> String? {
        return self.audioElapsed30min
    }
    
    func getAudioElapsed35min() -> String? {
        return self.audioElapsed35min
    }
    
    func getAudioElapsed40min() -> String? {
        return self.audioElapsed40min
    }
    
    func getAudioElapsed45min() -> String? {
        return self.audioElapsed45min
    }
    
    func getAudioElapsed50min() -> String? {
        return self.audioElapsed50min
    }
    
    func getAudioRemaining30sec() -> String? {
        return self.audioRemaining30sec
    }
    
    func getAudioRemaining1min() -> String? {
        return self.audioRemaining1min
    }
    
    func getAudioRemaining3min() -> String? {
        return self.audioRemaining3min
    }
    
    func getAudioAppStartUp() -> String? {
        return self.audioAppStartUp
    }
    
    func getAudioAppFinish() -> String? {
        return self.audioAppFinish
    }
    
    
    
    //MARK:- NSKeyedArchiver関連
    
    static var supportsSecureCoding: Bool {
        return true
    }
    
    // シリアライズ処理
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.dataNumber, forKey: "dataNumber")
//        aCoder.encode(self.backgroundImage, forKey: "dataNumber")
        aCoder.encode(self.count, forKey: "count")
        aCoder.encode(self.mannerMode, forKey: "mannerMode")
        aCoder.encode(self.audioFinish, forKey: "audioFinish")
        aCoder.encode(self.audioElapsed5min, forKey: "audioElapsed5min")
        aCoder.encode(self.audioElapsed10min, forKey: "audioElapsed10min")
        aCoder.encode(self.audioElapsed15min, forKey: "audioElapsed15min")
        aCoder.encode(self.audioElapsed20min, forKey: "audioElapsed20min")
        aCoder.encode(self.audioElapsed25min, forKey: "audioElapsed25min")
        aCoder.encode(self.audioElapsed30min, forKey: "audioElapsed30min")
        aCoder.encode(self.audioElapsed35min, forKey: "audioElapsed35min")
        aCoder.encode(self.audioElapsed40min, forKey: "audioElapsed40min")
        aCoder.encode(self.audioElapsed45min, forKey: "audioElapsed45min")
        aCoder.encode(self.audioElapsed50min, forKey: "audioElapsed50min")
        aCoder.encode(self.audioRemaining30sec, forKey: "audioRemaining30sec")
        aCoder.encode(self.audioRemaining1min, forKey: "audioRemaining1min")
        aCoder.encode(self.audioRemaining3min, forKey: "audioRemaining3min")
        aCoder.encode(self.audioAppStartUp, forKey: "audioAppStartUp")
        aCoder.encode(self.audioAppFinish, forKey: "audioAppFinish")
    }
    
    // デシリアライズ処理
    required init?(coder aDecoder: NSCoder) {
        self.dataNumber          = aDecoder.decodeObject(forKey: "dataNumber") as? Int ?? 0
        self.count               = aDecoder.decodeObject(forKey: "count") as? Float ?? 0.0
        self.mannerMode          = aDecoder.decodeBool(forKey: "mannerMode")
        self.audioFinish         = aDecoder.decodeObject(forKey: "audioFinish") as? String ?? ""
        self.audioElapsed5min    = aDecoder.decodeObject(forKey: "audioElapsed5min") as? String ?? ""
        self.audioElapsed10min   = aDecoder.decodeObject(forKey: "audioElapsed10min") as? String ?? ""
        self.audioElapsed15min   = aDecoder.decodeObject(forKey: "audioElapsed15min") as? String ?? ""
        self.audioElapsed20min   = aDecoder.decodeObject(forKey: "audioElapsed20min") as? String ?? ""
        self.audioElapsed25min   = aDecoder.decodeObject(forKey: "audioElapsed25min") as? String ?? ""
        self.audioElapsed30min   = aDecoder.decodeObject(forKey: "audioElapsed30min") as? String ?? ""
        self.audioElapsed35min   = aDecoder.decodeObject(forKey: "audioElapsed35min") as? String ?? ""
        self.audioElapsed40min   = aDecoder.decodeObject(forKey: "audioElapsed40min") as? String ?? ""
        self.audioElapsed45min   = aDecoder.decodeObject(forKey: "audioElapsed45min") as? String ?? ""
        self.audioElapsed50min   = aDecoder.decodeObject(forKey: "audioElapsed50min") as? String ?? ""
        self.audioRemaining30sec = aDecoder.decodeObject(forKey: "audioRemaining30sec") as? String ?? ""
        self.audioRemaining1min  = aDecoder.decodeObject(forKey: "audioRemaining1min") as? String ?? ""
        self.audioRemaining3min  = aDecoder.decodeObject(forKey: "audioRemaining3min") as? String ?? ""
        self.audioAppStartUp     = aDecoder.decodeObject(forKey: "audioAppStartUp") as? String ?? ""
        self.audioAppFinish      = aDecoder.decodeObject(forKey: "audioAppFinish") as? String ?? ""
    }
    
    
    
    //MARK:- その他のメソッド
    
    // 音声を再生するメソッド
    func audioPlay(fileName name:String?) {
        if let fileName = name {
            // パスを作成
            let path = Bundle.main.bundleURL.appendingPathComponent(fileName)
            
            // プレイヤーを作成
            var player = AVAudioPlayer()
            
            // 再生
            do {
                player = try AVAudioPlayer(contentsOf: path, fileTypeHint: nil)
                player.play()
            } catch {
                print("再生処理でエラーが発生しました")
            }
        } else {
            print("ファイルが設定されていません")
        }
    }
    
}

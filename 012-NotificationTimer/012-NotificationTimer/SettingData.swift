//
//  SettingData.swift
//  012-NotificationTimer
//
//  Created by Takatoshi Miura on 2020/09/02.
//  Copyright © 2020 Takatoshi Miura. All rights reserved.
//
//  ＜メモ＞
//　・mp3を再生するには保持データにplayerを持たせなければならない。しかし、Realmはplayerをサポートしないため、ここには持たせられない。
//　


import UIKit
import RealmSwift

class SettingData:Object {
    
    //MARK:- 保持データ
    
    @objc dynamic var dataNumber:Int = 0                    // データ番号
    @objc dynamic var count:Float = 0.0                     // 設定時間
    @objc dynamic var mannerMode:Bool = false               // マナーモード（true:ON / false:OFF）
    @objc dynamic var audioFinishSoundID:Int = 0            // 終了時間通知用 システムサウンドID
    @objc dynamic var audioElapsed5minSoundID:Int = 0       // 5分経過通知用 システムサウンドID
    @objc dynamic var audioElapsed10minSoundID:Int = 0      // 10分経過通知用 システムサウンドID
    @objc dynamic var audioElapsed15minSoundID:Int = 0      // 15分経過通知用 システムサウンドID
    @objc dynamic var audioElapsed20minSoundID:Int = 0      // 20分経過通知用 システムサウンドID
    @objc dynamic var audioElapsed25minSoundID:Int = 0      // 25分経過通知用 システムサウンドID
    @objc dynamic var audioElapsed30minSoundID:Int = 0      // 30分経過通知用 システムサウンドID
    @objc dynamic var audioElapsed35minSoundID:Int = 0      // 35分経過通知用 システムサウンドID
    @objc dynamic var audioElapsed40minSoundID:Int = 0      // 40分経過通知用 システムサウンドID
    @objc dynamic var audioElapsed45minSoundID:Int = 0      // 45分経過通知用 システムサウンドID
    @objc dynamic var audioElapsed50minSoundID:Int = 0      // 50分経過通知用 システムサウンドID
    @objc dynamic var audioRemaining30secSoundID:Int = 0    // 残り30秒通知用 システムサウンドID
    @objc dynamic var audioRemaining1minSoundID:Int = 0     // 残り1分通知用 システムサウンドID
    @objc dynamic var audioRemaining3minSoundID:Int = 0     // 残り3分通知用 システムサウンドID
    @objc dynamic var audioRemaining5minSoundID:Int = 0     // 残り5分通知用 システムサウンドID
    @objc dynamic var audioAppStartUpSoundID:Int = 0        // アプリ起動音 システムサウンドID
    @objc dynamic var audioFinish:String = Bundle.main.path(forResource: "デフォルト(終了時)", ofType:"mp3")!           // 終了時通知用 音声ファイルパス
    @objc dynamic var audioElapsed5min:String = Bundle.main.path(forResource: "デフォルト(5分経過)", ofType:"mp3")!     // 5分経過通知用 音声ファイルパス
    @objc dynamic var audioElapsed10min:String = Bundle.main.path(forResource: "デフォルト(10分経過)", ofType:"mp3")!   // 10分経過通知用 音声ファイルパス
    @objc dynamic var audioElapsed15min:String = Bundle.main.path(forResource: "デフォルト(15分経過)", ofType:"mp3")!   // 15分経過通知用 音声ファイルパス
    @objc dynamic var audioElapsed20min:String = Bundle.main.path(forResource: "デフォルト(20分経過)", ofType:"mp3")!   // 20分経過通知用 音声ファイルパス
    @objc dynamic var audioElapsed25min:String = Bundle.main.path(forResource: "デフォルト(25分経過)", ofType:"mp3")!   // 25分経過通知用 音声ファイルパス
    @objc dynamic var audioElapsed30min:String = Bundle.main.path(forResource: "デフォルト(30分経過)", ofType:"mp3")!   // 30分経過通知用 音声ファイルパス
    @objc dynamic var audioElapsed35min:String = Bundle.main.path(forResource: "デフォルト(35分経過)", ofType:"mp3")!   // 35分経過通知用 音声ファイルパス
    @objc dynamic var audioElapsed40min:String = Bundle.main.path(forResource: "デフォルト(40分経過)", ofType:"mp3")!   // 40分経過通知用 音声ファイルパス
    @objc dynamic var audioElapsed45min:String = Bundle.main.path(forResource: "デフォルト(45分経過)", ofType:"mp3")!   // 45分経過通知用 音声ファイルパス
    @objc dynamic var audioElapsed50min:String = Bundle.main.path(forResource: "デフォルト(50分経過)", ofType:"mp3")!   // 50分経過通知用 音声ファイルパス
    @objc dynamic var audioRemaining30sec:String = Bundle.main.path(forResource: "デフォルト(残り30秒)", ofType:"mp3")! // 残り30秒通知用 音声ファイルパス
    @objc dynamic var audioRemaining1min:String = Bundle.main.path(forResource: "デフォルト(残り1分)", ofType:"mp3")!   // 残り1分通知用 音声ファイルパス
    @objc dynamic var audioRemaining3min:String = Bundle.main.path(forResource: "デフォルト(残り3分)", ofType:"mp3")!   // 残り3分通知用 音声ファイルパス
    @objc dynamic var audioRemaining5min:String = Bundle.main.path(forResource: "デフォルト(残り5分)", ofType:"mp3")!   // 残り5分通知用 音声ファイルパス
    @objc dynamic var audioAppStartUp:String = "OFF"                                                                 // アプリ起動音 音声ファイルパス
    
    
    
    //MARK:- イニシャライザ
    
    convenience init(dataNumber num:Int) {
        self.init()
        self.dataNumber = num
    }
    
    
    
    //MARK:- セッター
    
    func setDataNumber(number:Int) {
        self.dataNumber = number
    }
    
    func setCount(time:Float) {
        self.count = time
    }
    
    func setMannerMode(bool:Bool) {
        self.mannerMode = bool
    }
    
    func setAudioFinishSoundID(id:Int) {
        self.audioFinishSoundID = id
    }
    
    func setAudioElapsed5minSoundID(id:Int) {
        self.audioElapsed5minSoundID = id
    }
    
    func setAudioElapsed10minSoundID(id:Int) {
        self.audioElapsed10minSoundID = id
    }
    
    func setAudioElapsed15minSoundID(id:Int) {
        self.audioElapsed15minSoundID = id
    }
    
    func setAudioElapsed20minSoundID(id:Int) {
        self.audioElapsed20minSoundID = id
    }
    
    func setAudioElapsed25minSoundID(id:Int) {
        self.audioElapsed25minSoundID = id
    }
    
    func setAudioElapsed30minSoundID(id:Int) {
        self.audioElapsed30minSoundID = id
    }
    
    func setAudioElapsed35minSoundID(id:Int) {
        self.audioElapsed35minSoundID = id
    }
    
    func setAudioElapsed40minSoundID(id:Int) {
        self.audioElapsed40minSoundID = id
    }
    
    func setAudioElapsed45minSoundID(id:Int) {
        self.audioElapsed45minSoundID = id
    }
    
    func setAudioElapsed50minSoundID(id:Int) {
        self.audioElapsed50minSoundID = id
    }
    
    func setAudioRemaining30secSoundID(id:Int) {
        self.audioRemaining30secSoundID = id
    }
    
    func setAudioRemaining1minSoundID(id:Int) {
        self.audioRemaining1minSoundID = id
    }
    
    func setAudioRemaining3minSoundID(id:Int) {
        self.audioRemaining3minSoundID = id
    }
    
    func setAudioRemaining5minSoundID(id:Int) {
        self.audioRemaining5minSoundID = id
    }
    
    func setAudioAppStartUpSoundID(id:Int) {
        self.audioAppStartUpSoundID = id
    }
    
    func setAudioFinish(filePath:String) {
        self.audioFinish = filePath
    }
    
    func setAudioElapsed5min(filePath:String) {
        self.audioElapsed5min = filePath
    }
    
    func setAudioElapsed10min(filePath:String) {
        self.audioElapsed10min = filePath
    }
    
    func setAudioElapsed15min(filePath:String) {
        self.audioElapsed15min = filePath
    }
    
    func setAudioElapsed20min(filePath:String) {
        self.audioElapsed20min = filePath
    }
    
    func setAudioElapsed25min(filePath:String) {
        self.audioElapsed25min = filePath
    }
    
    func setAudioElapsed30min(filePath:String) {
        self.audioElapsed30min = filePath
    }
    
    func setAudioElapsed35min(filePath:String) {
        self.audioElapsed35min = filePath
    }
    
    func setAudioElapsed40min(filePath:String) {
        self.audioElapsed40min = filePath
    }
    
    func setAudioElapsed45min(filePath:String) {
        self.audioElapsed45min = filePath
    }
    
    func setAudioElapsed50min(filePath:String) {
        self.audioElapsed50min = filePath
    }
    
    func setAudioRemaining30sec(filePath:String) {
        self.audioRemaining30sec = filePath
    }
    
    func setAudioRemaining1min(filePath:String) {
        self.audioRemaining1min = filePath
    }
    
    func setAudioRemaining3min(filePath:String) {
        self.audioRemaining3min = filePath
    }
    
    func setAudioRemaining5min(filePath:String) {
        self.audioRemaining5min = filePath
    }
    
    func setAudioAppStartUp(filePath:String) {
        self.audioAppStartUp = filePath
    }
    
    
    
    //MARK:- ゲッター
    
    func getDataNumber() -> Int {
        return self.dataNumber
    }
    
    func getCount() -> Float {
        return self.count
    }
    
    func getMannerMode() -> Bool {
        return self.mannerMode
    }
    
    func getAudioFinishSoundID() -> Int {
        return self.audioFinishSoundID
    }
    
    func getAudioElapsed5minSoundID() -> Int {
        return self.audioElapsed5minSoundID
    }
    
    func getAudioElapsed10minSoundID() -> Int {
        return self.audioElapsed10minSoundID
    }
    
    func getAudioElapsed15minSoundID() -> Int {
        return self.audioElapsed15minSoundID
    }
    
    func getAudioElapsed20minSoundID() -> Int {
        return self.audioElapsed20minSoundID
    }
    
    func getAudioElapsed25minSoundID() -> Int {
        return self.audioElapsed25minSoundID
    }
    
    func getAudioElapsed30minSoundID() -> Int {
        return self.audioElapsed30minSoundID
    }
    
    func getAudioElapsed35minSoundID() -> Int {
        return self.audioElapsed35minSoundID
    }
    
    func getAudioElapsed40minSoundID() -> Int {
        return self.audioElapsed40minSoundID
    }
    
    func getAudioElapsed45minSoundID() -> Int {
        return self.audioElapsed45minSoundID
    }
    
    func getAudioElapsed50minSoundID() -> Int {
        return self.audioElapsed50minSoundID
    }
    
    func getAudioRemaining30secSoundID() -> Int {
        return self.audioRemaining30secSoundID
    }
    
    func getAudioRemaining1minSoundID() -> Int {
        return self.audioRemaining1minSoundID
    }
    
    func getAudioRemaining3minSoundID() -> Int {
        return self.audioRemaining3minSoundID
    }
    
    func getAudioRemaining5minSoundID() -> Int {
        return self.audioRemaining5minSoundID
    }
    
    func getAudioAppStartUpSoundID() -> Int {
        return self.audioAppStartUpSoundID
    }
    
    func getAudioFinish() -> String {
        return self.audioFinish
    }
    
    func getAudioElapsed5min() -> String {
        return self.audioElapsed5min
    }
    
    func getAudioElapsed10min() -> String {
        return self.audioElapsed10min
    }
    
    func getAudioElapsed15min() -> String {
        return self.audioElapsed15min
    }
    
    func getAudioElapsed20min() -> String {
        return self.audioElapsed20min
    }
    
    func getAudioElapsed25min() -> String {
        return self.audioElapsed25min
    }
    
    func getAudioElapsed30min() -> String {
        return self.audioElapsed30min
    }
    
    func getAudioElapsed35min() -> String {
        return self.audioElapsed35min
    }
    
    func getAudioElapsed40min() -> String {
        return self.audioElapsed40min
    }
    
    func getAudioElapsed45min() -> String {
        return self.audioElapsed45min
    }
    
    func getAudioElapsed50min() -> String {
        return self.audioElapsed50min
    }
    
    func getAudioRemaining30sec() -> String {
        return self.audioRemaining30sec
    }
    
    func getAudioRemaining1min() -> String {
        return self.audioRemaining1min
    }
    
    func getAudioRemaining3min() -> String {
        return self.audioRemaining3min
    }
    
    func getAudioRemaining5min() -> String {
        return self.audioRemaining5min
    }
    
    func getAudioAppStartUp() -> String {
        return self.audioAppStartUp
    }
    
    
    
    //MARK:- その他
    
    // ファイルパスからファイル名を取得するメソッド
    func getFileName(filePath path:String) -> String {
        return (path as NSString).lastPathComponent
    }
    
}

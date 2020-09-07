//
//  SettingData.swift
//  012-NotificationTimer
//
//  Created by Takatoshi Miura on 2020/09/02.
//  Copyright © 2020 Takatoshi Miura. All rights reserved.
//

import UIKit
import RealmSwift

class SettingData:Object {
    
    //MARK:- 保持データ
    
    @objc dynamic var dataNumber:Int = 0              // データ番号
    @objc dynamic var count:Float = 0.0               // 設定時間
    @objc dynamic var mannerMode:Bool = false         // マナーモード（true:ON / false:OFF）
    @objc dynamic var audioFinish:String = "デフォルト(終了時)"             // 終了時通知用 音声ファイル名
    @objc dynamic var audioElapsed5min:String = "デフォルト(5分経過)"       // 5分経過通知用 音声ファイル名
    @objc dynamic var audioElapsed10min:String = "デフォルト(10分経過)"     // 10分経過通知用 音声ファイル名
    @objc dynamic var audioElapsed15min:String = "デフォルト(15分経過)"     // 15分経過通知用 音声ファイル名
    @objc dynamic var audioElapsed20min:String = "デフォルト(20分経過)"     // 20分経過通知用 音声ファイル名
    @objc dynamic var audioElapsed25min:String = "デフォルト(25分経過)"     // 25分経過通知用 音声ファイル名
    @objc dynamic var audioElapsed30min:String = "デフォルト(30分経過)"     // 30分経過通知用 音声ファイル名
    @objc dynamic var audioElapsed35min:String = "デフォルト(35分経過)"     // 35分経過通知用 音声ファイル名
    @objc dynamic var audioElapsed40min:String = "デフォルト(40分経過)"     // 40分経過通知用 音声ファイル名
    @objc dynamic var audioElapsed45min:String = "デフォルト(45分経過)"     // 45分経過通知用 音声ファイル名
    @objc dynamic var audioElapsed50min:String = "デフォルト(50分経過)"     // 50分経過通知用 音声ファイル名
    @objc dynamic var audioRemaining30sec:String = "デフォルト(残り30秒)"   // 残り30秒通知用 音声ファイル名
    @objc dynamic var audioRemaining1min:String = "デフォルト(残り1分)"     // 残り1分通知用 音声ファイル名
    @objc dynamic var audioRemaining3min:String = "デフォルト(残り3分)"     // 残り3分通知用 音声ファイル名
    @objc dynamic var audioAppStartUp:String = "デフォルト(アプリ起動時)"    // アプリ起動音 音声ファイル名
    @objc dynamic var audioAppFinish:String = "デフォルト(アプリ終了時)"     // アプリ終了音 音声ファイル名
    
    
    
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
    
    func getCount() -> Float {
        return self.count
    }
    
    func getMannerMode() -> Bool {
        return self.mannerMode
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
    
    func getAudioAppStartUp() -> String {
        return self.audioAppStartUp
    }
    
    func getAudioAppFinish() -> String {
        return self.audioAppFinish
    }
    
    
}

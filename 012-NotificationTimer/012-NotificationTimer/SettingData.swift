//
//  SettingData.swift
//  012-NotificationTimer
//
//  Created by Takatoshi Miura on 2020/09/02.
//  Copyright © 2020 Takatoshi Miura. All rights reserved.
//

import UIKit
import RealmSwift
import AVFoundation

class SettingData:Object {
    
    //MARK:- 保持データ
    
    @objc dynamic var dataNumber:Int = 0              // データ番号
    @objc dynamic var count:Float = 0.0               // 設定時間
    @objc dynamic var mannerMode:Bool = false         // マナーモード（true:ON / false:OFF）
    @objc dynamic var audioFinish:String = ""         // 終了時通知用 音声ファイル名
    @objc dynamic var audioElapsed5min:String = ""    // 5分経過通知用 音声ファイル名
    @objc dynamic var audioElapsed10min:String = ""   // 10分経過通知用 音声ファイル名
    @objc dynamic var audioElapsed15min:String = ""   // 15分経過通知用 音声ファイル名
    @objc dynamic var audioElapsed20min:String = ""   // 20分経過通知用 音声ファイル名
    @objc dynamic var audioElapsed25min:String = ""   // 25分経過通知用 音声ファイル名
    @objc dynamic var audioElapsed30min:String = ""   // 30分経過通知用 音声ファイル名
    @objc dynamic var audioElapsed35min:String = ""   // 35分経過通知用 音声ファイル名
    @objc dynamic var audioElapsed40min:String = ""   // 40分経過通知用 音声ファイル名
    @objc dynamic var audioElapsed45min:String = ""   // 45分経過通知用 音声ファイル名
    @objc dynamic var audioElapsed50min:String = ""   // 50分経過通知用 音声ファイル名
    @objc dynamic var audioRemaining30sec:String = "" // 残り30秒通知用 音声ファイル名
    @objc dynamic var audioRemaining1min:String = ""  // 残り1分通知用 音声ファイル名
    @objc dynamic var audioRemaining3min:String = ""  // 残り3分通知用 音声ファイル名
    @objc dynamic var audioAppStartUp:String = ""     // アプリ起動音 音声ファイル名
    @objc dynamic var audioAppFinish:String = ""      // アプリ終了音 音声ファイル名
    
    
    
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
    
    
    
    //MARK:- その他のメソッド
    
    // 規定時間を通知するメソッド
    // Fix:何度も起動してしまう
    func notificationTime(elapsedTime time:Float) {
        // 経過時間の通知
        switch Int(time) {
        case 60 * 5:
            // 5分経過
            audioPlay(fileName: self.audioElapsed5min)
            print("5分経過")
        case 60 * 10:
            // 10分経過
            audioPlay(fileName: self.audioElapsed10min)
            print("10分経過")
        case 60 * 15:
            // 15分経過
            audioPlay(fileName: self.audioElapsed15min)
            print("15分経過")
        case 60 * 20:
            // 20分経過
            audioPlay(fileName: self.audioElapsed20min)
            print("20分経過")
        case 60 * 25:
            // 25分経過
            audioPlay(fileName: self.audioElapsed25min)
            print("25分経過")
        case 60 * 30:
            // 30分経過
            audioPlay(fileName: self.audioElapsed30min)
            print("30分経過")
        case 60 * 35:
            // 35分経過
            audioPlay(fileName: self.audioElapsed35min)
            print("35分経過")
        case 60 * 40:
            // 40分経過
            audioPlay(fileName: self.audioElapsed40min)
            print("40分経過")
        case 60 * 45:
            // 45分経過
            audioPlay(fileName: self.audioElapsed45min)
            print("45分経過")
        case 60 * 50:
            // 50分経過
            audioPlay(fileName: self.audioElapsed50min)
            print("50分経過")
        default:
            break
        }
        
        // 残り時間の通知
        switch Int(self.count) {
        case 60 * 3:
            // 残り3分
            audioPlay(fileName: self.audioRemaining3min)
            print("残り3分")
        case 60 * 1:
            // 残り1分
            audioPlay(fileName: self.audioRemaining1min)
            print("残り1分")
        case 30:
            // 残り30秒
            audioPlay(fileName: self.audioRemaining30sec)
            print("残り30秒")
        case 0:
            // 終了
            audioPlay(fileName: self.audioFinish)
            print("終了")
        default:
            break
        }
        
    }
    
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

//
//  SettingData.swift
//  012-NotificationTimer
//
//  Created by Takatoshi Miura on 2020/09/02.
//  Copyright © 2020 Takatoshi Miura. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift
import AVFoundation

class SettingData:Object {
    
    //MARK:- 保持データ
    
    @objc dynamic var dataNumber:Int = 0              // データ番号
    //@objc dynamic var backgroundImage:UIImage?        // 背景画像
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
    
    required init() {
        
    }
    
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
    
    
    
    //MARK:- データ関連
    
    // データをUserDefaultsからロードするメソッド
    func loadSettingData(dataNumber num:Int) {
        // Realmデータベースにアクセス
        let realm = try! Realm()
        
        // データの取得
        let object = realm.objects(SettingData.self)//.filter("dataNumber = \(num)")
        
        // データの反映
        self.dataNumber          = object[0].getDataNumber()
//        self.backgroundImage     = object[0].getBackgroundImage()
        self.count               = object[0].getCount()
        self.mannerMode          = object[0].getMannerMode()
        self.audioFinish         = object[0].getAudioFinish()
        self.audioElapsed5min    = object[0].getAudioElapsed5min()
        self.audioElapsed10min   = object[0].getAudioElapsed10min()
        self.audioElapsed15min   = object[0].getAudioElapsed15min()
        self.audioElapsed20min   = object[0].getAudioElapsed20min()
        self.audioElapsed25min   = object[0].getAudioElapsed25min()
        self.audioElapsed30min   = object[0].getAudioElapsed30min()
        self.audioElapsed35min   = object[0].getAudioElapsed35min()
        self.audioElapsed40min   = object[0].getAudioElapsed40min()
        self.audioElapsed45min   = object[0].getAudioElapsed45min()
        self.audioElapsed50min   = object[0].getAudioElapsed50min()
        self.audioRemaining30sec = object[0].getAudioRemaining30sec()
        self.audioRemaining1min  = object[0].getAudioRemaining1min()
        self.audioRemaining3min  = object[0].getAudioRemaining3min()
        self.audioAppStartUp     = object[0].getAudioAppStartUp()
        self.audioAppFinish      = object[0].getAudioAppFinish()
    }
    
    // データをUserDefaultsに保存するメソッド
    func saveSettingData() {
        // Realmデータベースにアクセス
        let realm = try! Realm()
        
        // Realmデータベースに書き込み
        try! realm.write {
            realm.add(self)
        }
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

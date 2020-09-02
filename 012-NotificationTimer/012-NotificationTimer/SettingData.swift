//
//  SettingData.swift
//  012-NotificationTimer
//
//  Created by Takatoshi Miura on 2020/09/02.
//  Copyright © 2020 Takatoshi Miura. All rights reserved.
//

import UIKit
import AVFoundation

class SettingData {
    
    //MARK:- 保持データ
    
    var backgroundImage:UIImage?    // 背景画像
    var count:Float = 0.0           // 設定時間
    var mannerMode:Bool = false     // マナーモード（true:ON / false:OFF）
    var audioFinish:String?         // 終了時通知用 音声ファイル名
    var audioElapsed5min:String?    // 5分経過通知用 音声ファイル名
    var audioElapsed10min:String?   // 10分経過通知用 音声ファイル名
    var audioElapsed15min:String?   // 15分経過通知用 音声ファイル名
    var audioElapsed20min:String?   // 20分経過通知用 音声ファイル名
    var audioElapsed25min:String?   // 25分経過通知用 音声ファイル名
    var audioElapsed30min:String?   // 30分経過通知用 音声ファイル名
    var audioElapsed35min:String?   // 35分経過通知用 音声ファイル名
    var audioElapsed40min:String?   // 40分経過通知用 音声ファイル名
    var audioElapsed45min:String?   // 45分経過通知用 音声ファイル名
    var audioElapsed50min:String?   // 50分経過通知用 音声ファイル名
    var audioRemaining30sec:String? // 残り30秒通知用 音声ファイル名
    var audioRemaining1min:String?  // 残り1分通知用 音声ファイル名
    var audioRemaining3min:String?  // 残り3分通知用 音声ファイル名
    var audioAppStartUp:String?     // アプリ起動音 音声ファイル名
    var audioAppFinish:String?      // アプリ終了音 音声ファイル名
    
    
    
    //MARK:- セッター
    
    func setBackgroundImage(image:UIImage) {
        self.backgroundImage = image
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
    
    func getBackgroundImage() -> UIImage? {
        return self.backgroundImage
    }
    
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

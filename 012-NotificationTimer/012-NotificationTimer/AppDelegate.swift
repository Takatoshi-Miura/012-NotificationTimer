//
//  AppDelegate.swift
//  012-NotificationTimer
//
//  Created by Takatoshi Miura on 2020/08/31.
//  Copyright © 2020 Takatoshi Miura. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 初回起動判定(初期値を登録)
        UserDefaults.standard.register(defaults: ["firstLaunch": true])
        
        // 初回起動時の処理
        if UserDefaults.standard.bool(forKey: "firstLaunch") {
            // SettingDataを作成
            let settingData = SettingData(dataNumber: 0)
            
            // Realmデータベースにアクセス
            let realm = try! Realm()
            
            // Realmデータベースに書き込み
            try! realm.write {
                realm.add(settingData)
            }
        }
        
        // 2回目以降の起動では「firstLaunch」のkeyをfalseに
        UserDefaults.standard.set(false, forKey: "firstLaunch")
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


//
//  AppDelegate.swift
//  012-NotificationTimer
//
//  Created by Takatoshi Miura on 2020/08/31.
//  Copyright © 2020 Takatoshi Miura. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Firebase接続用
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        // 初回起動判定(初期値を登録)
        UserDefaults.standard.register(defaults: ["firstLaunch": true])
        
        // 初回起動時の処理
        if UserDefaults.standard.bool(forKey: "firstLaunch") {
            // Application Supportフォルダを作成
            let applicationSupportDir = try! FileManager.default.url(for: .applicationSupportDirectory,in: .userDomainMask,appropriateFor: nil,create: true)
            
            // Application SupportフォルダをRealmの保存先に指定
            let path = applicationSupportDir.appendingPathComponent("default.realm")
            var config = Realm.Configuration.defaultConfiguration
            config.fileURL = path
            Realm.Configuration.defaultConfiguration = config
            
            // SettingDataを作成
            let settingData = SettingData(dataNumber: 0)
            
            // Realmデータベースにアクセス
            let realm = try! Realm()
            
            // Realmデータベースに書き込み
            try! realm.write {
                realm.add(settingData)
            }
        }
        
        // 通知の許可
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Allowed")
            } else {
                print("Didn't allowed")
            }
        }
        
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


//
//  AudioListViewController.swift
//  012-NotificationTimer
//
//  Created by Takatoshi Miura on 2020/09/08.
//  Copyright © 2020 Takatoshi Miura. All rights reserved.
//

import UIKit

class AudioListViewController: UIViewController,UINavigationBarDelegate {

    // MARK:- ライフサイクルメソッド
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ナビゲーションタイトルの設定
        self.navigationBar.items![0].title = self.navigationTitle
    }
    
    
    
    // MARK:- UIの設定
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    

    
    // MARK:- 変数の宣言
    
    var navigationTitle = ""
    var settingData = SettingData()
    

}

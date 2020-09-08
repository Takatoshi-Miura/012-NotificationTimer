//
//  AudioListViewController.swift
//  012-NotificationTimer
//
//  Created by Takatoshi Miura on 2020/09/08.
//  Copyright © 2020 Takatoshi Miura. All rights reserved.
//

import UIKit
import AVFoundation

class AudioListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    // MARK:- ライフサイクルメソッド
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ナビゲーションタイトルの設定
        self.navigationBar.items![0].title = self.navigationTitle
    }
    
    
    
    // MARK:- UIの設定
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    

    
    // MARK:- 変数の宣言
    
    var navigationTitle = ""
    var settingData = SettingData()
    let cellTitleArray:[[String]] = [["test"],["test"],["test"]]
    let sectionTitleArray:[String] = ["デフォルト","Apple","取り込んだデータ"]
    
    
    
    // MARK:- テーブルビューの設定
    
    // セル数を返却
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitleArray[section].count
    }
    
    // セルを返却
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "audioCell", for: indexPath)
        cell.textLabel!.text = cellTitleArray[indexPath.section][indexPath.row]
        return cell
    }
    
    // セクション名を返却
    func tableView(_ tableView:UITableView, titleForHeaderInSection section:Int) -> String?{
        return sectionTitleArray[section]
    }
    
    // セクションの個数を返却
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitleArray.count
    }
    
    // セルをタップしたときの処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

}

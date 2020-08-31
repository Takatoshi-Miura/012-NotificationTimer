//
//  AudioSettingViewController.swift
//  012-NotificationTimer
//
//  Created by Takatoshi Miura on 2020/08/31.
//  Copyright © 2020 Takatoshi Miura. All rights reserved.
//

import UIKit

class AudioSettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    // MARK: -ライフサイクルメソッド
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // テーブルビュー初期設定
        tableViewInit()
        
        // ナビゲーションバーを表示
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    
    // MARK: -UIの設定
    
    // テーブルビュー
    @IBOutlet weak var tableView: UITableView!
    
    // マナーモードスイッチ
    @objc func switchTriggered(sender: UISwitch){
        if sender.isOn {
            // ONの処理
        } else {
            // OFFの処理
        }
    }
    
    
    
    // MARK: -テーブルビューの設定
    
    // 初期化メソッド
    func tableViewInit() {
        // データのないセルを非表示
        tableView.tableFooterView = UIView()
    }
    
    // セル数を返却
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // セクションによって分岐
        switch section {
        case 2:
            return 10   // 経過時間通知セル
        case 3:
            return 3    // 残り時間通知セル
        case 4:
            return 2    // アプリ起動/終了セル
        default:
            return 1
        }
    }
    
    // セルを返却
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セクションによって分岐
        switch indexPath.section {
        case 0:
            // マナーモードセルを返却
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "mannerCell", for: indexPath)
            cell.textLabel!.text = "マナーモード"
            
            // スイッチを追加
            let switchView = UISwitch(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            switchView.addTarget(self, action: #selector(switchTriggered), for: .valueChanged)
            cell.accessoryView = switchView
            
            return cell
        case 1:
            // 音声セルを返却
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "audioCell", for: indexPath)
            cell.textLabel!.text = "終了時"
            return cell
        case 2:
            // 音声セルを返却
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "audioCell", for: indexPath)
            let cellTitle:[String] = ["5分経過","10分経過","15分経過","20分経過","25分経過","30分経過","35分経過","40分経過","45分経過","50分経過"]
            cell.textLabel!.text = cellTitle[indexPath.row]
            return cell
        case 3:
            // 音声セルを返却
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "audioCell", for: indexPath)
            let cellTitle:[String] = ["残り30秒","残り1分","残り3分"]
            cell.textLabel!.text = cellTitle[indexPath.row]
            return cell
        case 4:
            // 音声セルを返却
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "audioCell", for: indexPath)
            let cellTitle:[String] = ["アプリ起動時","アプリ終了時"]
            cell.textLabel!.text = cellTitle[indexPath.row]
            return cell
        default:
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "audioCell", for: indexPath)
            return cell
        }
    }
    
    // セクション名を返却
    let sectionTitleArray:[String] = ["一括設定","音量がゼロになり、バイブレーションでの通知となります。\n\n終了時","経過時間通知","残り時間通知","その他"]
    func tableView(_ tableView:UITableView, titleForHeaderInSection section:Int) -> String?{
        return sectionTitleArray[section]
    }
    
    // セクションの個数を返却
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitleArray.count
    }
    
    // セクションの高さを返却
    let sectionHeightArray:[CGFloat] = [30,60,30,30,30]
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeightArray[section]
    }
    
    // セルをタップしたときの処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // タップしたときの選択色を消去
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    



}

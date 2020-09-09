//
//  AudioSettingViewController.swift
//  012-NotificationTimer
//
//  Created by Takatoshi Miura on 2020/08/31.
//  Copyright © 2020 Takatoshi Miura. All rights reserved.
//

import UIKit

class AudioSettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    // MARK:- ライフサイクルメソッド
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // テーブルビュー初期設定
        tableViewInit()
        
        // マナーモードスイッチ初期設定
        mannerModeSwitchInit()
        
        // ナビゲーションバーを表示
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    
    // MARK:- UIの設定
    
    // テーブルビュー
    @IBOutlet weak var tableView: UITableView!
    
    // キャンセルボタン
    @IBAction func cancelButton(_ sender: Any) {
        // 音声設定を閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
    // 保存ボタン
    @IBAction func saveButton(_ sender: Any) {
        // SettingDataに設定を反映する
        
        // 遷移元に画面を取得する
        if let controller = self.presentingViewController as? TimerViewController {
            // 設定データを渡す
            controller.settingData = self.settingData
            print("データをTimerViewControllerに渡しました")
            
            // 音声設定を閉じる
            controller.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    // マナーモードスイッチ
    let switchView = UISwitch(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    @objc func switchTriggered(sender: UISwitch) {
        if sender.isOn {
            // ONの処理
            print("マナーモードをONにしました")
            // 設定データに反映
            self.settingData.setMannerMode(bool: true)
        } else {
            // OFFの処理
            print("マナーモードをOFFにしました")
            // 設定データに反映
            self.settingData.setMannerMode(bool: false)
        }
    }
    
    
    
    // MARK:- 変数の宣言
    
    var settingData = SettingData(dataNumber: 0)
    var cellTitle:String = ""
    let cellTitleArray:[[String]] = [["マナーモード"],
                                     ["終了時"],
                                     ["5分経過","10分経過","15分経過","20分経過","25分経過","30分経過","35分経過","40分経過","45分経過","50分経過"],
                                     ["残り30秒","残り1分","残り3分","残り5分"],
                                     ["アプリ起動時","アプリ終了時"]]
    let sectionTitleArray:[String] = ["一括設定","音量がゼロになり、バイブレーションでの通知となります。\n\n終了時","経過時間通知","残り時間通知","その他"]
    
    
    
    // MARK:- テーブルビューの設定
    
    // 初期化メソッド
    func tableViewInit() {
        // データのないセルを非表示
        tableView.tableFooterView = UIView()
    }
    
    // セル数を返却
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // セクション毎のセル数
        return cellTitleArray[section].count
    }
    
    // セルを返却
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セクションによって分岐
        if indexPath.section == 0 {
            // マナーモードセルを返却
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "mannerCell", for: indexPath)
            cell.textLabel!.text = cellTitleArray[indexPath.section][indexPath.row]
            
            // スイッチを追加
            switchView.addTarget(self, action: #selector(switchTriggered), for: .valueChanged)
            cell.accessoryView = switchView
            
            return cell
        } else {
            // 音声セルを返却
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "audioCell", for: indexPath)
            cell.textLabel!.text = cellTitleArray[indexPath.section][indexPath.row]
            cell.detailTextLabel?.text = self.getFileName(indexPath: indexPath)
            cell.detailTextLabel?.textColor = UIColor.systemGray
            return cell
        }
    }
    
    // セクション名を返却
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
        if indexPath.section == 0 {
            // タップしたときの選択色を消去
            tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        } else {
            // タップしたときの選択色を消去
            tableView.deselectRow(at: indexPath as IndexPath, animated: true)
            
            // セルのタイトルを取得
            self.cellTitle = cellTitleArray[indexPath.section][indexPath.row]
            
            // AudioListViewControllerへ遷移
            self.performSegue(withIdentifier: "goAudioListViewController", sender: nil)
        }
    }
    
    
    
    // MARK:- 画面遷移
    
    // 画面遷移時に呼ばれる処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goAudioListViewController" {
            // データを渡す
            let audioListViewController = segue.destination as! AudioListViewController
            audioListViewController.settingData = self.settingData
            audioListViewController.navigationTitle = self.cellTitle
            print("データをAudioListViewControllerに渡しました")
        }
    }
    
    
    
    // MARK:- その他のメソッド
    
    // マナーモードスイッチ初期化メソッド
    func mannerModeSwitchInit() {
        if self.settingData.getMannerMode() == true {
            switchView.isOn = true
        } else {
            // OFF
        }
    }
    
    // 設定データの音源ファイル名(拡張子なし)を返却するメソッド
    func getFileName(indexPath:IndexPath) -> String {
        if indexPath.section == 1 {
            // 終了時
            return URL(fileURLWithPath: self.settingData.getAudioFinish()).deletingPathExtension().lastPathComponent
        } else if indexPath.section == 2 {
            // 経過時間通知
            switch indexPath.row {
            case 0:
                return URL(fileURLWithPath: self.settingData.getAudioElapsed5min()).deletingPathExtension().lastPathComponent
            case 1:
                return URL(fileURLWithPath: self.settingData.getAudioElapsed10min()).deletingPathExtension().lastPathComponent
            case 2:
                return URL(fileURLWithPath: self.settingData.getAudioElapsed15min()).deletingPathExtension().lastPathComponent
            case 3:
                return URL(fileURLWithPath: self.settingData.getAudioElapsed20min()).deletingPathExtension().lastPathComponent
            case 4:
                return URL(fileURLWithPath: self.settingData.getAudioElapsed25min()).deletingPathExtension().lastPathComponent
            case 5:
                return URL(fileURLWithPath: self.settingData.getAudioElapsed30min()).deletingPathExtension().lastPathComponent
            case 6:
                return URL(fileURLWithPath: self.settingData.getAudioElapsed35min()).deletingPathExtension().lastPathComponent
            case 7:
                return URL(fileURLWithPath: self.settingData.getAudioElapsed40min()).deletingPathExtension().lastPathComponent
            case 8:
                return URL(fileURLWithPath: self.settingData.getAudioElapsed45min()).deletingPathExtension().lastPathComponent
            case 9:
                return URL(fileURLWithPath: self.settingData.getAudioElapsed50min()).deletingPathExtension().lastPathComponent
            default:
                return "detail"
            }
        } else if indexPath.section == 3 {
            // 残り時間通知
            switch indexPath.row {
            case 0:
                return URL(fileURLWithPath: self.settingData.getAudioRemaining30sec()).deletingPathExtension().lastPathComponent
            case 1:
                return URL(fileURLWithPath: self.settingData.getAudioRemaining1min()).deletingPathExtension().lastPathComponent
            case 2:
                return URL(fileURLWithPath: self.settingData.getAudioRemaining3min()).deletingPathExtension().lastPathComponent
            case 3:
                return URL(fileURLWithPath: self.settingData.getAudioRemaining5min()).deletingPathExtension().lastPathComponent
            default:
                return "detail"
            }
        } else {
            // アプリ起動/終了時
            switch indexPath.row {
            case 0:
                return URL(fileURLWithPath: self.settingData.getAudioAppStartUp()).deletingPathExtension().lastPathComponent
            case 1:
                return URL(fileURLWithPath: self.settingData.getAudioAppFinish()).deletingPathExtension().lastPathComponent
            default:
                return "detail"
            }
        }
    }



}

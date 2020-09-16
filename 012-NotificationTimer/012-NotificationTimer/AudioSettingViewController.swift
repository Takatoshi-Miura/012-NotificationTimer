//
//  AudioSettingViewController.swift
//  012-NotificationTimer
//
//  Created by Takatoshi Miura on 2020/08/31.
//  Copyright © 2020 Takatoshi Miura. All rights reserved.
//

import UIKit
import RealmSwift

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
        updateSettingData()
        
        // 遷移元に画面を取得する
        if let controller = self.presentingViewController as? TimerViewController {
            // 設定データを渡す
            controller.settingData = self.settingData
            print("SettingData_\(self.settingData.getDataNumber())をTimerViewControllerに渡しました")
            
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
    
    // 設定データ
    var settingData = SettingData(dataNumber: 0)
    
    // ファイル名(セルのdetailに英語名で表示されるのを防止)
    let fileNameArray:[String:String] = ["Update":"アップデート","sms-received6":"エレクトロニック","sms-received3":"ガラス","Calypso":"カリプソ",
                                         "Suspense":"サスペンス","Sherwood_Forest":"シャーウッドの森","Spell":"スペル","Typewriters":"タイプライター",
                                         "sms-received2":"チャイム","tweet_sent":"ツイート","Tiptoes":"つま先","Voicemail":"トライトーン",
                                         "News_Flash":"ニュースフラッシュ","Noir":"ノアール","Ladder":"はしご","Fanfare":"ファンファーレ",
                                         "sms-received4":"ホルン","Minuet":"メヌエット","Choo_Choo":"機関車","alarm":"警告","Descent":"降下",
                                         "new-mail":"鐘","Telegraph":"電報","Bloom":"曇り","Anticipate":"予感","/":"OFF"]
    
    // テーブルビュー
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
            print("SettingData_\(self.settingData.getDataNumber())をAudioListViewControllerに渡しました")
        }
    }
    
    
    // MARK:- データ関連
    
    // データを更新するメソッド
    func updateSettingData() {
        // Realmデータベースにアクセス
        let realm = try! Realm()
        
        // Realmデータベースに書き込み
        try! realm.write {
            // データの取得
            let object = realm.objects(SettingData.self)
            
            // データの更新
            object[self.settingData.getDataNumber()].setDataNumber(number: self.settingData.getDataNumber())
            object[self.settingData.getDataNumber()].setCount(time: self.settingData.getCount())
            object[self.settingData.getDataNumber()].setMannerMode(bool: self.settingData.getMannerMode())
            object[self.settingData.getDataNumber()].setAudioFinish(filePath: self.settingData.getAudioFinish())
            object[self.settingData.getDataNumber()].setAudioElapsed5min(filePath: self.settingData.getAudioElapsed5min())
            object[self.settingData.getDataNumber()].setAudioElapsed10min(filePath: self.settingData.getAudioElapsed10min())
            object[self.settingData.getDataNumber()].setAudioElapsed15min(filePath: self.settingData.getAudioElapsed15min())
            object[self.settingData.getDataNumber()].setAudioElapsed20min(filePath: self.settingData.getAudioElapsed20min())
            object[self.settingData.getDataNumber()].setAudioElapsed25min(filePath: self.settingData.getAudioElapsed25min())
            object[self.settingData.getDataNumber()].setAudioElapsed30min(filePath: self.settingData.getAudioElapsed30min())
            object[self.settingData.getDataNumber()].setAudioElapsed35min(filePath: self.settingData.getAudioElapsed35min())
            object[self.settingData.getDataNumber()].setAudioElapsed40min(filePath: self.settingData.getAudioElapsed40min())
            object[self.settingData.getDataNumber()].setAudioElapsed45min(filePath: self.settingData.getAudioElapsed45min())
            object[self.settingData.getDataNumber()].setAudioElapsed50min(filePath: self.settingData.getAudioElapsed50min())
            object[self.settingData.getDataNumber()].setAudioRemaining30sec(filePath: self.settingData.getAudioRemaining30sec())
            object[self.settingData.getDataNumber()].setAudioRemaining1min(filePath: self.settingData.getAudioRemaining1min())
            object[self.settingData.getDataNumber()].setAudioRemaining3min(filePath: self.settingData.getAudioRemaining3min())
            object[self.settingData.getDataNumber()].setAudioRemaining5min(filePath: self.settingData.getAudioRemaining5min())
            object[self.settingData.getDataNumber()].setAudioAppStartUp(filePath: self.settingData.getAudioAppStartUp())
            object[self.settingData.getDataNumber()].setAudioAppFinish(filePath: self.settingData.getAudioAppFinish())
            print("SettingData_\(self.settingData.getDataNumber())を更新しました")
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
            let fileName = URL(fileURLWithPath: self.settingData.getAudioFinish()).deletingPathExtension().lastPathComponent
            if let name = fileNameArray[fileName] {
                return name
            }
            return fileName
        } else if indexPath.section == 2 {
            // 経過時間通知
            switch indexPath.row {
            case 0:
                let fileName = URL(fileURLWithPath: self.settingData.getAudioElapsed5min()).deletingPathExtension().lastPathComponent
                if let name = fileNameArray[fileName] {
                    return name
                }
                return fileName
            case 1:
                let fileName = URL(fileURLWithPath: self.settingData.getAudioElapsed10min()).deletingPathExtension().lastPathComponent
                if let name = fileNameArray[fileName] {
                    return name
                }
                return fileName
            case 2:
                let fileName = URL(fileURLWithPath: self.settingData.getAudioElapsed15min()).deletingPathExtension().lastPathComponent
                if let name = fileNameArray[fileName] {
                    return name
                }
                return fileName
            case 3:
                let fileName = URL(fileURLWithPath: self.settingData.getAudioElapsed20min()).deletingPathExtension().lastPathComponent
                if let name = fileNameArray[fileName] {
                    return name
                }
                return fileName
            case 4:
                let fileName = URL(fileURLWithPath: self.settingData.getAudioElapsed25min()).deletingPathExtension().lastPathComponent
                if let name = fileNameArray[fileName] {
                    return name
                }
                return fileName
            case 5:
                let fileName = URL(fileURLWithPath: self.settingData.getAudioElapsed30min()).deletingPathExtension().lastPathComponent
                if let name = fileNameArray[fileName] {
                    return name
                }
                return fileName
            case 6:
                let fileName = URL(fileURLWithPath: self.settingData.getAudioElapsed35min()).deletingPathExtension().lastPathComponent
                if let name = fileNameArray[fileName] {
                    return name
                }
                return fileName
            case 7:
                let fileName = URL(fileURLWithPath: self.settingData.getAudioElapsed40min()).deletingPathExtension().lastPathComponent
                if let name = fileNameArray[fileName] {
                    return name
                }
                return fileName
            case 8:
                let fileName = URL(fileURLWithPath: self.settingData.getAudioElapsed45min()).deletingPathExtension().lastPathComponent
                if let name = fileNameArray[fileName] {
                    return name
                }
                return fileName
            case 9:
                let fileName = URL(fileURLWithPath: self.settingData.getAudioElapsed50min()).deletingPathExtension().lastPathComponent
                if let name = fileNameArray[fileName] {
                    return name
                }
                return fileName
            default:
                return "detail"
            }
        } else if indexPath.section == 3 {
            // 残り時間通知
            switch indexPath.row {
            case 0:
                let fileName = URL(fileURLWithPath: self.settingData.getAudioRemaining30sec()).deletingPathExtension().lastPathComponent
                if let name = fileNameArray[fileName] {
                    return name
                }
                return fileName
            case 1:
                let fileName = URL(fileURLWithPath: self.settingData.getAudioRemaining1min()).deletingPathExtension().lastPathComponent
                if let name = fileNameArray[fileName] {
                    return name
                }
                return fileName
            case 2:
                let fileName = URL(fileURLWithPath: self.settingData.getAudioRemaining3min()).deletingPathExtension().lastPathComponent
                if let name = fileNameArray[fileName] {
                    return name
                }
                return fileName
            case 3:
                let fileName = URL(fileURLWithPath: self.settingData.getAudioRemaining5min()).deletingPathExtension().lastPathComponent
                if let name = fileNameArray[fileName] {
                    return name
                }
                return fileName
            default:
                return "detail"
            }
        } else {
            // アプリ起動/終了時
            switch indexPath.row {
            case 0:
                let fileName = URL(fileURLWithPath: self.settingData.getAudioAppStartUp()).deletingPathExtension().lastPathComponent
                if let name = fileNameArray[fileName] {
                    return name
                }
                return fileName
            case 1:
                let fileName = URL(fileURLWithPath: self.settingData.getAudioAppFinish()).deletingPathExtension().lastPathComponent
                if let name = fileNameArray[fileName] {
                    return name
                }
                return fileName
            default:
                return "detail"
            }
        }
    }



}

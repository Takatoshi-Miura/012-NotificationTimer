//
//  AudioListViewController.swift
//  012-NotificationTimer
//
//  Created by Takatoshi Miura on 2020/09/08.
//  Copyright © 2020 Takatoshi Miura. All rights reserved.
//

import UIKit
import RealmSwift
import AudioToolbox
import AVFoundation

class AudioListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    // MARK:- ライフサイクルメソッド
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ナビゲーションタイトルの設定
        self.navigationBar.items![0].title = self.navigationTitle
        
        // ユーザーが保存した音声ファイルを取得
        loadUserSoundData()
        
        // テーブルビュー初期化
        tableViewInit()
    }
    
    
    
    // MARK:- UIの設定
    
    // ナビゲーションバー
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    // テーブルビュー
    @IBOutlet weak var tableView: UITableView!
    
    // キャンセルボタン
    @IBAction func cancelButton(_ sender: Any) {
        // モーダルを閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
    // 保存ボタン
    @IBAction func saveButton(_ sender: Any) {
        // 設定データに反映
        updateSettingData(filePath: audioPath, soundID: Int(soundID))
        
        // 遷移元に画面を取得する
        if let controller = self.presentingViewController as? AudioSettingViewController {
            // 設定データを渡す
            controller.settingData = self.settingData
            controller.tableView.reloadData()
            print("SettingData_\(self.settingData.getDataNumber())をAudioSettingViewControllerに渡しました")
            
            // モーダルを閉じる
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    // MARK:- 変数の宣言
    
    // ナビゲーションバー
    var navigationTitle = ""
    
    // 設定データ
    var settingData = SettingData()
    
    // テーブルビュー
    var selectCellTitle:String = ""
    var cellTitleArray:[[String]]  = [[],[],[],[]]
    let sectionTitleArray:[String] = ["通知","デフォルト","Apple","取り込んだデータ(50音順)"]
    let systemSoundArray:[SystemSoundID] = [1336,1314,1309,1322,1332,
                                            1330,1331,1335,1308,1016,
                                            1334,1300,1328,1329,1326,
                                            1325,1310,1327,1323,
                                            1304,1324,1302,1333,1321,1320]
    let systemSoundFileTitleArray:[String] = ["Update.caf","sms-received6.caf","sms-received3.caf","Calypso.caf","Suspense.caf",
                                              "Sherwood_Forest.caf","Spell.caf","Typewriters.caf","sms-received2.caf","tweet_sent.caf",
                                              "Tiptoes.caf","Voicemail.caf","News_Flash.caf","Noir.caf","Ladder.caf",
                                              "Fanfare.caf","sms-received4.caf","Minuet.caf","Choo_Choo.caf","alarm.caf",
                                              "Descent.caf","new-mail.caf","Telegraph.caf","Bloom.caf","Anticipate.caf"]
    let systemSoundTitleArray:[String]   = ["アップデート","エレクトロニック","ガラス","カリプソ","サスペンス",
                                            "シャーウッドの森","スペル","タイプライター","チャイム","ツイート",
                                            "つま先","トライトーン","ニュースフラッシュ","ノアール","はしご",
                                            "ファンファーレ","ホルン","メヌエット","機関車","警告",
                                            "降下","鐘","電報","曇り","予感"]
    var userAudioTitleArray:[String] = []
    var userAudioArray:[String] = []
    
    // サウンド
    var player = AVAudioPlayer()
    var audioPath:String = ""
    var soundID:SystemSoundID = 0
    
    
    
    // MARK:- テーブルビューの設定
    
    // セル数を返却
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitleArray[section].count
    }
    
    // セルを返却
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "audioCell", for: indexPath)
        
        // 選択したセルならチェックマークをつける
        cell.textLabel!.text = cellTitleArray[indexPath.section][indexPath.row]
        if cell.textLabel!.text == self.selectCellTitle {
            cell.textLabel?.textColor = UIColor.systemBlue
            cell.accessoryType = .checkmark
        } else {
            cell.textLabel?.textColor = UIColor.label
            cell.accessoryType = .none
        }
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
        // タップしたときの選択色を消去
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        // セルのタイトルを取得
        self.selectCellTitle = cellTitleArray[indexPath.section][indexPath.row]
        
        // セルにチェックマークをつける
        let cell = tableView.cellForRow(at:indexPath)
        cell?.textLabel?.textColor = UIColor.systemBlue
        cell?.accessoryType = .checkmark
        
        // テーブルビューをリロード(前のセルからチェックマークを外すため)
        tableView.reloadData()
        
        // 初期化
        audioPath = ""
        soundID = 0
        
        // パスを作成
        switch indexPath.section {
        case 0:
            // OFF
            audioPath = "OFF"
        case 1:
            // パスを作成
            audioPath = Bundle.main.path(forResource: "デフォルト(\(navigationTitle))", ofType:"mp3")!
        case 2:
            // パスを作成
            let libraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
            audioPath = libraryPath + "/Audio/UISounds/\(systemSoundFileTitleArray[indexPath.row])"
            
            // サウンドIDを取得
            soundID = systemSoundArray[indexPath.row]
        case 3:
            // パスを作成
            audioPath = NSHomeDirectory() + "/Documents/Audio/\(userAudioArray[indexPath.row])"
        default:
            break
        }
        
        // サウンドを再生
        playAudio(filePath: audioPath, soundID: Int(soundID))
    }
    
    
    
    // MARK:- サウンド関連
    
    // オーディオ再生メソッド
    func playAudio(filePath path:String?,soundID id:Int) {
        if let audioPath = path {
            // URLを作成
            let audioURL = URL(fileURLWithPath: audioPath)
            
            // 再生中なら停止
            if player.isPlaying {
                player.stop()
            }
            
            // 再生
            do {
                // カスタムオーディオの再生
                player = try AVAudioPlayer(contentsOf: audioURL)
                player.play()
            } catch {
                // システムサウンドの再生
                if let soundUrl:URL = URL(string: audioPath) {
                    var soundID:SystemSoundID = SystemSoundID(id)
                    AudioServicesCreateSystemSoundID(soundUrl as CFURL, &soundID)
                    AudioServicesPlaySystemSound(soundID)
                } else {
                    print("再生処理でエラーが発生しました")
                }
            }
        } else {
            print("ファイルがありません")
        }
    }
    
    
    
    // MARK:- その他
    
    // テーブルビュー初期化
    func tableViewInit() {
        // OFFを設定
        cellTitleArray[0] = ["OFF"]
        
        // デフォルトサウンドを設定
        cellTitleArray[1] = ["デフォルト(\(navigationTitle))"]
        
        // システムサウンドを設定
        cellTitleArray[2] = systemSoundTitleArray
        
        // 取り込んだ音声データを設定
        cellTitleArray[3] = userAudioTitleArray
    }
    
    // ユーザーが取り込んだ音声データをロードするメソッド
    func loadUserSoundData() {
        // ユーザーが取り込んだ音声データフォルダのパスを取得
        let userAudioPath = NSHomeDirectory() + "/Documents/Audio"
        
        // フォルダ内のmp3ファイル名を全て取得＆50音順にソート
        do {
            // ファイル名を取得
            self.userAudioArray = try FileManager.default.contentsOfDirectory(atPath: userAudioPath)
            self.userAudioArray = self.userAudioArray.sorted()
            
            // 拡張子を除く
            let titleArray = self.userAudioArray
            for title in titleArray {
                self.userAudioTitleArray.append(URL(fileURLWithPath: NSHomeDirectory() + "/Documents/Audio/\(title)").deletingPathExtension().lastPathComponent)
            }
        } catch {
            print(error)
        }
    }
    
    // 設定データを更新するメソッド
    func updateSettingData(filePath path:String,soundID id:Int) {
        switch self.navigationTitle {
        case "終了時":
            self.settingData.setAudioFinish(filePath: path)
            self.settingData.setAudioFinishSoundID(id: id)
        case "5分経過":
            self.settingData.setAudioElapsed5min(filePath: path)
            self.settingData.setAudioElapsed5minSoundID(id: id)
        case "10分経過":
            self.settingData.setAudioElapsed10min(filePath: path)
            self.settingData.setAudioElapsed10minSoundID(id: id)
        case "15分経過":
            self.settingData.setAudioElapsed15min(filePath: path)
            self.settingData.setAudioElapsed15minSoundID(id: id)
        case "20分経過":
            self.settingData.setAudioElapsed20min(filePath: path)
            self.settingData.setAudioElapsed20minSoundID(id: id)
        case "25分経過":
            self.settingData.setAudioElapsed25min(filePath: path)
            self.settingData.setAudioElapsed25minSoundID(id: id)
        case "30分経過":
            self.settingData.setAudioElapsed30min(filePath: path)
            self.settingData.setAudioElapsed30minSoundID(id: id)
        case "35分経過":
            self.settingData.setAudioElapsed35min(filePath: path)
            self.settingData.setAudioElapsed35minSoundID(id: id)
        case "40分経過":
            self.settingData.setAudioElapsed40min(filePath: path)
            self.settingData.setAudioElapsed40minSoundID(id: id)
        case "45分経過":
            self.settingData.setAudioElapsed45min(filePath: path)
            self.settingData.setAudioElapsed45minSoundID(id: id)
        case "50分経過":
            self.settingData.setAudioElapsed50min(filePath: path)
            self.settingData.setAudioElapsed50minSoundID(id: id)
        case "残り30秒":
            self.settingData.setAudioRemaining30sec(filePath: path)
            self.settingData.setAudioRemaining30secSoundID(id: id)
        case "残り1分":
            self.settingData.setAudioRemaining1min(filePath: path)
            self.settingData.setAudioRemaining1minSoundID(id: id)
        case "残り3分":
            self.settingData.setAudioRemaining3min(filePath: path)
            self.settingData.setAudioRemaining3minSoundID(id: id)
        case "残り5分":
            self.settingData.setAudioRemaining5min(filePath: path)
            self.settingData.setAudioRemaining5minSoundID(id: id)
        case "アプリ起動時":
            self.settingData.setAudioAppStartUp(filePath: path)
            self.settingData.setAudioAppStartUpSoundID(id: id)
        default:
            break
        }
    }
    
    
}

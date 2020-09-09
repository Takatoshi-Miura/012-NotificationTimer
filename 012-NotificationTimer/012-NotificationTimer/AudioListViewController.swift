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
        // SettingDataを保存する
        
        
        // モーダルを閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK:- 変数の宣言
    
    // ナビゲーションバー
    var navigationTitle = ""
    
    // 設定データ
    var settingData = SettingData()
    
    // テーブルビュー
    var selectIndex:IndexPath?
    var cellTitleArray:[[String]]  = [[],[],[],[]]
    let sectionTitleArray:[String] = ["通知","デフォルト","Apple","取り込んだデータ"]
    let systemSoundArray:[SystemSoundID] = [1336,1314,1309,1322,1332,
                                            1330,1331,1335,1308,1016,
                                            1334,1300,1328,1329,1326,
                                            1325,1310,1327,1323,
                                            1304,1324,1302,1333,1321,1320]
    let systemSoundTitleArray:[String]   = ["アップデート","エレクトロニック","ガラス","カリプソ","サスペンス",
                                            "シャーウッドの森","スペル","タイプライター","チャイム","ツイート",
                                            "つま先","トライトーン","ニュースフラッシュ","ノアール","はしご",
                                            "ファンファーレ","ホルン","メヌエット","機関車","警告",
                                            "降下","鐘","電報","曇り","予感"]
    var userAudioTitleArray:[String] = []
    
    // サウンド
    var player = AVAudioPlayer()
    
    
    
    // MARK:- テーブルビューの設定
    
    // セル数を返却
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitleArray[section].count
    }
    
    // セルを返却
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "audioCell", for: indexPath)
        cell.textLabel!.text = cellTitleArray[indexPath.section][indexPath.row]
        if self.selectIndex != nil {
            if indexPath == self.selectIndex {
                cell.textLabel?.textColor = UIColor.systemBlue
                cell.accessoryType = .checkmark
            } else {
                cell.textLabel?.textColor = UIColor.label
                cell.accessoryType = .none
            }
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
        // 前に選択されていたセルからチェックマークを外す
        if let index = self.selectIndex {
            let cell = tableView.cellForRow(at:index)
            cell?.textLabel?.textColor = UIColor.label
            cell?.accessoryType = .none
        }
        
        // indexを取得
        self.selectIndex = indexPath
        
        // セルにチェックマークをつける
        let cell = tableView.cellForRow(at:indexPath)
        cell?.textLabel?.textColor = UIColor.systemBlue
        cell?.accessoryType = .checkmark
        
        // タップしたときの選択色を消去
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        switch indexPath.section {
        case 1:
            // カスタムサウンドを再生
            playCustomSound(fileName: "デフォルト(\(navigationTitle))")
        case 2:
            // システムサウンドを再生
            playSystemSound(soundID: systemSoundArray[indexPath.row])
        case 3:
            // ユーザーが取り込んだmp3ファイルを再生
            playUserAudio(fileName: userAudioTitleArray[indexPath.row])
        default:
            break
        }
    }
    
    
    
    // MARK:- サウンド関連
    
    // システムサウンド再生メソッド
    func playSystemSound(soundID id:SystemSoundID) {
        var soundID = id
        if let soundUrl = CFBundleCopyResourceURL(CFBundleGetMainBundle(), nil, nil, nil) {
            AudioServicesCreateSystemSoundID(soundUrl, &soundID)
            AudioServicesPlaySystemSound(soundID)
        }
    }
    
    // カスタムサウンド再生メソッド
    func playCustomSound(fileName name:String) {
        // パスを作成
        if let audioPath = Bundle.main.path(forResource: "\(name)", ofType:"mp3") {
            let audioUrl  = URL(fileURLWithPath: audioPath)
            
            // 再生
            do {
                player = try AVAudioPlayer(contentsOf: audioUrl)
                player.play()
            } catch {
                print("再生処理でエラーが発生しました")
            }
        } else {
            print("ファイルがありません")
        }
    }
    
    // ユーザーが取り込んだサウンドの再生メソッド
    func playUserAudio(fileName name:String) {
        // ユーザーが取り込んだ音声データフォルダのパスを取得＆URLに変換
        let userAudioPath = NSHomeDirectory() + "/Documents/Audio/\(name)"
        let userAudioURL  = URL(fileURLWithPath: userAudioPath)
        
        // 再生
        do {
            player = try AVAudioPlayer(contentsOf: userAudioURL)
            player.play()
        } catch {
            print("再生処理でエラーが発生しました")
        }
    }
    
    
    
    // MARK:- その他
    
    // テーブルビュー初期化
    func tableViewInit() {
        // OFFを設定
        cellTitleArray[0] = ["OFF"]
        
        // デフォルトサウンドを設定
        cellTitleArray[1] = ["\(navigationTitle)"]
        
        // システムサウンドを設定
        cellTitleArray[2] = systemSoundTitleArray
        
        // 取り込んだ音声データを設定
        cellTitleArray[3] = userAudioTitleArray
    }
    
    // ユーザーが取り込んだ音声データをロードするメソッド
    func loadUserSoundData() {
        // ユーザーが取り込んだ音声データフォルダのパスを取得
        let userAudioPath = NSHomeDirectory() + "/Documents/Audio"
        
        // フォルダ内のmp3データ名を全て取得＆50音順にソート
        do {
            self.userAudioTitleArray = try FileManager.default.contentsOfDirectory(atPath: userAudioPath)
            self.userAudioTitleArray = self.userAudioTitleArray.sorted()
            print(self.userAudioTitleArray)
        } catch {
            print(error)
        }
        
    }
    
    
}

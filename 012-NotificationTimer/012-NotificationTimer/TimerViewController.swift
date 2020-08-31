//
//  TimerViewController.swift
//  012-NotificationTimer
//
//  Created by Takatoshi Miura on 2020/08/31.
//  Copyright © 2020 Takatoshi Miura. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    // MARK: -ライフサイクルメソッド
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // テーブルビュー初期設定
        tableViewInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // ナビゲーションバーを非表示(音声選択画面から戻ってきた際も非表示にしたいため)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    
    // MARK: -UIの設定
    
    // 時間表示ラベル
    @IBOutlet weak var timeButton: UIButton!
    @IBAction func timeButton(_ sender: Any) {
    }
    
    // スタートボタン
    @IBOutlet weak var startButton: UIButton!
    @IBAction func startButton(_ sender: Any) {
    }
    
    // リセットボタン
    @IBOutlet weak var resetButton: UIButton!
    @IBAction func resetButton(_ sender: Any) {
    }
    
    // ハンバーガーメニュー
    @IBAction func hamburgerMenu(_ sender: Any) {
    }
    
    // テーブルビュー
    @IBOutlet weak var tableView: UITableView!
    
    
    
    // MARK: -テーブルビューの設定
    
    // 初期化メソッド
    func tableViewInit() {
        // テーブルビューのスクロールを禁止
        tableView.isScrollEnabled = false
        
        // データのないセルを非表示
        tableView.tableFooterView = UIView()
    }
    
    // セル数を返却
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1    // 音声セルのみ
    }
    
    // セルを返却
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 音声セルを返却
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "audioCell", for: indexPath)
        cell.textLabel!.text = "音声"
        return cell
    }
    
    // セクション名を返却
    func tableView(_ tableView:UITableView, titleForHeaderInSection section:Int) -> String?{
        return "設定"
    }
    
    // セクションの個数を返却
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // セクションの高さを返却
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    // セルをタップしたときの処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // タップしたときの選択色を消去
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        // 音声設定画面に遷移
        self.performSegue(withIdentifier: "goAudioSetting", sender: nil)
    }
    
    


}

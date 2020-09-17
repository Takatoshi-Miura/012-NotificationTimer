//
//  TimerViewController.swift
//  012-NotificationTimer
//
//  Created by Takatoshi Miura on 2020/08/31.
//  Copyright © 2020 Takatoshi Miura. All rights reserved.
//

import UIKit
import RealmSwift
import AVFoundation
import GoogleMobileAds
import UserNotifications

class TimerViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate,AVAudioPlayerDelegate {

    // MARK:- ライフサイクルメソッド
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // データベースのパスを取得
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        // 画面自動ロックをしない
        UIApplication.shared.isIdleTimerDisabled = true
        
        // アプリフォルダ構成の初期化
        directoryInit()
        
        // 広告表示
        displayAdsense()
        
        // ラベルの文字を縁取る
        timeLabel.makeOutLine(strokeWidth: -2.0, oulineColor: UIColor.black, foregroundColor: UIColor.white)
        
        // バックグラウンド,フォアグラウンド判定の追加
        addNotification()
        
        // データをロード
        loadSettingData()
        loadBackgroundImage()
        loadNotificationRequest()
        
        // 通知を削除
        deleteNotificationRequest()
        
        // ラベルにcountを反映
        displayCount()
        
        // デリゲートの設定
        player.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 利用規約の同意
        displayAgreement()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // 通知の削除
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    // MARK:- UIの設定
    
    // 時間表示ラベル
    @IBOutlet weak var timeLabel: UILabel!
    override func touchesBegan(_ touches: Set<UITouch>,with event: UIEvent?){
        // timeLabelをタップした時の処理
        if touchedLabel(touches: touches,view:timeLabel) {
            // Pickerを出す
            openPicker()
            return
        } else {
            // Pickerをしまう
            closePicker()
        }
    }
    
    func touchedLabel(touches: Set<UITouch>, view:UILabel)->Bool{
        for touch: AnyObject in touches {
            let t: UITouch = touch as! UITouch
            if t.view?.tag == view.tag {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    // スタートボタン
    @IBOutlet weak var startButton: UIButton!
    private let startImage = UIImage(named: "Start Button")
    private let stopImage  = UIImage(named: "Stop Button")
    @IBAction func startButton(_ sender: Any) {
        if timer.isValid && self.settingData.count > 0 {
            // タイマー稼動中にタップで一時停止
            timer.invalidate()
            timerNotification.invalidate()
            
            // 通知を削除
            deleteNotificationRequest()
            
            // フラグ設定
            timerIsStart = false
            
            // ボタン画像をスタート用にセット
            startButton.setImage(startImage, for: .normal)
        } else if self.settingData.count > 0 {
            // タイマー停止中にタップで再開
            timer = Timer.scheduledTimer(timeInterval: 0.01, target:self, selector:#selector(countDown), userInfo:nil, repeats:true)
            timerNotification = Timer.scheduledTimer(timeInterval: 1, target:self, selector:#selector(notification), userInfo:nil, repeats:true)
            
            // フラグ設定
            timerIsStart = true
            
            // バナー通知をセット
            setElapsedTimeNotification()
            
            // ボタン画像を一時停止用にセット
            startButton.setImage(stopImage, for: .normal)
        } else {
            // ボタン画像をスタート用にセット
            startButton.setImage(startImage, for: .normal)
        }
    }
    
    // リセットボタン
    @IBOutlet weak var resetButton: UIButton!
    @IBAction func resetButton(_ sender: Any) {
        if timer.isValid {
            // タイマーを停止
            timer.invalidate()
            timerNotification.invalidate()
            
            // 通知を削除
            deleteNotificationRequest()
            
            // フラグ設定
            timerIsStart = false
        }
        
        if self.settingData.count == Float(minute[minuteIndex] * 60 + second[secondIndex]) && self.settingData.count > 0 {
            // ゼロにセット
            self.settingData.count = 0
            timePicker.selectRow(0, inComponent: 0, animated: true)
            timePicker.selectRow(0, inComponent: 1, animated: true)
            
            // 時間表示に反映
            displayCount()
            
            // フラグ設定
            timerIsStart = false
            
            // ボタン画像をスタート用にセット
            startButton.setImage(startImage, for: .normal)
        } else if self.settingData.count > 0 {
            // 以前セットした時間に戻す
            self.settingData.setCount(time: Float(minute[minuteIndex] * 60 + second[secondIndex]))
            
            // ラベルにセット
            displayCount()
            
            // フラグ設定
            timerIsStart = false
            
            // ボタン画像をスタート用にセット
            startButton.setImage(startImage, for: .normal)
        }
    }
    
    // ハンバーガーメニュー
    @IBAction func hamburgerMenu(_ sender: Any) {
        // セグエ遷移
    }
    
    // 背景画像
    @IBOutlet weak var imageView: UIImageView!
    
    // カメラボタン
    @IBAction func camaraButton(_ sender: Any) {
        // アラートを表示
        displayAlert()
    }
    
    // オーディオボタン
    @IBAction func audioButton(_ sender: Any) {
        // セグエ遷移
    }
    
    
    
    // MARK:- 変数の宣言
    
    // タイマー
    var timer = Timer()
    var timerNotification = Timer()
    var backgroundDate: NSDate!
    var timerIsStart:Bool = false
    var pre_count:Float = 0.0
    
    // pickerView
    var pickerView = UIView()
    var timePicker = UIPickerView()
    let minute:[Int] = (0...99).map { $0 }
    let second:[Int] = (0...59).map { $0 }
    var minuteIndex:Int = 0
    var secondIndex:Int = 0
    
    // 設定データ
    var settingData:SettingData = SettingData(dataNumber: 0)
    
    // 音声再生用
    var player = AVAudioPlayer()
    
    // 通知用
    var requestIDArray:[String] = []
    
    // 広告用
    let AdMobID = "ca-app-pub-5239611561920614/8530378558"
    let TEST_ID = "ca-app-pub-3940256099942544/2934735716"
    let AdMobTest:Bool = true
    
    
    
    // MARK:- Pickerの設定
    
    // Pickerの列数を返却
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2    // 分,秒の2列
    }
    
    // Pickerの項目数を返却
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return minute.count     // 分の項目数
        } else {
            return second.count     // 秒の項目数
        }
    }
    
    // Pickerの文字を返却
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // 各列に応じて返却
        if component == 0 {
            return "\(minute[row])"     // 分
        } else {
            return "\(second[row])"     // 秒
        }
    }
    
    // Pickerの初期化メソッド
    func pickerInit() {
        // Pickerの設定
        timePicker.delegate = self
        timePicker.dataSource = self
        timePicker.backgroundColor = UIColor.systemGray5
        timePicker.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: timePicker.bounds.size.height)
        setComponentLabels()
        
        // ツールバーの宣言
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.timePickerDone))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancel))
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelItem,flexibleItem,doneItem], animated: true)
        
        // ビューを追加
        pickerView = UIView(frame: timePicker.bounds)
        pickerView.addSubview(timePicker)
        pickerView.addSubview(toolbar)
        view.addSubview(pickerView)
    }
    
    // 完了ボタンの処理
    @objc func timePickerDone() {
        // 選択された時間を取得
        minuteIndex = timePicker.selectedRow(inComponent: 0)
        secondIndex = timePicker.selectedRow(inComponent: 1)
        
        // 秒数を計算し、タイマーに時間をセットセット
        self.settingData.setCount(time: Float(minute[minuteIndex] * 60 + second[secondIndex]))
        
        // 経過時間を計算するためcountの値を保持
        pre_count = self.settingData.getCount()
        
        // ラベルにセット
        displayCount()
        
        // SettingDataに保存
        updateSettingData()
        
        // Pickerをしまう
        closePicker()
    }
    
    // キャンセルボタンの処理
    @objc func cancel() {
        // Pickerをしまう
        closePicker()
    }
    
    // Pickerの選択肢に単位をつけるメソッド
    public func setComponentLabels() {
        // ラベルの宣言
        var labels :[UILabel] = []
        let labelText = ["min", "sec"]
        
        // ラベルの位置
        let fontSize = UIFont.systemFontSize
        let labelTop = timePicker.bounds.origin.y + timePicker.bounds.height / 2 - fontSize // 選択部分のY座標
        let labelHeight = timePicker.rowSize(forComponent: 0).height // 選択部分の高さ
        var labelOffset = timePicker.bounds.origin.x // Componentの右端
        
        // Compoentの数だけ、ラベルを更新
        for i in 0...1 {
            // ラベルが初期化されていなければ作成
            if labels.count == i {
                let label = UILabel()
                label.text = labelText[i]
                label.font = UIFont.boldSystemFont(ofSize: fontSize)
                label.sizeToFit()
                timePicker.addSubview(label)
                labels.append(label)
            }
            
            // ラベルの位置を決める
            let labelWidth = labels[i].frame.width
            labelOffset += timePicker.rowSize(forComponent: i).width
            labels[i].frame = CGRect(x: labelOffset - labelWidth - 20, y: labelTop, width: labelWidth, height: labelHeight)
        }
    }

    // Pickerを画面下から開くメソッド
    func openPicker() {
        // ビューの初期化
        self.pickerView.removeFromSuperview()
        
        // Picker初期設定
        pickerInit()
        
        // 下からPickerを呼び出す
        pickerView.frame.origin.y = UIScreen.main.bounds.size.height
        UIView.animate(withDuration: 0.3) {
            self.pickerView.frame.origin.y = UIScreen.main.bounds.size.height - self.pickerView.bounds.size.height
        }
    }
    
    // Pickerをしまうメソッド
    func closePicker() {
        // Pickerをしまう
        UIView.animate(withDuration: 0.3) {
            self.pickerView.frame.origin.y = UIScreen.main.bounds.size.height
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            // ビューの初期化
            self.pickerView.removeFromSuperview()
        }
    }
    
    
    
    // MARK:- データ関連
    
    // データを取得するメソッド
    func loadSettingData() {
        // Realmデータベースにアクセス
        let realm = try! Realm()
    
        // データの取得
        let object = realm.objects(SettingData.self)
        
        // データの反映
        self.settingData.setDataNumber(number: object[self.settingData.getDataNumber()].getDataNumber())
        self.settingData.setCount(time: object[self.settingData.getDataNumber()].getCount())
        self.settingData.setMannerMode(bool: object[self.settingData.getDataNumber()].getMannerMode())
        self.settingData.setAudioFinishSoundID(id: object[self.settingData.getDataNumber()].getAudioFinishSoundID())
        self.settingData.setAudioElapsed5minSoundID(id: object[self.settingData.getDataNumber()].getAudioElapsed5minSoundID())
        self.settingData.setAudioElapsed10minSoundID(id: object[self.settingData.getDataNumber()].getAudioElapsed10minSoundID())
        self.settingData.setAudioElapsed15minSoundID(id: object[self.settingData.getDataNumber()].getAudioElapsed15minSoundID())
        self.settingData.setAudioElapsed20minSoundID(id: object[self.settingData.getDataNumber()].getAudioElapsed20minSoundID())
        self.settingData.setAudioElapsed25minSoundID(id: object[self.settingData.getDataNumber()].getAudioElapsed25minSoundID())
        self.settingData.setAudioElapsed30minSoundID(id: object[self.settingData.getDataNumber()].getAudioElapsed30minSoundID())
        self.settingData.setAudioElapsed35minSoundID(id: object[self.settingData.getDataNumber()].getAudioElapsed35minSoundID())
        self.settingData.setAudioElapsed40minSoundID(id: object[self.settingData.getDataNumber()].getAudioElapsed40minSoundID())
        self.settingData.setAudioElapsed45minSoundID(id: object[self.settingData.getDataNumber()].getAudioElapsed45minSoundID())
        self.settingData.setAudioElapsed50minSoundID(id: object[self.settingData.getDataNumber()].getAudioElapsed50minSoundID())
        self.settingData.setAudioRemaining30secSoundID(id: object[self.settingData.getDataNumber()].getAudioRemaining30secSoundID())
        self.settingData.setAudioRemaining1minSoundID(id: object[self.settingData.getDataNumber()].getAudioRemaining1minSoundID())
        self.settingData.setAudioRemaining3minSoundID(id: object[self.settingData.getDataNumber()].getAudioRemaining3minSoundID())
        self.settingData.setAudioRemaining5minSoundID(id: object[self.settingData.getDataNumber()].getAudioRemaining5minSoundID())
        self.settingData.setAudioAppStartUpSoundID(id: object[self.settingData.getDataNumber()].getAudioAppStartUpSoundID())
        self.settingData.setAudioAppFinishSoundID(id: object[self.settingData.getDataNumber()].getAudioAppFinishSoundID())
        self.settingData.setAudioFinish(filePath: object[self.settingData.getDataNumber()].getAudioFinish())
        self.settingData.setAudioElapsed5min(filePath: object[self.settingData.getDataNumber()].getAudioElapsed5min())
        self.settingData.setAudioElapsed10min(filePath: object[self.settingData.getDataNumber()].getAudioElapsed10min())
        self.settingData.setAudioElapsed15min(filePath: object[self.settingData.getDataNumber()].getAudioElapsed15min())
        self.settingData.setAudioElapsed20min(filePath: object[self.settingData.getDataNumber()].getAudioElapsed20min())
        self.settingData.setAudioElapsed25min(filePath: object[self.settingData.getDataNumber()].getAudioElapsed25min())
        self.settingData.setAudioElapsed30min(filePath: object[self.settingData.getDataNumber()].getAudioElapsed30min())
        self.settingData.setAudioElapsed35min(filePath: object[self.settingData.getDataNumber()].getAudioElapsed35min())
        self.settingData.setAudioElapsed40min(filePath: object[self.settingData.getDataNumber()].getAudioElapsed40min())
        self.settingData.setAudioElapsed45min(filePath: object[self.settingData.getDataNumber()].getAudioElapsed45min())
        self.settingData.setAudioElapsed50min(filePath: object[self.settingData.getDataNumber()].getAudioElapsed50min())
        self.settingData.setAudioRemaining30sec(filePath: object[self.settingData.getDataNumber()].getAudioRemaining30sec())
        self.settingData.setAudioRemaining1min(filePath: object[self.settingData.getDataNumber()].getAudioRemaining1min())
        self.settingData.setAudioRemaining3min(filePath: object[self.settingData.getDataNumber()].getAudioRemaining3min())
        self.settingData.setAudioRemaining5min(filePath: object[self.settingData.getDataNumber()].getAudioRemaining5min())
        self.settingData.setAudioAppStartUp(filePath: object[self.settingData.getDataNumber()].getAudioAppStartUp())
        self.settingData.setAudioAppFinish(filePath: object[self.settingData.getDataNumber()].getAudioAppFinish())
        print("SettingData_\(self.settingData.getDataNumber())をロードしました")
    }
    
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
            object[self.settingData.getDataNumber()].setAudioFinishSoundID(id: self.settingData.getAudioFinishSoundID())
            object[self.settingData.getDataNumber()].setAudioElapsed5minSoundID(id: self.settingData.getAudioElapsed5minSoundID())
            object[self.settingData.getDataNumber()].setAudioElapsed10minSoundID(id: self.settingData.getAudioElapsed10minSoundID())
            object[self.settingData.getDataNumber()].setAudioElapsed15minSoundID(id: self.settingData.getAudioElapsed15minSoundID())
            object[self.settingData.getDataNumber()].setAudioElapsed20minSoundID(id: self.settingData.getAudioElapsed20minSoundID())
            object[self.settingData.getDataNumber()].setAudioElapsed25minSoundID(id: self.settingData.getAudioElapsed25minSoundID())
            object[self.settingData.getDataNumber()].setAudioElapsed30minSoundID(id: self.settingData.getAudioElapsed30minSoundID())
            object[self.settingData.getDataNumber()].setAudioElapsed35minSoundID(id: self.settingData.getAudioElapsed35minSoundID())
            object[self.settingData.getDataNumber()].setAudioElapsed40minSoundID(id: self.settingData.getAudioElapsed40minSoundID())
            object[self.settingData.getDataNumber()].setAudioElapsed45minSoundID(id: self.settingData.getAudioElapsed45minSoundID())
            object[self.settingData.getDataNumber()].setAudioElapsed50minSoundID(id: self.settingData.getAudioElapsed50minSoundID())
            object[self.settingData.getDataNumber()].setAudioRemaining30secSoundID(id: self.settingData.getAudioRemaining30secSoundID())
            object[self.settingData.getDataNumber()].setAudioRemaining1minSoundID(id: self.settingData.getAudioRemaining1minSoundID())
            object[self.settingData.getDataNumber()].setAudioRemaining3minSoundID(id: self.settingData.getAudioRemaining3minSoundID())
            object[self.settingData.getDataNumber()].setAudioRemaining5minSoundID(id: self.settingData.getAudioRemaining5minSoundID())
            object[self.settingData.getDataNumber()].setAudioAppStartUpSoundID(id: self.settingData.getAudioAppStartUpSoundID())
            object[self.settingData.getDataNumber()].setAudioAppFinishSoundID(id: self.settingData.getAudioAppFinishSoundID())
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
    
    // 背景画像を取得するメソッド
    func loadBackgroundImage() {
        // 背景画像の取得
        let backgroundPath = NSHomeDirectory() + "/Library"
        let backgroundURL  = URL(fileURLWithPath: backgroundPath)
        let imagePath = backgroundURL.appendingPathComponent("backgroundImage_\(self.settingData.getDataNumber()).png")
        do {
            try self.imageView.image = UIImage(data: Data(contentsOf: imagePath))
            print("backgroundImage_\(self.settingData.getDataNumber())を取得しました")
        } catch {
            print("背景画像がありません")
        }
    }
    
    // 背景画像を保存するメソッド
    func saveBackgroundImage() {
        // 保存先のパスを取得＆URLに変換
        let backgroundPath = NSHomeDirectory() + "/Library"
        let backgroundURL  = URL(fileURLWithPath: backgroundPath)
        
        // 背景画像を保存
        let imagePath = backgroundURL.appendingPathComponent("backgroundImage_\(self.settingData.getDataNumber()).png")
        do {
            try self.imageView.image?.pngData()!.write(to: imagePath)
            print("backgroundImage_\(self.settingData.getDataNumber())を保存しました")
        } catch {
            print("背景画像を保存できませんでした")
        }
    }
    
    
    
    // MARK:- 画面遷移
    
    // 画面遷移時に呼ばれる処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goAudioSettingViewController" {
            // settingDataを渡す
            let audioSettingViewController = segue.destination as! AudioSettingViewController
            audioSettingViewController.settingData = self.settingData
            print("データをAudioSettingViewControllerに渡しました")
        }
    }
    
    
    
    // MARK:- タイマー関連
    
    //タイマーから呼び出されるメソッド
    @objc func countDown(){
        // 残り時間の計算
        self.settingData.count -= 0.01
        
        // ゼロならタイマーを停止
        if self.settingData.count < 0 {
            self.settingData.count = 0
            timer.invalidate()
            timerNotification.invalidate()
        }
        
        // ラベルに反映
        displayCount()
    }
    
    // タイマーから呼び出されるメソッド
    @objc func notification() {
        // 経過時間の計算
        let elapsedTime = pre_count - self.settingData.getCount()
        
        // 規定時間なら通知
        self.notificationTime(elapsedTime: elapsedTime)
    }
    
    
    
    // MARK:- 通知関連
    
    // 通知リクエストを取得するメソッド
    func loadNotificationRequest() {
        if let array = UserDefaults.standard.array(forKey: "requestIDArray") as? [String] {
            self.requestIDArray = array
            print("通知リクエストを取得しました")
        } else {
            print("通知リクエストはありません")
        }
    }
    
    // 通知リクエストを保存するメソッド
    func saveNotificationRequest() {
        UserDefaults.standard.set(self.requestIDArray, forKey: "requestIDArray")
        print("通知リクエストを保存しました")
    }
    
    // 通知リクエストを削除するメソッド
    func deleteNotificationRequest() {
        if self.requestIDArray.isEmpty == false {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: self.requestIDArray)
            print("通知リクエストを削除しました")
        }
    }
    
    // 規定時間を通知するメソッド
    func notificationTime(elapsedTime time:Float) {
        // 経過時間の通知
        switch Int(time) {
        case 60 * 5:
            // 5分経過
            if self.settingData.getAudioElapsed5min() == "OFF" {
                print("通知OFFのため通知しない")
            } else {
                playAudio(filePath: self.settingData.audioElapsed5min,soundID: self.settingData.getAudioElapsed5minSoundID())
                print("5分経過")
            }
        case 60 * 10:
            // 10分経過
            if self.settingData.getAudioElapsed10min() == "OFF" {
                print("通知OFFのため通知しない")
            } else {
                playAudio(filePath: self.settingData.audioElapsed10min,soundID: self.settingData.getAudioElapsed10minSoundID())
                print("10分経過")
            }
        case 60 * 15:
            // 15分経過
            if self.settingData.getAudioElapsed15min() == "OFF" {
                print("通知OFFのため通知しない")
            } else {
                playAudio(filePath: self.settingData.audioElapsed15min,soundID: self.settingData.getAudioElapsed15minSoundID())
                print("15分経過")
            }
        case 60 * 20:
            // 20分経過
            if self.settingData.getAudioElapsed20min() == "OFF" {
                print("通知OFFのため通知しない")
            } else {
                playAudio(filePath: self.settingData.audioElapsed20min,soundID: self.settingData.getAudioElapsed20minSoundID())
                print("20分経過")
            }
        case 60 * 25:
            // 25分経過
            if self.settingData.getAudioElapsed25min() == "OFF" {
                print("通知OFFのため通知しない")
            } else {
                playAudio(filePath: self.settingData.audioElapsed25min,soundID: self.settingData.getAudioElapsed25minSoundID())
                print("25分経過")
            }
        case 60 * 30:
            // 30分経過
            if self.settingData.getAudioElapsed30min() == "OFF" {
                print("通知OFFのため通知しない")
            } else {
                playAudio(filePath: self.settingData.audioElapsed30min,soundID: self.settingData.getAudioElapsed30minSoundID())
                print("30分経過")
            }
        case 60 * 35:
            // 35分経過
            if self.settingData.getAudioElapsed35min() == "OFF" {
                print("通知OFFのため通知しない")
            } else {
                playAudio(filePath: self.settingData.audioElapsed35min,soundID: self.settingData.getAudioElapsed35minSoundID())
                print("35分経過")
            }
        case 60 * 40:
            // 40分経過
            if self.settingData.getAudioElapsed40min() == "OFF" {
                print("通知OFFのため通知しない")
            } else {
                playAudio(filePath: self.settingData.audioElapsed40min,soundID: self.settingData.getAudioElapsed40minSoundID())
                print("40分経過")
            }
        case 60 * 45:
            // 45分経過
            if self.settingData.getAudioElapsed45min() == "OFF" {
                print("通知OFFのため通知しない")
            } else {
                playAudio(filePath: self.settingData.audioElapsed45min,soundID: self.settingData.getAudioElapsed45minSoundID())
                print("45分経過")
            }
        case 60 * 50:
            // 50分経過
            if self.settingData.getAudioElapsed50min() == "OFF" {
                print("通知OFFのため通知しない")
            } else {
                playAudio(filePath: self.settingData.audioElapsed50min,soundID: self.settingData.getAudioElapsed50minSoundID())
                print("50分経過")
            }
        default:
            break
        }
        
        // 残り時間の通知
        switch Int(self.settingData.count) {
        case 60 * 5:
            // 残り5分
            if self.settingData.getAudioRemaining5min() == "OFF" {
                print("通知OFFのため通知しない")
            } else {
                playAudio(filePath: self.settingData.audioRemaining5min,soundID: self.settingData.getAudioRemaining5minSoundID())
                print("残り5分")
            }
        case 60 * 3:
            // 残り3分
            if self.settingData.getAudioRemaining3min() == "OFF" {
                print("通知OFFのため通知しない")
            } else {
                playAudio(filePath: self.settingData.audioRemaining3min,soundID: self.settingData.getAudioRemaining3minSoundID())
                print("残り3分")
            }
        case 60 * 1:
            // 残り1分
            if self.settingData.getAudioRemaining1min() == "OFF" {
                print("通知OFFのため通知しない")
            } else {
                playAudio(filePath: self.settingData.audioRemaining1min,soundID: self.settingData.getAudioRemaining1minSoundID())
                print("残り1分")
            }
        case 30:
            // 残り30秒
            if self.settingData.getAudioRemaining30sec() == "OFF" {
                print("通知OFFのため通知しない")
            } else {
                playAudio(filePath: self.settingData.audioRemaining30sec,soundID: self.settingData.getAudioRemaining30secSoundID())
                print("残り30秒")
            }
        case 0:
            // 終了
            if self.settingData.getAudioFinish() == "OFF" {
                print("通知OFFのため通知しない")
            } else {
                playAudio(filePath: self.settingData.audioFinish,soundID: self.settingData.getAudioFinishSoundID())
                print("終了")
            }
        default:
            break
        }
    }
    
    // 音声を再生するメソッド
    func playAudio(filePath path:String?,soundID id:Int) {
        if self.settingData.getMannerMode() {
            // バイブレーションで通知
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        } else {
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
    }
    
    // バナー通知を作成
    func setElapsedTimeNotification() {
        // 設定時間の取得
        let count = self.settingData.getCount()
        
        // リクエストを格納する配列を作成
        var requestArray:[UNNotificationRequest] = []
        requestIDArray = []
        
        // リクエスト作成
        switch count {
        case 50 * 60...99 * 60 :
            if self.settingData.getAudioElapsed50min() == "OFF" {
                // 通知OFFのため、リクエストは作成しない
            } else {
                requestArray.append(createRequest(title: "経過時間通知", subTitle: "開始から50分が経過しました。", soundPath: settingData.audioElapsed50min, timeInterval: 50 * 60))
                requestIDArray.append("開始から50分が経過しました。")
            }
            fallthrough
        case 45 * 60...50 * 60 :
            if self.settingData.getAudioElapsed45min() == "OFF" {
                // 通知OFFのため、リクエストは作成しない
            } else {
                requestArray.append(createRequest(title: "経過時間通知", subTitle: "開始から45分が経過しました。", soundPath: settingData.audioElapsed45min, timeInterval: 45 * 60))
                requestIDArray.append("開始から45分が経過しました。")
            }
            fallthrough
        case 40 * 60...45 * 60 :
            if self.settingData.getAudioElapsed40min() == "OFF" {
                // 通知OFFのため、リクエストは作成しない
            } else {
                requestArray.append(createRequest(title: "経過時間通知", subTitle: "開始から40分が経過しました。", soundPath: settingData.audioElapsed40min, timeInterval: 40 * 60))
                requestIDArray.append("開始から40分が経過しました。")
            }
            fallthrough
        case 35 * 60...40 * 60 :
            if self.settingData.getAudioElapsed35min() == "OFF" {
                // 通知OFFのため、リクエストは作成しない
            } else {
                requestArray.append(createRequest(title: "経過時間通知", subTitle: "開始から35分が経過しました。", soundPath: settingData.audioElapsed35min, timeInterval: 35 * 60))
                requestIDArray.append("開始から35分が経過しました。")
            }
            fallthrough
        case 30 * 60...35 * 60 :
            if self.settingData.getAudioElapsed30min() == "OFF" {
                // 通知OFFのため、リクエストは作成しない
            } else {
                requestArray.append(createRequest(title: "経過時間通知", subTitle: "開始から30分が経過しました。", soundPath: settingData.audioElapsed30min, timeInterval: 30 * 60))
                requestIDArray.append("開始から30分が経過しました。")
            }
            fallthrough
        case 25 * 60...30 * 60 :
            if self.settingData.getAudioElapsed25min() == "OFF" {
                // 通知OFFのため、リクエストは作成しない
            } else {
                requestArray.append(createRequest(title: "経過時間通知", subTitle: "開始から25分が経過しました。", soundPath: settingData.audioElapsed25min, timeInterval: 25 * 60))
                requestIDArray.append("開始から25分が経過しました。")
            }
            fallthrough
        case 20 * 60...25 * 60 :
            if self.settingData.getAudioElapsed20min() == "OFF" {
                // 通知OFFのため、リクエストは作成しない
            } else {
                requestArray.append(createRequest(title: "経過時間通知", subTitle: "開始から20分が経過しました。", soundPath: settingData.audioElapsed20min, timeInterval: 20 * 60))
                requestIDArray.append("開始から20分が経過しました。")
            }
            fallthrough
        case 15 * 60...20 * 60 :
            if self.settingData.getAudioElapsed15min() == "OFF" {
                // 通知OFFのため、リクエストは作成しない
            } else {
                requestArray.append(createRequest(title: "経過時間通知", subTitle: "開始から15分が経過しました。", soundPath: settingData.audioElapsed15min, timeInterval: 15 * 60))
                requestIDArray.append("開始から15分が経過しました。")
            }
            fallthrough
        case 10 * 60...15 * 60 :
            if self.settingData.getAudioElapsed10min() == "OFF" {
                // 通知OFFのため、リクエストは作成しない
            } else {
                requestArray.append(createRequest(title: "経過時間通知", subTitle: "開始から10分が経過しました。", soundPath: settingData.audioElapsed10min, timeInterval: 10 * 60))
                requestIDArray.append("開始から10分が経過しました。")
            }
            fallthrough
        case 5 * 60...10 * 60 :
            if self.settingData.getAudioElapsed5min() == "OFF" {
                // 通知OFFのため、リクエストは作成しない
            } else {
                requestArray.append(createRequest(title: "経過時間通知", subTitle: "開始から5分が経過しました。", soundPath: settingData.audioElapsed5min, timeInterval: 5 * 60))
                requestIDArray.append("開始から5分が経過しました。")
            }
            
            if self.settingData.getAudioRemaining5min() == "OFF" {
                // 通知OFFのため、リクエストは作成しない
            } else {
                requestArray.append(createRequest(title: "残り時間通知", subTitle: "残り5分になりました。", soundPath: settingData.audioRemaining5min, timeInterval: Double(count - (5 * 60))))
                requestIDArray.append("残り5分になりました。")
            }
            fallthrough
        case 3 * 60...5 * 60 :
            if self.settingData.getAudioRemaining3min() == "OFF" {
                // 通知OFFのため、リクエストは作成しない
            } else {
                requestArray.append(createRequest(title: "残り時間通知", subTitle: "残り3分になりました。", soundPath: settingData.audioRemaining3min, timeInterval: Double(count - (3 * 60))))
                requestIDArray.append("残り3分になりました。")
            }
            fallthrough
        case 1 * 60...3 * 60 :
            if self.settingData.getAudioRemaining1min() == "OFF" {
                // 通知OFFのため、リクエストは作成しない
            } else {
                requestArray.append(createRequest(title: "残り時間通知", subTitle: "残り1分になりました。", soundPath: settingData.audioRemaining1min, timeInterval: Double(count - (1 * 60))))
                requestIDArray.append("残り1分になりました。")
            }
            fallthrough
        case 30...1 * 60 :
            if self.settingData.getAudioRemaining30sec() == "OFF" {
                // 通知OFFのため、リクエストは作成しない
            } else {
                requestArray.append(createRequest(title: "残り時間通知", subTitle: "残り30秒になりました。", soundPath: settingData.audioRemaining30sec, timeInterval: Double(count - 30)))
                requestIDArray.append("残り30秒になりました。")
            }
            fallthrough
        default:
            if self.settingData.getAudioFinish() == "OFF" {
                // 通知OFFのため、リクエストは作成しない
            } else {
                requestArray.append(createRequest(title: "計測完了通知", subTitle: "設定時間になりました。", soundPath: settingData.audioFinish, timeInterval: Double(count)))
                requestIDArray.append("設定時間になりました。")
            }
        }
        
        print("requestIDArray:\(requestIDArray)")
        
        // 通知をセット
        let center = UNUserNotificationCenter.current()
        for request in requestArray {
            center.add(request) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // バナー通知のリクエストを作成するメソッド
    func createRequest(title titleText:String,subTitle subTitleText:String,soundPath path:String,timeInterval time:Double) -> UNNotificationRequest {
        // 表示の設定
        // MARK:- Fix:サウンドがデフォルト以外トライトーンになってしまう
        let content = UNMutableNotificationContent()
        content.title = titleText
        content.subtitle = subTitleText
        content.sound = UNNotificationSound.init(named: UNNotificationSoundName(self.settingData.getFileName(filePath: path)))
        
        // 通知タイミングの設定
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time,repeats: false)
        
        // リクエストの作成＆返却
        return UNNotificationRequest(identifier: subTitleText,content: content,trigger: trigger)
    }
    
    
    
    // MARK:- その他のメソッド
    
    // 利用規約表示メソッド
    func displayAgreement() {
        if UserDefaults.standard.bool(forKey: "firstLaunch") {
            // アラートダイアログを生成
            let alertController = UIAlertController(title:"利用規約の確認",message:"本アプリの利用規約とプライバシーポリシーに同意します。",preferredStyle:UIAlertController.Style.alert)
            
            // 同意ボタンを宣言
            let agreeAction = UIAlertAction(title:"同意する",style:UIAlertAction.Style.default){(action:UIAlertAction)in
                // 同意ボタンがタップされたときの処理
                // 次回以降、利用規約を表示しないようにする
                UserDefaults.standard.set(false, forKey: "firstLaunch")
            }
            
            // 利用規約ボタンを宣言
            let termsAction = UIAlertAction(title:"利用規約を読む",style:UIAlertAction.Style.default){(action:UIAlertAction)in
                // 利用規約ボタンがタップされたときの処理
                let url = URL(string: "https://notificationtimer-70d41.web.app/")
                UIApplication.shared.open(url!)
                
                // アラートが消えるため再度表示
                self.displayAgreement()
            }
            
            // ボタンを追加
            alertController.addAction(termsAction)
            alertController.addAction(agreeAction)
            
            //アラートダイアログを表示
            self.present(alertController,animated:true,completion:nil)
        }
    }
    
    // フォルダ構成の初期化
    func directoryInit() {
        // ファイル共有
        let fm = FileManager.default
        
        // アプリフォルダのパス
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        // Audioフォルダが存在しなければ作成
        // 何もファイルがないと「ファイル」アプリにアプリフォルダが表示されないためAudioフォルダを作成する
        let filePathList = [documentsPath + "/Audio"]
        for filePath in filePathList {
            if !fm.fileExists(atPath: filePath) {
                try! fm.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: [:])
                print("Audioフォルダを作成しました")
            }
        }
        
        // Application SupportフォルダをRealmの保存先に指定
        let applicationSupportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let path = applicationSupportDir.appendingPathComponent("default.realm")
        var config = Realm.Configuration.defaultConfiguration
        config.fileURL = path
        Realm.Configuration.defaultConfiguration = config
    }
    
    // 広告表示
    func displayAdsense() {
        // バナー広告を作成
        var admobView = GADBannerView()
        admobView = GADBannerView(adSize:kGADAdSizeBanner)
        
        // レイアウトの設定
        admobView.frame.origin = CGPoint(x:0, y:self.view.frame.size.height - admobView.frame.height - 34)
        admobView.frame.size = CGSize(width:self.view.frame.width, height:admobView.frame.height)
        
        // テストモード識別
        if AdMobTest {
            admobView.adUnitID = TEST_ID
        } else {
            admobView.adUnitID = AdMobID
        }
        
        // テストデバイスの登録
        let request = GADRequest()
        request.testDevices = ["e9bf85481a56f3f95336ba98a47e0d4c"]
        
        // 広告をビューに追加
        admobView.rootViewController = self
        admobView.load(request)
        self.view.addSubview(admobView)
    }
    
    // countの値をラベルに表示するメソッド
    func displayCount() {
        // 分秒に変換
        let minute:Int = Int(self.settingData.count / 60)
        let second:Int = Int(self.settingData.count.truncatingRemainder(dividingBy: 60))
        let count_Int:Int = Int(self.settingData.count)
        let mili:Float = (self.settingData.count - Float(count_Int)) * 100
        
        // フォーマット揃え
        let minuteText = NSString(format: "%02d", minute)
        let secondText = NSString(format: "%02d", second)
        let miliText = NSString(format: "%02d", Int(mili))
        
        // ラベルに反映
        timeLabel.text = "\(minuteText):\(secondText).\(miliText)"
    }
    
    // アラート表示
    func displayAlert() {
        // アラート(アクションシート)の宣言
        let alertController:UIAlertController = UIAlertController(title:"背景の設定", message: "どの画像を設定しますか？", preferredStyle: .actionSheet)
        
        // カメラロールボタンの宣言
        let actionLibrary = UIAlertAction(title: "カメラロール", style: .default) {action in
            // ライブラリが利用可能か判定
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                // ライブラリを起動
                print("ライブラリは利用可能です")
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("ライブラリは利用できません")
            }
        }
        
        // カメラボタンの宣言
        let actionCamera = UIAlertAction(title: "カメラを起動", style: .default){action in
            // カメラが利用可能か判定
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                print("カメラは利用可能です")
                // カメラを起動
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .camera
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("カメラは利用できません")
            }
        }
        
        // キャンセルボタンの宣言
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel){(action) -> Void in
        }
        
        // ボタンをセット
        alertController.addAction(actionLibrary)
        alertController.addAction(actionCamera)
        alertController.addAction(actionCancel)
        
        // アラートを表示
        present(alertController, animated: true, completion: nil)
    }
    
    // 画像選択時に呼ばれるメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 選択画像を背景にセット
        imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        // 背景画像を保存
        saveBackgroundImage()
        
        // モーダルを閉じる
        self.dismiss(animated: true, completion: .none)
    }
    
    // バックグラウンド、フォアグラウンド以降判定メソッド
    func addNotification() {
        // 通知の登録
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    // フォアグラウンドになった時に呼ばれる
    @objc func didBecomeActive(notify: NSNotification) {
        if let backgroundDate = backgroundDate, self.settingData.count > 0 {
            // Int型へ変換
            var count_Int = Int(self.settingData.count)
            
            // バックグラウンドに入った時間とフォアグラウンドになった時間の差分を取得
            let timeDiff = Int(NSDate().timeIntervalSince(backgroundDate as Date))
            print("経過時間 : \(timeDiff)")

            // 経過時間よりタイマーの残り時間が多かった場合、再度タイマースタート
            if timeDiff < count_Int && timerIsStart == true {
                count_Int -= timeDiff
                self.settingData.setCount(time: Float(count_Int))
                timer = Timer.scheduledTimer(timeInterval: 0.01, target:self, selector:#selector(countDown), userInfo:nil, repeats:true)
                timerNotification = Timer.scheduledTimer(timeInterval: 1, target:self, selector:#selector(notification), userInfo:nil, repeats:true)
            } else if timeDiff < count_Int && timerIsStart == false {
                // ラベルに反映
                displayCount()
            } else {
                // ゼロにリセット
                self.settingData.setCount(time: 0)
                timer.invalidate()
                timerNotification.invalidate()
                
                // ラベルに反映
                displayCount()
                
                // ボタン画像をスタート用にセット
                startButton.setImage(startImage, for: .normal)
            }
        }
    }

    // バックグラウンドに入った時に呼ばれる
    @objc func didEnterBackground(notify: NSNotification) {
        // タイマー停止
        timer.invalidate()
        timerNotification.invalidate()
        
        // バックグラウンドに入った時間を保持
        backgroundDate = NSDate()
        
        // SettingDataを保存
        updateSettingData()
        
        // 通知を保存
        saveNotificationRequest()
    }

}

// 文字を縁取りにする
extension UILabel {
    func makeOutLine(strokeWidth: CGFloat, oulineColor: UIColor, foregroundColor: UIColor) {
        let strokeTextAttributes = [
            .strokeColor : oulineColor,
            .foregroundColor : foregroundColor,
            .strokeWidth : strokeWidth
        ] as [NSAttributedString.Key : Any]
        self.attributedText = NSMutableAttributedString(string: self.text ?? "", attributes: strokeTextAttributes)
    }
}


//
//  TimerViewController.swift
//  012-NotificationTimer
//
//  Created by Takatoshi Miura on 2020/08/31.
//  Copyright © 2020 Takatoshi Miura. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK:- ライフサイクルメソッド
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ラベルの文字を縁取る
        timeLabel.makeOutLine(strokeWidth: -2.0, oulineColor: UIColor.black, foregroundColor: UIColor.white)
        resetLabel.makeOutLine(strokeWidth: -4.0, oulineColor: UIColor.black, foregroundColor: UIColor.white)
        
        // バックグラウンド,フォアグラウンド判定の追加
        addNotification()
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
        if timer.isValid && count > 0 {
            // タイマー稼動中にタップで一時停止
            timer.invalidate()
            
            // ボタン画像をスタート用にセット
            startButton.setImage(startImage, for: .normal)
        } else if count > 0 {
            // タイマー停止中にタップで再開
            timer = Timer.scheduledTimer(timeInterval: 0.01, target:self, selector:#selector(countDown), userInfo:nil, repeats:true)
            
            // ボタン画像を一時停止用にセット
            startButton.setImage(stopImage, for: .normal)
        } else {
            // ボタン画像をスタート用にセット
            startButton.setImage(startImage, for: .normal)
        }
    }
    
    // リセットボタン
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var resetLabel: UILabel!
    @IBAction func resetButton(_ sender: Any) {
        if timer.isValid {
            // タイマーを停止
            timer.invalidate()
        }
        
        if count == Float(minute[minuteIndex] * 60 + second[secondIndex]) && count > 0 {
            // ゼロにセット
            count = 0
            timePicker.selectRow(0, inComponent: 0, animated: true)
            timePicker.selectRow(0, inComponent: 1, animated: true)
            
            // 時間表示に反映
            timeLabel.text = "00:00.00"
            
            // ボタン画像をスタート用にセット
            startButton.setImage(startImage, for: .normal)
        } else if count > 0 {
            // 以前セットした時間に戻す
            timePickerDone()
            
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
    var count:Float = 0.00
    var backgroundDate: NSDate!
    
    // pickerView
    var pickerView = UIView()
    var timePicker = UIPickerView()
    let minute:[Int] = (0...59).map { $0 }
    let second:[Int] = (0...59).map { $0 }
    var minuteIndex:Int = 0
    var secondIndex:Int = 0
    
    // 設定データ
    var settingData:SettingData?
    
    
    
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
        
        // ゼロ埋め
        let minuteText = NSString(format: "%02d", minute[minuteIndex])
        let secondText = NSString(format: "%02d", second[secondIndex])
        
        // 時間表示に反映
        timeLabel.text = "\(minuteText):\(secondText).00"
        
        // 秒数を計算し、タイマーに時間をセットセット
        count = Float(minute[minuteIndex] * 60 + second[secondIndex])
        
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
        
        print("SettingData_\(self.settingData?.getCount())")
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
    
    // 設定データをUserDefaultsに保存するメソッド
    func saveSettingData() {
        // 保存
        let archivedData = try! NSKeyedArchiver.archivedData(withRootObject: settingData, requiringSecureCoding: false)
        UserDefaults.standard.set(archivedData, forKey: "SettingData_\(settingData?.getDataNumber())")
    }
    
    
    
    // MARK:- その他のメソッド

    //タイマーから呼び出されるメソッド
    @objc func countDown(){
        // 残り時間の計算
        count -= 0.01
        
        // ゼロならタイマーを停止
        if count < 0 {
            count = 0
            timer.invalidate()
        }
        
        // 分秒に変換
        let minute:Int = Int(count / 60)
        let second:Int = Int(count.truncatingRemainder(dividingBy: 60))
        let count_Int:Int = Int(count)
        let mili:Float = (count - Float(count_Int)) * 100
        
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
        if let backgroundDate = backgroundDate, self.count > 0 {
            // Int型へ変換
            var count_Int = Int(self.count)
            
            // バックグラウンドに入った時間とフォアグラウンドになった時間の差分を取得 ※簡易的にIntにキャストしています。
            let timeDiff = Int(NSDate().timeIntervalSince(backgroundDate as Date))
            print("経過時間 : \(timeDiff)")

            // 経過時間よりタイマーの残り時間が多かった場合、再度タイマースタート
            if timeDiff < count_Int {
                count_Int -= timeDiff
                count = Float(count_Int)
                timer = Timer.scheduledTimer(timeInterval: 0.01, target:self, selector:#selector(countDown), userInfo:nil, repeats:true)
            } else {
                // ゼロにリセット
                self.count = 0
                timer.invalidate()
                
                // ボタン画像をスタート用にセット
                startButton.setImage(startImage, for: .normal)
                
                // ラベルに反映
                timeLabel.text = "00:00.00"
            }
        }
        
        
    }

    // バックグラウンドに入った時に呼ばれる
    @objc func didEnterBackground(notify: NSNotification) {
        // タイマー停止
        timer.invalidate()
        
        // バックグラウンドに入った時間を保持
        backgroundDate = NSDate()
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


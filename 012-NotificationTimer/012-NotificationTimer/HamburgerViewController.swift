//
//  hamburgerViewController.swift
//  012-NotificationTimer
//
//  Created by Takatoshi Miura on 2020/09/01.
//  Copyright © 2020 Takatoshi Miura. All rights reserved.
//

import UIKit
import MessageUI

class HamburgerViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate {

    // MARK:- ライフサイクルメソッド
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // テーブルビューのスクロールを禁止
        tableView.isScrollEnabled = false
        
        // メニューを表示
        openMenu()
    }
    
    
    
    // MARK:- UIの設定
    
    // メニュービュー
    @IBOutlet weak var menuView: UIView!
    
    // テーブルビュー
    @IBOutlet weak var tableView: UITableView!
    
    
    
    // MARK:- テーブルビューの設定
    
    // セル数を返却
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitleArray.count
    }
    
    // セルを返却
    let cellTitleArray:[String] = ["音声データの取り込み方","利用規約","お問い合わせ"]
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // ハンバーガーセルを返却
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "hamburgerCell", for: indexPath)
        cell.textLabel?.text = cellTitleArray[indexPath.row]
        return cell
    }
    
    // セルをタップしたときの処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // タップしたときの選択色を消去
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        // セルによって分岐
        switch indexPath.row {
        case 0:
            // 音声データの取り込み方
            break
        case 1:
            // 利用規約
            break
        case 2:
            // お問い合わせ
            // メーラーを起動
            startMailer()
        default:
            break
        }
    }
    
    // セクション名を返却
    func tableView(_ tableView:UITableView, titleForHeaderInSection section:Int) -> String?{
        return "このアプリについて"
    }
    
    // セクションの個数を返却
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // セクションの高さを返却
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    
    
    // MARK:- その他のメソッド
    
    // メニューを表示するメソッド
    func openMenu() {
        // メニューの位置を取得する
        let menuPos = self.menuView.layer.position
        
        // 初期位置を画面の外側にするため、メニューの幅の分だけマイナスする
        self.menuView.layer.position.x = -self.menuView.frame.width
        
        // 表示時のアニメーションを作成する
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                self.menuView.layer.position.x = menuPos.x
            },
            completion: { bool in
        })
    }
    
    // メニューエリア以外タップ時の処理
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            // ハンバーガーメニューを閉じる
            if touch.view?.tag == 1 {
                UIView.animate(
                    withDuration: 0.2,
                    delay: 0,
                    options: .curveEaseIn,
                    animations: {
                        self.menuView.layer.position.x = -self.menuView.frame.width
                },
                    completion: { bool in
                        self.dismiss(animated: true, completion: nil)
                }
                )
            }
        }
    }
    
    // メーラーを宣言するメソッド
    func startMailer() {
        // メールを送信できるかチェック
        if MFMailComposeViewController.canSendMail() == false {
            createOKDialog(title: "エラー", message: "メールアカウントが未設定です。Apple社の「メール」アプリにてアカウントを設定して下さい。")
            return
        }

        // メーラーの宣言
        let mailViewController = MFMailComposeViewController()
        mailViewController.mailComposeDelegate = self
        
        // 送信先(Toアドレス)の設定
        let toRecipients = ["アプリ開発者<it6210ge@gmail.com>"]
        mailViewController.setToRecipients(toRecipients)
        
        // 件名の設定
        mailViewController.setSubject("件名例：バグの報告")
        
        // 本文の設定
        mailViewController.setMessageBody("お問い合わせ内容をご記入下さい", isHTML: false)

        // メーラーを起動
        self.present(mailViewController, animated: true, completion: nil)
    }
    
    // メーラーを閉じるメソッド
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("Email Send Cancelled")
            break
        case .saved:
            print("Email Saved as a Draft")
            break
        case .sent:
            createOKDialog(title: "送信完了", message: "メールを送信しました。\n開発者からの返信をお待ち下さい。")
            break
        case .failed:
            createOKDialog(title: "エラー", message: "メールを送信できませんでした。")
            break
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    // OKダイアログ作成メソッド
    func createOKDialog(title titleString:String,message messageString:String) {
        // ダイアログを作成
        let dialog = UIAlertController(title: titleString, message: messageString, preferredStyle: .alert)
        
        // ボタンを追加
        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // 生成したダイアログを表示
        self.present(dialog, animated: true, completion: nil)
    }

}

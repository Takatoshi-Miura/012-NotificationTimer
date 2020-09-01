//
//  hamburgerViewController.swift
//  012-NotificationTimer
//
//  Created by Takatoshi Miura on 2020/09/01.
//  Copyright © 2020 Takatoshi Miura. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    // MARK: - ライフサイクルメソッド
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // テーブルビューのスクロールを禁止
        tableView.isScrollEnabled = false
        
        // メニューを表示
        openMenu()
    }
    
    
    
    // MARK: - UIの設定
    
    // メニュービュー
    @IBOutlet weak var menuView: UIView!
    
    // テーブルビュー
    @IBOutlet weak var tableView: UITableView!
    
    
    
    // MARK: - テーブルビューの設定
    
    // セル数を返却
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    // セルを返却
    let cellTitleArray:[String] = ["利用規約","お問い合わせ"]
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
    
    
    
    // MARK: - その他のメソッド
    
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

}

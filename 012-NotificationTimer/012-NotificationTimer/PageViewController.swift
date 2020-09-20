//
//  PageViewController.swift
//  012-NotificationTimer
//
//  Created by Takatoshi Miura on 2020/09/02.
//  Copyright © 2020 Takatoshi Miura. All rights reserved.
//

import UIKit
import AVFoundation

class PageViewController: UIPageViewController,UIPageViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // データ番号を各画面に渡す(ロードは各画面で行う)
        for num in 0...4 {
            // データを各画面に渡す
            let VC = storyboard!.instantiateViewController(withIdentifier: "TimerViewController") as! TimerViewController
            VC.dataNumber = num
            self.controllers.append(VC)
        }
        
        // PageViewController初期化メソッド
        self.initPageViewController()

        // PageControlを追加
        self.addPageControl()
    }
    
    
    
    //MARK:- 変数の宣言
    
    // PageViewController関連
    var controllers: [UIViewController] = []
    var pageViewController: UIPageViewController!
    var pageControl: UIPageControl!
    
    // 音声再生
    var player = AVAudioPlayer()
    
    
    
    //MARK:- その他のメソッド
    
    // pageViewController初期化メソッド
    func initPageViewController() {
        // pageViewControllerの宣言
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageViewController.setViewControllers([self.controllers[0]], direction: .forward, animated: false, completion: nil)

        // デリゲート,データソースの指定
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
       
        // ビューを追加
        self.addChild(self.pageViewController)
        self.view.addSubview(self.pageViewController.view!)
    }
    
    // PageControlを追加するメソッド
    func addPageControl() {
        // PageControlの配置場所
        self.pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 60, width: UIScreen.main.bounds.width,height: 60))
        
        // 全ページ数
        self.pageControl.numberOfPages = self.controllers.count
        
        // 表示ページ
        self.pageControl.currentPage = 0
        
        // インジケータの色
        self.pageControl.pageIndicatorTintColor = .gray
        
        // 現在ページのインジケータの色
        self.pageControl.currentPageIndicatorTintColor = .white
        
        // タップ無効
        self.pageControl.isUserInteractionEnabled = false
        
        // ビューに追加
        self.view.addSubview(self.pageControl)
    }
    
}



// MARK: - UIPageViewController DataSource
extension PageViewController: UIPageViewControllerDataSource {

    // ページ数
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.controllers.count
    }
   
    // 左にスワイプ（進む）
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = self.controllers.firstIndex(of: viewController), index < self.controllers.count - 1 {
            return self.controllers[index + 1]
        } else {
            return nil
        }
    }

    // 右にスワイプ （戻る）
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = self.controllers.firstIndex(of: viewController), index > 0 {
            return self.controllers[index - 1]
        } else {
            return nil
        }
    }
    
    // アニメーション終了後処理
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentPage = pageViewController.viewControllers![0]
        self.pageControl.currentPage = self.controllers.firstIndex(of: currentPage)!
        
        // アプリ起動時音声再生
        let VC = self.controllers[pageControl.currentPage] as! TimerViewController
        if VC.settingData.getAudioAppStartUp() == "OFF" {
            print("通知OFFのため再生しない")
        } else {
            playAudio(settingData: VC.settingData, filePath: VC.settingData.getAudioAppStartUp(),soundID: VC.settingData.getAudioAppStartUpSoundID())
        }
    }
    
    
    // 音声を再生するメソッド
    func playAudio(settingData data:SettingData,filePath path:String?,soundID id:Int) {
        if data.getMannerMode() {
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

}

//
//  PageViewController.swift
//  012-NotificationTimer
//
//  Created by Takatoshi Miura on 2020/09/02.
//  Copyright © 2020 Takatoshi Miura. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController,UIPageViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SettingDataをロード(なければ作成)し、各画面に渡す
        for num in 0...4 {
            // データのロード
            if let storedData = UserDefaults.standard.object(forKey: "SettingData_\(num)") as? Data {
                if let unarchivedObject = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(storedData) as? SettingData {
                    // データを各画面に渡す
                    let VC = storyboard!.instantiateViewController(withIdentifier: "TimerViewController") as! TimerViewController
                    VC.settingData = unarchivedObject
                    self.controllers.append(VC)
                }
            } else {
                // データを作成
                let settingData = SettingData(dataNumber: num)
                
                // データを各画面に渡す
                let VC = storyboard!.instantiateViewController(withIdentifier: "TimerViewController") as! TimerViewController
                VC.settingData = settingData
                self.controllers.append(VC)
            }
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
    
    
    
    //MARK:- その他のメソッド
    
    // pageViewController初期化メソッド
    func initPageViewController() {
        // pageViewControllerの宣言
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageViewController.setViewControllers([self.controllers[0]], direction: .forward, animated: true, completion: nil)

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
    }

}

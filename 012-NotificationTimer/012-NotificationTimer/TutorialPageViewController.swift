//
//  TutorialPageViewController.swift
//  012-NotificationTimer
//
//  Created by Takatoshi Miura on 2020/09/15.
//  Copyright © 2020 Takatoshi Miura. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController,UIPageViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // controllersにビューを格納
        let VC1 = storyboard!.instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
        let VC2 = storyboard!.instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
        let VC3 = storyboard!.instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
        let VC4 = storyboard!.instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
        let VC5 = storyboard!.instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
        let VC6 = storyboard!.instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
        let VC7 = storyboard!.instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
        self.controllers = [VC1,VC2,VC3,VC4,VC5,VC6,VC7]
        
        // 各画面にチュートリアルデータを渡す
        for num in 0...self.controllers.count - 1 {
            let VC = self.controllers[num] as! TutorialViewController
            VC.titleLabel.text  = titleArray[num]
            VC.detailLabel.text = detailArray[num]
            VC.imageView.image  = imageArray[num]!
        }

        // PageViewController初期化メソッド
        self.initPageViewController()

        // PageControlを追加
        self.addPageControl()
        
        // スキップボタンを追加
        self.addSkipButton()
    }



    //MARK:- 変数の宣言
    
    // PageViewController関連
    var controllers: [UIViewController] = []
    var pageViewController: UIPageViewController!
    var pageControl: UIPageControl!
    
    // チュートリアルデータ
    var titleArray:[String]  = ["ファイル共有機能"]
    
    var detailArray:[String] = ["本アプリではユーザーが取り込んだmp3ファイルやボイスメモを通知音として使用できます。\n※Apple純正アプリ「ファイル」が必要です。"]
    
    var imageArray:[UIImage?] = [UIImage(named: "①ファイルアプリ")]
    
    
    
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
    
    // Skipボタンを追加するメソッド
    func addSkipButton() {
        // UIButtonのインスタンスを作成する
        let button = UIButton()

        // ボタンを押した時に実行するメソッドを指定
        button.addTarget(self, action: #selector(skipButtonEvent(_:)), for: UIControl.Event.touchUpInside)

        // ラベルを設定
        button.setTitle("閉じる", for: UIControl.State.normal)
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)

        // 位置の設定
        button.frame = CGRect(x: UIScreen.main.bounds.maxX - 80, y: UIScreen.main.bounds.maxY - 60, width: 80, height: 60)

        // viewに追加
        self.view.addSubview(button)
    }
    
    // Skipボタンの処理
    @objc func skipButtonEvent(_ sender: UIButton) {
        // チュートリアル画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
}



// MARK: - UIPageViewController DataSource
extension TutorialPageViewController: UIPageViewControllerDataSource {

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

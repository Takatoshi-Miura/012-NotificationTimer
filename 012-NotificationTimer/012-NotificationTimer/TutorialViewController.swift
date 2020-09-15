//
//  TutorialViewController.swift
//  012-NotificationTimer
//
//  Created by Takatoshi Miura on 2020/09/15.
//  Copyright © 2020 Takatoshi Miura. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // チュートリアルデータを表示
        printData()
    }
    
    
    
    //MARK:- 変数の宣言
    
    var titleText:String  = ""
    var detailText:String = ""
    var image:UIImage = UIImage(named: "①ファイルアプリ")!
    
    

    //MARK:- UIの設定
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    //MARK:- その他のメソッド
    
    func printData() {
        self.titleLabel.text  = titleText
        self.detailLabel.text = detailText
        self.imageView.image  = image
    }

}

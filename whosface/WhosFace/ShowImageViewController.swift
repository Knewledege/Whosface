//
//  ShowImageViewController.swift
//  WhosFace
//
//  Created by Kei on 2017/06/23.
//  Copyright © 2017年 takahashi kei. All rights reserved.
//

import UIKit

class ShowImageViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var ShowImage: UIImageView!
    
    
    
    @IBOutlet weak var Who_label: UILabel!
    @IBOutlet weak var diagnosis: UIButton!
    @IBOutlet weak var NO1_ps: UILabel!
    @IBOutlet weak var NO1_name: UILabel!
    @IBOutlet weak var NameTableView: UITableView!
    @IBOutlet weak var errorlabel: UILabel!
    var image : UIImage!
    
    var result:[Float]=[0]
    
    var resultName:[(Point:Float,Name:Int)] = []
    var ind:Int=0
    
    // 顔検出オブジェクト
    let detector = OpenCVWrapper()
    
    
    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultName.count
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath :IndexPath) -> UITableViewCell {
    
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath)
        
        //Tag番号でセルに含まれるラベルを取得
        let label2 = cell.viewWithTag(2) as! UILabel
        label2.adjustsFontSizeToFitWidth=true
        let label3 = cell.viewWithTag(3) as! UILabel
        
        // セルに表示する値を設定する
        label2.text = String(describing:NamesClass().GetName(indent:resultName[indexPath.row].Name))
        label3.text = String(format: "%.1f%%",resultName[indexPath.row].Point)
        
        return cell
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        //グラデーションの開始色
        let topColor = UIColor(red:0.54, green:0.74, blue:0.74, alpha:0.8)
        //グラデーションの開始色
        let bottomColor = UIColor(red:0.07, green:0.13, blue:0.28, alpha:0.8)
        
        //グラデーションの色を配列で管理
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        
        //グラデーションレイヤーを作成
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        
        //グラデーションの色をレイヤーに割り当てる
        gradientLayer.colors = gradientColors
        //グラデーションレイヤーをスクリーンサイズにする
        gradientLayer.frame = self.view.bounds
        
        //グラデーションレイヤーをビューの一番下に配置
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        
        Who_label.adjustsFontSizeToFitWidth=true
        
        //dataSourceの設定
        NameTableView.dataSource = self
        //delegateの設定
        NameTableView.delegate = self
        
        
        
        errorlabel.isHidden=true
        //let path: String = Bundle.main.path(forResource: "testimage", ofType: "jpg")!
        // ImageViewに画像を表示
        //ShowImage.image = UIImage(contentsOfFile: path)
        // Do any additional setup after loading the view.
        let rectface = self.detector?.rectangleFace(image)
        let showface = self.detector?.showFace(image)
        
        if(rectface != nil && showface != nil){
            
            ShowImage.image = showface
            let TF = TFDetector().detectImage(image: rectface!, inputSize: 28)
            
            print(TF)
            NO1_ps.text = String(format: "%.1f%%",TF.0[TF.1]*100)
            NO1_name.adjustsFontSizeToFitWidth=true
            NO1_ps.adjustsFontSizeToFitWidth=true
            NO1_name.text = NamesClass().GetName(indent:TF.1)
            
            result = TF.0.filter {$0 != TF.0[TF.1]}.map{$0 * 100}
            ind=0
            for (index,res) in result.enumerated(){
                if(index >= TF.1){ind=index+1}
                resultName.append((Point:res,Name:ind))
            }
            resultName.sort{$0 > $1}
        }else{
            resultName.append((Point:0,Name:0))
            ShowImage.isHidden = true
            Who_label.isHidden = true
            NO1_ps.isHidden = true
            NO1_name.isHidden = true
            NameTableView.isHidden = true
            
            errorlabel.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

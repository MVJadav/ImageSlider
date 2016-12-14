//
//  ImageCollectionVC.swift
//  ImageSlider
//
//  Created by JadavMehul on 10/12/16.
//

import UIKit
import Photos
import Alamofire
import AlamofireImage

class ImageCollectionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {

    @IBOutlet weak var collectionView: UICollectionView!
    var imageArray      = [UIImage]()
    var selectedIndexPath   : IndexPath? = nil
    var isSelected          : Bool = true

    let urlImages =    ["https://s26.postimg.org/3n85yisu1/one_5_51_58_PM.png","https://s26.postimg.org/65tuz7ek9/two_5_41_53_PM.png","https://s26.postimg.org/7ywrnizqx/three_5_41_53_PM.png","https://s26.postimg.org/6l54s80hl/four.png","https://s26.postimg.org/ioagfsbjt/five.png","https://s26.postimg.org/3n85yisu1/one_5_51_58_PM.png","https://s26.postimg.org/65tuz7ek9/two_5_41_53_PM.png","https://s26.postimg.org/7ywrnizqx/three_5_41_53_PM.png","https://s26.postimg.org/6l54s80hl/four.png","https://s26.postimg.org/ioagfsbjt/five.png","https://s26.postimg.org/3n85yisu1/one_5_51_58_PM.png","https://s26.postimg.org/65tuz7ek9/two_5_41_53_PM.png","https://s26.postimg.org/7ywrnizqx/three_5_41_53_PM.png","https://s26.postimg.org/6l54s80hl/four.png","https://s26.postimg.org/ioagfsbjt/five.png","https://s26.postimg.org/3n85yisu1/one_5_51_58_PM.png","https://s26.postimg.org/65tuz7ek9/two_5_41_53_PM.png","https://s26.postimg.org/7ywrnizqx/three_5_41_53_PM.png","https://s26.postimg.org/6l54s80hl/four.png","https://s26.postimg.org/ioagfsbjt/five.png","https://s26.postimg.org/3n85yisu1/one_5_51_58_PM.png","https://s26.postimg.org/65tuz7ek9/two_5_41_53_PM.png","https://s26.postimg.org/7ywrnizqx/three_5_41_53_PM.png","https://s26.postimg.org/6l54s80hl/four.png","https://s26.postimg.org/ioagfsbjt/five.png","https://s26.postimg.org/3n85yisu1/one_5_51_58_PM.png","https://s26.postimg.org/65tuz7ek9/two_5_41_53_PM.png","https://s26.postimg.org/7ywrnizqx/three_5_41_53_PM.png","https://s26.postimg.org/6l54s80hl/four.png","https://s26.postimg.org/ioagfsbjt/five.png"]
    
    override func viewDidLoad() {
        
        collectionView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //setImage()
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillAppear(animated)
    }

    //MARK: CollectionViewController Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return urlImages.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        var cell:ImageCell? = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell
        
        if (cell == nil) {
            let nib: NSArray = Bundle.main.loadNibNamed("ImageCell", owner: self, options: nil)! as NSArray
            cell = (nib.object(at: 0) as? ImageCell)!
            
        }
        if (indexPath == self.selectedIndexPath) {
            let bcolor : UIColor = UIColor( red: 72/255.0, green: 197/255.0, blue:147/255.0, alpha: 1.0 )
            cell?.layer.borderColor     = bcolor.cgColor
            cell?.layer.borderWidth     = 2
            cell?.layer.cornerRadius    = 3
            cell?.backgroundColor=UIColor.white
        }else{
            
            let bcolor : UIColor = UIColor( red: 0.2, green: 0.2, blue:0.2, alpha: 0.3 )
            cell?.layer.borderColor     = bcolor.cgColor
            cell?.layer.borderWidth     = 0.5
            cell?.layer.cornerRadius    = 3
            cell?.backgroundColor=UIColor.white
        }
        //Set Images
        let url:URL = URL(string: urlImages[indexPath.row])!
        cell?.imgCell.af_setImage(withURL: url, placeholderImage: UIImage(named:"ic_user"), filter: nil, progress: { (Progress) in
            //code
        }, runImageTransitionIfCached: true) { (image) in
            //code
        }
        return cell!
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedIndexPath  = indexPath
        self.isSelected         = true
        self.collectionView.reloadData()
        let objFullView         = FullImageView(nibName:"FullImageView",bundle: nil)
        objFullView.imageIndex  = indexPath.row
        objFullView.imageArray  = urlImages
        self.present(objFullView, animated: true, completion: nil)
    }
    
    //MARK: Image Aerray Initialization
    func setImage(){
        
        for i in 0..<urlImages.count
        {
            let url:URL = URL(string: urlImages[i])!
            print(url,urlImages[i])
        }
    }
}

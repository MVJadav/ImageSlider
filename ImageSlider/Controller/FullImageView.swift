//
//  FullImageView.swift
//  ImageSlider
//
//  Created by JadavMehul on 10/12/16.
//

import UIKit
import Alamofire
import AlamofireImage

class FullImageView: UIViewController, UIScrollViewDelegate,
                     UIPageViewControllerDelegate,
                     UIGestureRecognizerDelegate{
//MARK: Variables
    fileprivate var pageViewController: UIPageViewController?
    var imageArray              = [String]()
    var imageIndex              :Int!
    var selectedIndexPath       : IndexPath? = nil
    var isSelected              : Bool = true
    var isSwipGesture:Bool      = false     // If you want to use left/right swipe, set isSwipGesture true
//MARK: Outlets
    @IBOutlet weak var scrollView                   : UIScrollView!
    @IBOutlet weak var imageView                    : UIImageView!
    @IBOutlet weak var btnLeftArrow                 : UIButton!
    @IBOutlet weak var btnRightArrow                : UIButton!
    @IBOutlet weak var txtImageNumber               : UILabel!
    @IBOutlet weak var collectionView               : UICollectionView!
    @IBOutlet weak var constraintCollectionBottom   : NSLayoutConstraint!
    @IBOutlet weak var viewCollection               : UIView!
    @IBOutlet weak var topViewConstraint            : NSLayoutConstraint!
    @IBOutlet var SwipRightGesture                  : UISwipeGestureRecognizer!
    @IBOutlet var SwipLeftGesture                   : UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        if(isSwipGesture){
            btnLeftArrow.isHidden   = true
            btnRightArrow.isHidden  = true
        }else{
            SwipLeftGesture.isEnabled = false
            SwipRightGesture.isEnabled = false
        }
        selectedIndexPath?.row = 0
        collectionView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        self.txtImageNumber.text = String(imageIndex+1)+"/"+String(imageArray.count)
        setImage(index: imageIndex)
        scrollView.minimumZoomScale     = 1.0
        scrollView.maximumZoomScale     = 6.0
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: IBAction Action Method AND All Gesture Selections
//- See more at: http://www.theappguruz.com/blog/gesture-recognizer-using-swift#sthash.d4CSmhrf.dpuf
extension FullImageView {
    
    @IBAction func rightsideanimation(gesture: UIGestureRecognizer){
        if 0 < imageIndex {
            scrollView.zoomScale = 0
            let animation: CATransition =  self.CATransitionFunc(isRight: true)
            imageIndex = imageIndex - 1;
            self.txtImageNumber.text    = String(imageIndex+1)+"/"+String(imageArray.count)
            if NSURL(string: (imageArray[imageIndex])) != nil {
                self.setImage(index: imageIndex)
            }
            self.imageView.layer.add(animation, forKey: kCATransition)
            if(self.selectedIndexPath != nil){
                self.selectedIndexPath?.row = imageIndex
                self.collectionView.scrollToItem(at: self.selectedIndexPath!, at: .right, animated: true)
                //self.collectionView.reloadItems(at: [self.selectedIndexPath! as IndexPath])
                self.collectionView.reloadData()
            }
        }
    }
    @IBAction func leftsideanimation(gesture: UIGestureRecognizer) {
        if (imageArray.count > (imageIndex+1)){
            scrollView.zoomScale = 0
            let animation: CATransition =  self.CATransitionFunc(isRight: false)
            imageIndex                  = imageIndex + 1;
            self.txtImageNumber.text    = String(imageIndex+1)+"/"+String(imageArray.count)
            self.imageView.layer.add(animation, forKey: kCATransition)
            if NSURL(string: (imageArray[imageIndex])) != nil {
                self.setImage(index: imageIndex)
            }
            if(self.selectedIndexPath != nil){
                self.selectedIndexPath?.row = imageIndex
                self.collectionView.scrollToItem(at: self.selectedIndexPath!, at: .left, animated: true)
                //self.collectionView.reloadItems(at: [self.selectedIndexPath! as IndexPath])
                self.collectionView.reloadData()
            }
        }
    }
    @IBAction func imageTapped(sender: AnyObject)
    {
        if(scrollView.zoomScale >= 3){
            scrollView.setZoomScale(0, animated: true)
        }else{
            let tappedPoint     = sender.location(in: self.imageView)
            let scrollViewSize  = scrollView.bounds.size
            let w: CGFloat      = scrollViewSize.width / scrollView.maximumZoomScale
            let h: CGFloat      = scrollViewSize.height / scrollView.maximumZoomScale
            let x: CGFloat      = tappedPoint.x - (w / 2.0)
            let y: CGFloat      = tappedPoint.y - (h / 2.0)
            let rectTozoom      = CGRect(x: x, y: y, width: w, height: h)
            self.scrollView.zoom(to: rectTozoom, animated: true)
        }
    }
    @IBAction func imageOneTapped(sender: AnyObject)
    {
        if(constraintCollectionBottom.constant==5){
            UIView .animate(withDuration: 0.5, delay: 0.0, options:UIViewAnimationOptions.curveEaseInOut, animations: {
                self.constraintCollectionBottom.constant = -75
                self.view.layoutIfNeeded()
                }, completion: {
                    (value: Bool) in
            })
        }else{
            UIView .animate(withDuration: 0.5, delay: 0.0, options:UIViewAnimationOptions.curveEaseInOut, animations: {
                self.constraintCollectionBottom.constant = 5
                self.view.layoutIfNeeded()
                }, completion: {
                    (value: Bool) in
            })
        }
    }
    @IBAction func btnLeftRight(_ sender: AnyObject) {
        
        self.btnRightArrow.isHidden = false
        self.btnLeftArrow.isHidden = false
        if(sender.tag==1){
            if(imageIndex == 0){
                self.btnLeftArrow.isHidden = true
            }
            if(imageIndex > 0){
                imageIndex = imageIndex-1
                if(imageIndex == imageArray.count){
                    imageIndex = imageArray.count-1
                }
                if(imageIndex == 0){
                    self.btnLeftArrow.isHidden = true
                }
            }
        }else{
            if(imageIndex+1 == imageArray.count){
                self.btnRightArrow.isHidden = true;
            }
            if(imageIndex+1 < imageArray.count){
                imageIndex = imageIndex+1
                if(imageIndex+1 == imageArray.count){
                    self.btnRightArrow.isHidden = true;
                    imageIndex = imageArray.count-1
                }
            }
        }
        self.txtImageNumber.text = String(imageIndex+1)+"/"+String(imageArray.count)
        setImage(index: imageIndex)
        if(self.selectedIndexPath != nil){
            self.selectedIndexPath?.row = imageIndex
            self.collectionView.scrollToItem(at: self.selectedIndexPath!, at: .left, animated: true)
            //self.collectionView.reloadItems(at: [self.selectedIndexPath! as IndexPath])
            self.collectionView.reloadData()
        }
        scrollView.zoomScale = 0
    }
    @IBAction func btnClose(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: CollectionView Methods
extension FullImageView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return imageArray.count;
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
        let url:URL = URL(string: imageArray[indexPath.row])!
        cell?.imgCell.af_setImage(withURL: url, placeholderImage: UIImage(named:"ic_user"), filter: nil, progress: { (Progress) in
            //code
        }, runImageTransitionIfCached: true) { (image) in
            //code 
        }
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        setImage(index: indexPath.row)
        hiddeShowButtob(indexPath: indexPath)
        imageIndex = indexPath.row
        scrollView.zoomScale = 0
        self.selectedIndexPath  = indexPath
        self.isSelected         = true
        self.txtImageNumber.text    = String(indexPath.row+1)+"/"+String(imageArray.count)
        let cell = collectionView.cellForItem(at: indexPath)
        let bcolor : UIColor = UIColor( red: 72/255.0, green: 197/255.0, blue:147/255.0, alpha: 1.0 )
        cell?.layer.borderColor = bcolor.cgColor
        cell?.layer.borderWidth = 2
        cell?.layer.cornerRadius = 3
        cell?.backgroundColor=UIColor.white
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath){
        
        let cell = collectionView.cellForItem(at: indexPath)
        let bcolor : UIColor = UIColor( red: 0.2, green: 0.2, blue:0.2, alpha: 0.3 )
        cell?.layer.borderColor = bcolor.cgColor
        cell?.layer.borderWidth = 2
        cell?.layer.cornerRadius = 3
        cell?.backgroundColor=UIColor.white
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionat section: Int) -> UIEdgeInsets {
//        return UIEdgeInsetsMake(0, 100, 0, 0)
//    }
}

//MARK: ScrollView Delegate Methods
extension FullImageView{
    @objc(viewForZoomingInScrollView:) func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView){
//        
//        if(scrollView.zoomScale<0.90){
//            self.dismiss(animated: true, completion: nil)
//        }
//    }
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return self.imageView
//    }
    
}

//MARK: Other Methods
extension FullImageView{
    
    func setImage(index:Int?=0){
        let url:URL = URL(string: imageArray[index!])!
        if(isSwipGesture){
            imageView.af_setImage(withURL: url, placeholderImage: UIImage(named:""), filter: nil, progress: { (Progress) in
                //code
            }, runImageTransitionIfCached: true) { (image) in
                //code
            }
        }else{
            imageView.af_setImage(withURL: url, placeholderImage: UIImage(named:""), filter: nil, progress: { (Progress) in
                //code
            }, runImageTransitionIfCached: true) { (image) in
                //code , imageTransition: UIImageView.ImageTransition.flipFromLeft(0.5)
            }
        }
    }
    func CATransitionFunc(isRight:Bool)->CATransition{
        
        let animation: CATransition = CATransition()
        animation.delegate          = self as? CAAnimationDelegate
        animation.type              = kCATransitionPush
        isRight ? (animation.subtype = kCATransitionFromLeft) : (animation.subtype = kCATransitionFromRight)
        animation.duration          = 0.7
        animation.timingFunction    = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        return animation
    }
    func hiddeShowButtob(indexPath:IndexPath){
        if(!isSwipGesture){
            self.btnRightArrow.isHidden = false
            self.btnLeftArrow.isHidden = false
            if(indexPath.row == 0){
                self.btnLeftArrow.isHidden = true
            }
            if(indexPath.row+1 == imageArray.count){
                self.btnRightArrow.isHidden = true
            }
        }
    }
}

//MARK: you can also use bellow Gesture
//
// func setGesture(){
// let swipeRight = UISwipeGestureRecognizer(target: self, action: Selector(("respondToSwipeGesture:")))
// swipeRight.direction = UISwipeGestureRecognizerDirection.right
// self.view.addGestureRecognizer(swipeRight)
// 
// let swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector(("respondToSwipeGesture:")))
// swipeLeft.direction = UISwipeGestureRecognizerDirection.left
// self.view.addGestureRecognizer(swipeLeft)
// }
// func respondToSwipeGesture(gesture: UIGestureRecognizer) {
// 
// if let swipeGesture = gesture as? UISwipeGestureRecognizer {
// switch swipeGesture.direction {
// case UISwipeGestureRecognizerDirection.right:
// print("Swiped right")
// case UISwipeGestureRecognizerDirection.down:
// print("Swiped down")
// case UISwipeGestureRecognizerDirection.left:
// print("Swiped left")
// case UISwipeGestureRecognizerDirection.up:
// print("Swiped up")
// default:
// break
// }
// }
// }
//

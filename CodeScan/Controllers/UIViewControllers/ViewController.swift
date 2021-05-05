
import UIKit
import AVFoundation
import AccuraMRZ

class ViewController: UIViewController {
    
    @IBOutlet weak var _viewLayer: UIView!
    @IBOutlet weak var _imageView: UIImageView!
    @IBOutlet weak var _imgFlipView: UIImageView!
    @IBOutlet weak var _lblTitle: UILabel!
    @IBOutlet weak var _constant_height: NSLayoutConstraint!
    @IBOutlet weak var _constant_width: NSLayoutConstraint!
    
    @IBOutlet weak var AspectRatio: NSLayoutConstraint!
    @IBOutlet weak var lblOCRMsg: UILabel!
    @IBOutlet weak var lblTitleCountryName: UILabel!
    
    @IBOutlet weak var viewStatusBar: UIView!
    @IBOutlet weak var viewNavigationBar: UIView!
    
    var accuraCameraWrapper: AccuraCameraWrapper? = nil
    
    var shareScanningListing: NSMutableDictionary = [:]
    
    var documentImage: UIImage? = nil
    var docfrontImage: UIImage? = nil
    
    var frontImageRotation = ""
    var backImageRotation = ""
    
    var docName = "Document"
    
    
    //MARK:- Variable
    var cardid : Int? = 0
    var countryid : Int? = 0
    var imgViewCard : UIImage?
    var isCheckCard : Bool = false
    var isCheckCardMRZ : Bool = false
    var isCheckcardBack : Bool = false
    var isCheckCardBackFrint : Bool = false
    var isCheckScanOCR : Bool = false
    var arrCardSide : [String] = [String]()
    var isCardSide : Bool?
    var isBack : Bool?
    var isFront : Bool?
    var isConnection : Bool?
    var imgViewCardFront : UIImage?
    var dictSecuretyData : NSMutableDictionary = [:]
    var dictFaceDataFront: NSMutableDictionary = [:]
    var dictFaceDataBack: NSMutableDictionary = [:]
    var dictOCRTypeData:NSMutableDictionary = [:]
    var arrBackFrontImage : [UIImageView] = [UIImageView]()
    
    var stUrl : String?
    var arrimgCountData = [String]()
    var cardType: Int? = 0
    var MRZDocType:Int? = 0
    
    var arrImageName : [String] = [String]()
    
    var dictScanningData:NSDictionary = NSDictionary()
    
    var isflipanimation : Bool?
    
    var isChangeMRZ : Bool?
    var imgPhoto : UIImage?
    
    var isCheckFirstTime : Bool?
    var mrzElementName: String = ""
    var dictScanningMRZData: NSMutableDictionary = [:]
    var setImage : Bool?
    var isFrontDataComplate: Bool?
    var isBackDataComplate: Bool?
    var stCountryCardName: String?
    var cardImage: UIImage?
    var isBackSide: Bool?
    
    var arrFrontResultKey : [String] = []
    var arrFrontResultValue : [String] = []
    var arrBackResultKey : [String] = []
    var arrBackResultValue : [String] = []
    var isCheckMRZData: Bool?
    var secondCallData: Bool?
    
    var isFirstTimeStartCamara: Bool?
    var countface = 0
    var statusBarRect = CGRect()
    var bottomPadding:CGFloat = 0.0
    var topPadding: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        statusBarRect = UIApplication.shared.statusBarFrame
        let window = UIApplication.shared.windows.first
       
        if #available(iOS 11.0, *) {
            bottomPadding = window!.safeAreaInsets.bottom
            topPadding = window!.safeAreaInsets.top
        } else {
            // Fallback on earlier versions
        }
        
        isFirstTimeStartCamara = false
        isCheckFirstTime = false
        viewStatusBar.backgroundColor = UIColor(red: 231.0 / 255.0, green: 52.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
        viewNavigationBar.backgroundColor = UIColor(red: 231.0 / 255.0, green: 52.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
        _imageView.layer.masksToBounds = false
        _imageView.clipsToBounds = true
//        NotificationCenter.default.addObserver(self, selector: #selector(ChangedOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
        ChangedOrientation()
        var width : CGFloat = 0
        var height : CGFloat = 0
        width = UIScreen.main.bounds.size.width
        height = UIScreen.main.bounds.size.height
        width = width * 0.95
        height = height * 0.35
//        _constant_width.constant = width
//        _constant_height.constant = height
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        _viewLayer.layer.borderColor = UIColor.red.cgColor
        _viewLayer.layer.borderWidth = 3.0
        self._imgFlipView.isHidden = true
        if status == .authorized {
           isCheckFirstTime = true
            self.setOCRData()
            let shortTap = UITapGestureRecognizer(target: self, action: #selector(handleTapToFocus(_:)))
            shortTap.numberOfTapsRequired = 1
            shortTap.numberOfTouchesRequired = 1
            self.view.addGestureRecognizer(shortTap)
        } else if status == .denied {
            let alert = UIAlertController(title: "AccuraSdk", message: "It looks like your privacy settings are preventing us from accessing your camera.", preferredStyle: .alert)
            let yesButton = UIAlertAction(title: "OK", style: .default) { _ in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                }
            }
            alert.addAction(yesButton)
            self.present(alert, animated: true, completion: nil)
        } else if status == .restricted {
        } else if status == .notDetermined  {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                   self.isCheckFirstTime = true
                    self.isFirstTimeStartCamara = true
                    DispatchQueue.main.async {
                        self._imageView.setNeedsLayout()
                        self._imageView.layoutSubviews()
                        self.setOCRData()
//                        self.ChangedOrientation()
                        self.accuraCameraWrapper?.startCamera()
                    }
                    let shortTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapToFocus(_:)))
                    shortTap.numberOfTapsRequired = 1
                    shortTap.numberOfTouchesRequired = 1
                } else {
                    // print("Not granted access")
                }
            }
        }
         
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self._imageView.setNeedsLayout()
        self._imageView.layoutSubviews()
        self._imageView.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        countface = 0
        self.shareScanningListing.removeAllObjects()
        isBackSide = false
        isCheckMRZData = false
//         self.ChangedOrientation()
        if self.accuraCameraWrapper == nil {
                setOCRData()
        }

        if isFirstTimeStartCamara!{
          accuraCameraWrapper?.startCamera()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isFirstTimeStartCamara! && isCheckFirstTime!{
          isFirstTimeStartCamara = true
          accuraCameraWrapper?.startCamera()
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        accuraCameraWrapper?.stopCamera()
        accuraCameraWrapper?.closeOCR()
        accuraCameraWrapper = nil
        _imageView.image = nil
        super.viewWillDisappear(animated)
    }
    
    @IBAction func backAction(_ sender: Any) {
        accuraCameraWrapper?.stopCamera()
        accuraCameraWrapper?.closeOCR()
        arrFrontResultKey.removeAll()
        arrBackResultKey.removeAll()
        arrFrontResultValue.removeAll()
        arrBackResultValue.removeAll()
        dictSecuretyData.removeAllObjects()
        dictFaceDataBack.removeAllObjects()
        dictFaceDataFront.removeAllObjects()
        dictScanningMRZData.removeAllObjects()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonFlipAction(_ sender: UIButton) {
        accuraCameraWrapper?.switchCamera()
    }
    
    //MARK:- Other Method
    func setOCRData(){
        arrFrontResultKey.removeAll()
        arrBackResultKey.removeAll()
        arrFrontResultValue.removeAll()
        arrBackResultValue.removeAll()
        dictSecuretyData.removeAllObjects()
        dictFaceDataBack.removeAllObjects()
        dictFaceDataFront.removeAllObjects()
        dictScanningMRZData.removeAllObjects()
        isCheckCard = false
        isCheckcardBack = false
        isCheckCardBackFrint = false
        isflipanimation = false
        imgPhoto = nil
        isFrontDataComplate = false
        isBackDataComplate = false
        DispatchQueue.main.async {
                self._lblTitle.text = "Scan Front Side of Document"
            
        }
         
        accuraCameraWrapper = AccuraCameraWrapper.init(delegate: self, andImageView: _imageView, andLabelMsg: lblOCRMsg, andurl: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String, cardId: Int32(cardid!), countryID: Int32(countryid!), isScanOCR: isCheckScanOCR, andLabelMsgTop: _lblTitle, andcardName: docName, andcardType: Int32(cardType!), andMRZDocType: Int32(MRZDocType!))
    }
    
    @objc private func ChangedOrientation() {
        var width: CGFloat = 0.0
        var height: CGFloat = 0.0
        
        let orientastion = UIApplication.shared.statusBarOrientation
        if(orientastion ==  UIInterfaceOrientation.portrait) {
            width = UIScreen.main.bounds.size.width * 0.95
            
            height  = (UIScreen.main.bounds.size.height - (self.bottomPadding + self.topPadding + self.statusBarRect.height)) * 0.35
            viewNavigationBar.backgroundColor = UIColor(red: 231.0 / 255.0, green: 52.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
//            self.viewNavigationBar.backgroundColor = #colorLiteral(red: 0.8352941176, green: 0.1960784314, blue: 0.2470588235, alpha: 1)
        } else {
//            height = UIScreen.main.bounds.size.height - ( viewNavigationBar.frame.height + 80)
////            print(self.bottomPadding + self.topPadding + self.statusBarRect.height + viewNavigationBar.frame.height)
//            width  = height / 0.69
            self.viewNavigationBar.backgroundColor = .clear
            height = UIScreen.main.bounds.size.height * 0.62
            width = UIScreen.main.bounds.size.width * 0.51
        }
       
        self._constant_width.constant = width
        self._constant_height.constant = height
        
       // videoCameraWrapper?.changedOrintation(width, height: height)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }) { _ in
                
            }
        }
    }
    
    @objc func handleTapToFocus(_ tapGesture: UITapGestureRecognizer?) {
        let acd = AVCaptureDevice.default(for: .video)
        if tapGesture!.state == .ended {
            let thisFocusPoint = tapGesture!.location(in: _viewLayer)
            let focus_x = Double(thisFocusPoint.x / _viewLayer.frame.size.width)
            let focus_y = Double(thisFocusPoint.y / _viewLayer.frame.size.height)
            if acd?.isFocusModeSupported(.autoFocus) ?? false && acd?.isFocusPointOfInterestSupported != nil {
                do {
                    try acd?.lockForConfiguration()
                    
                    if try acd?.lockForConfiguration() != nil {
                        acd?.focusMode = .autoFocus
                        acd?.focusPointOfInterest = CGPoint(x: CGFloat(focus_x), y: CGFloat(focus_y))
                        acd?.unlockForConfiguration()
                    }
                } catch {
                }
            }
        }
    }
    
    func flipAnimation() {
        self._imgFlipView.isHidden = false
        UIView.animate(withDuration: 1.5, animations: {
            UIView.setAnimationTransition(.flipFromLeft, for: self._imgFlipView, cache: true)
            AudioServicesPlaySystemSound(1315)
        }) { _ in
            self._imgFlipView.isHidden = true
        }
    }
}

extension ViewController: VideoCameraWrapperDelegate {
    
    
    func screenSound() {
        AudioServicesPlaySystemSound(SystemSoundID(1315))
         if !self.isflipanimation!{
            self.isflipanimation = true
             self.flipAnimation()
             self._lblTitle.text = "Scan Back Side of Document"
        }
       
    }
    
    
    func recognizeFailed(_ message: String!) {
//        GlobalMethods.showAlertView(message, with: self)
    }
    
    func recognizeSucceed(_ scanedInfo: NSMutableDictionary!, recType: RecType, bRecDone: Bool, bFaceReplace: Bool, bMrzFirst: Bool, photoImage: UIImage, docFrontImage: UIImage!, docbackImage: UIImage!) {
//            var imgFace: UIImage?
//            imgFace = photoImage
//            if(imgFace != nil)
//            {
                if(bMrzFirst)
                    
                {
                    if isBackSide!{
    //                  if let image_photoImage: Data = dictScanningData["documentImage"] as? Data {
    //                    self.documentImage = UIImage(data: image_photoImage)
    //                    }
                        
                      documentImage = docbackImage
                        if(docFrontImage != nil) {
                            self.docfrontImage = docFrontImage
                        }
                    }else{
                       documentImage = nil
    //                    if let image_photoImage: Data = dictScanningData["docfrontImage"] as? Data {
    //                    self.docfrontImage = UIImage(data: image_photoImage)
    //                    }
                       self.docfrontImage = docFrontImage
                        
                    }
                    self.imageRotation(rotation: "BackImg")
                    self.accuraCameraWrapper?.stopCamera()
                    self._imageView.image = nil
            
                    AudioServicesPlaySystemSound(1315)
                    
                    self.shareScanningListing = scanedInfo
                    let shareScanningListing: NSMutableDictionary = self.shareScanningListing
                    if documentImage != nil{
                        shareScanningListing["documentImage"] = documentImage?.jpegData(compressionQuality: 1.0)
                    }
                    shareScanningListing["docfrontImage"] = docfrontImage?.jpegData(compressionQuality: 1.0)
                    shareScanningListing["fontImageRotation"] = frontImageRotation
                    shareScanningListing["backImageRotation"] = backImageRotation
                    let vc : ShowResultVC = self.storyboard?.instantiateViewController(withIdentifier: "ShowResultVC") as! ShowResultVC
                    vc.scannedData = shareScanningListing
                    vc.stCountryCardName = stCountryCardName
                    vc.imageCountryCard = cardImage
                    vc.isBackSide = isBackSide
                    vc.pageType = .ScanPassport
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else{
                    countface += 1
                    if !isBackSide!{
                    if(countface > 2)
                    {
                        countface = 0
                        self.docfrontImage = self._imageView.image
                        self.imageRotation(rotation: "FrontImage")
                        isBackSide = true
                        self._lblTitle.text = "Scan Back Side of Document"
                        self.flipAnimation()
                        return
                    }
                    }
                    else{
                        return
                    }
                }
//            }
//            else{
//                return
//            }
        }
    

    
    func passDataOtherViewController(){
        let vc : ShowResultVC = self.storyboard?.instantiateViewController(withIdentifier: "ShowResultVC") as! ShowResultVC
        vc.imgViewCountryCard = self.imgViewCard
        vc.imgViewBack = self.imgViewCard
        vc.imgViewFront = self.imgViewCardFront
        vc.dictScanningData = self.dictScanningData
        vc.pageType = .ScanOCR
        vc.imagePhoto = self.imgPhoto
        vc.scannedData = dictScanningMRZData
        vc.stCountryCardName = stCountryCardName
        vc.imageCountryCard = cardImage
        vc.dictFaceData = dictFaceDataFront
        vc.dictSecurityData = dictSecuretyData
        vc.dictFaceBackData = dictFaceDataBack
        vc.arrDataForntKey = arrFrontResultKey
        vc.arrDataForntValue = arrFrontResultValue
        vc.arrDataBackKey = arrBackResultKey
        vc.arrDataBackValue = arrBackResultValue
        vc.dictOCRTypeData = dictOCRTypeData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func processedImage(_ image: UIImage!) {
        
    }
    
    func imageRotation(rotation: String) {
        var strRotation = ""
        if UIDevice.current.orientation == .landscapeRight {
            strRotation = "Right"
        } else if UIDevice.current.orientation == .landscapeLeft {
            strRotation = "Left"
        }
        if rotation == "FrontImg" {
            frontImageRotation = strRotation
        } else if rotation == "BackImg" {
            backImageRotation = strRotation
        } else {
            frontImageRotation = strRotation
        }
    }
    func reco_msg(_ message: String!) {
        var msg = String();
        if(message == ACCURA_ERROR_CODE_MOTION) {
            msg = "Keep Document Steady";
        } else if(message == ACCURA_ERROR_CODE_DOCUMENT_IN_FRAME) {
            msg = "Keep document in frame";
        } else if(message == ACCURA_ERROR_CODE_BRING_DOCUMENT_IN_FRAME) {
            msg = "Bring card near to frame";
        } else if(message == ACCURA_ERROR_CODE_PROCESSING) {
            msg = "Processing...";
        } else if(message == ACCURA_ERROR_CODE_BLUR_DOCUMENT) {
            msg = "Blur detect in document";
        } else if(message == ACCURA_ERROR_CODE_FACE_BLUR) {
            msg = "Blur detected over face";
        } else if(message == ACCURA_ERROR_CODE_GLARE_DOCUMENT) {
            msg = "Glare detect in document";
        } else if(message == ACCURA_ERROR_CODE_HOLOGRAM) {
            msg = "Hologram Detected";
        } else if(message == ACCURA_ERROR_CODE_DARK_DOCUMENT) {
            msg = "Low lighting detected";
        } else if(message == ACCURA_ERROR_CODE_PHOTO_COPY_DOCUMENT) {
            msg = "Can not accept Photo Copy Document";
        } else if(message == ACCURA_ERROR_CODE_FACE) {
            msg = "Face not detected";
        } else if(message == ACCURA_ERROR_CODE_MRZ) {
            msg = "MRZ not detected";
        } else if(message == ACCURA_ERROR_CODE_PASSPORT_MRZ) {
            msg = "Passport MRZ not detected";
        } else if(message == ACCURA_ERROR_CODE_ID_MRZ) {
            msg = "ID MRZ not detected"
        } else if(message == ACCURA_ERROR_CODE_VISA_MRZ) {
            msg = "Visa MRZ not detected"
        }else {
            msg = message;
        }
        lblOCRMsg.text = msg
    }
}

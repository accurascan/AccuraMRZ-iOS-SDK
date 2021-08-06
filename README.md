# Accura MRZ iOS SDK

Below steps to setup AccuraMRZ SDK's in your project.


## 1. Setup Accura MRZ

#### Step 1: install the AccuraMRZSDK pod
    pod 'AccuraMRZSDK', '2.1.0'
         
#### Step 2: Add license file in to your project.    

- `key.license`
   
Generate your Accura license from https://accurascan.com/developer/dashboard <br/>
            
#### Step 3: To initialize sdk on app start:

    import AccuraMRZ

    var accuraCameraWrapper: AccuraCameraWrapper? = nil
    var arrCountryList = NSMutableArray()
    accuraCameraWrapper = AccuraCameraWrapper.init()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
    
	    let sdkModel = accuraCameraWrapper.loadEngine(your PathForDirectories)
		if (sdkModel.i > 0) {
			if(sdkModel!.isMRZEnable) {
				self.arrCountryList.add("All MRZ")
				// ID MRZ
				// Visa MRZ
				// Passport MRZ
				// Other MRZ
				
			}
      	}
      	
	}

##### Update filters config like below.
  Call this function after initialize sdk if license is valid(sdkModel.i > 0)
   
   * Set Blur Percentage to allow blur on document
     ```
     // 0 for clean document and 100 for Blurry document
     accuraCameraWrapper?.setFaceBlurPercentage(int /*blurPercentage*/60)
     ```    
    
   * Set Blur Face Percentage to allow blur on detected Face
     ```
     // 0 for clean face and 100 for Blurry face
     accuraCameraWrapper?.setFaceBlurPercentage(int /*faceBlurPercentage*/80)
     ```
   
   * Set Glare Percentage to detect Glare on document
   	 ```
     // Set min and max percentage for glare
     accuraCameraWrapper?.setGlarePercentage(int /*minPercentage*/6, int /*maxPercentage*/98)
   	 ``` 
     
   * Set Photo Copy to allow photocopy document or not
     ```
     // Set allow photocopy document or not
     accuraCameraWrapper?.setCheckPhotoCopy(bool /*isCheckPhotoCopy*/false)
     ```
     
   * Set Hologram detection to verify the hologram on the face
	 ```
	 // true to check hologram on face
	 accuraCameraWrapper?.setHologramDetection(boolean /*isDetectHologram*/true)
	 ```
     
   * Set Low Light Tolerance to allow lighting to detect documant
     ```
     // 0 for full dark document and 100 for full bright document
     accuraCameraWrapper?.setLowLightTolerance(int /*lowlighttolerance*/10)
     ``` 
   * Set motion threshold to detect motion on camera document
   	 ```
     // 1 - allows 1% motion on document and
	 // 100 - it can not detect motion and allow document to scan.
     accuraCameraWrapper?.setMotionThreshold(int /*setMotionThreshold*/4 string /*message*/ "Keep Document Steady")
     ```
     
   * Sets camera Facing front or back camera
     ```
     accuraCameraWrapper?.setCameraFacing(.CAMERA_FACING_BACK)
     ```
     
   * Flip camera
  ```
  accuraCameraWrapper?.switchCamera()
  ```
   * Enable Print logs in MRZ
   ```
   accuraCameraWrapper?.showLogFile(true) // Set true to print log from MRZ SDK
   ```

     
#### Step 4 : Set CameraView

   Important Grant Camera and storage Permission.</br>
   supports Landscape Camera
```    
    import AccuraMRZ
    import AVFoundation
    
    var accuraCameraWrapper: AccuraCameraWrapper? = nil

  	override func viewDidLoad() {
    	super.viewDidLoad()
    	let status = AVCaptureDevice.authorizationStatus(for: .video)
    
    
    	if status == .authorized {
         	accuraCameraWrapper = AccuraCameraWrapper.init(delegate: self, andImageView: /*setImageView*/ _imageView, andLabelMsg: */setLable*/ lblOCRMsg, andurl: */your PathForDirectories*/ NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String, cardId: /*setCardId*/ Int32(0!), countryID: /*setcountryid*/ Int32(0!), isScanOCR:/*Bool*/ false, andLabelMsgTop:/*Lable*/ _lblTitle, andcardName:/*string*/  docName, andcardType: Int32(cardType), andMRZDocType: /*SetMRZDocumentType*/ Int32(MRZDocType!/*0 = OtherMRZ, 1 = PassportMRZ, 2 = IDMRZ, 3 = VisaMRZ*/))
    	} 
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
          accuraCameraWrapper?.startCamera()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        accuraCameraWrapper?.stopCamera()
        accuraCameraWrapper = nil
        super.viewWillDisappear(animated)
    }
    
    extension ViewController: VideoCameraWrapperDelegate{
    
   		//  it calls continues when scan cards
   		func processedImage(_ image: UIImage!) {
    		image:- get camara image.
    	}
    
    	// it call when license key wrong otherwise didnt get key
    	func recognizeFailed(_ message: String!) {
    		message:- message is a set alert message.
    	}
    
    	// it calls when get MRZ data
    	func recognizeSucceed(_ scanedInfo: NSMutableDictionary!, recType: RecType, bRecDone: Bool, bFaceReplace: Bool, bMrzFirst: Bool, photoImage: UIImage, docFrontImage: UIImage!, docbackImage: UIImage!) {
    		scanedInfo :- get MRZ data.
    		photoImage:- get a document face Image.
    		docFrontImage:- get document frontside image.
   		 	docbackImage:- get document backside image.
    	}
        
    // it calls when recieve error message
    func reco_msg(_ messageCode: String!) {
			var message = String()
        if messageCode == ACCURA_ERROR_CODE_MOTION {
            message = "Keep Document Steady";
        } else if(messageCode == ACCURA_ERROR_CODE_DOCUMENT_IN_FRAME) {
            message = "Keep document in frame";
        } else if(messageCode == ACCURA_ERROR_CODE_BRING_DOCUMENT_IN_FRAME) {
            message = "Bring card near to frame";
        } else if(messageCode == ACCURA_ERROR_CODE_PROCESSING) {
            message = "Processing...";
        } else if(messageCode == ACCURA_ERROR_CODE_BLUR_DOCUMENT) {
            message = "Blur detect in document";
        } else if(messageCode == ACCURA_ERROR_CODE_FACE_BLUR) {
            message = "Blur detected over face";
        } else if(messageCode == ACCURA_ERROR_CODE_GLARE_DOCUMENT) {
            message = "Glare detect in document";
        } else if(messageCode == ACCURA_ERROR_CODE_HOLOGRAM) {
            message = "Hologram Detected";
        } else if(messageCode == ACCURA_ERROR_CODE_DARK_DOCUMENT) {
            message = "Low lighting detected";
        } else if(messageCode == ACCURA_ERROR_CODE_PHOTO_COPY_DOCUMENT) {
            message = "Can not accept Photo Copy Document";
        } else if(messageCode == ACCURA_ERROR_CODE_FACE) {
            message = "Face not detected";
        } else if(messageCode == ACCURA_ERROR_CODE_MRZ) {
            message = "MRZ not detected";
        } else if(messageCode == ACCURA_ERROR_CODE_PASSPORT_MRZ) {
            message = "Passport MRZ not detected";
        } else if(messageCode == ACCURA_ERROR_CODE_ID_MRZ) {
            message = "ID MRZ not detected"
        } else if(messageCode == ACCURA_ERROR_CODE_VISA_MRZ) {
            message = "Visa MRZ not detected"
        }else {
            message = message;
        }
    		print(message)
 	}
```

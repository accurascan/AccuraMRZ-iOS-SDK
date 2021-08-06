
import UIKit
import AccuraMRZ


//Define Global Key
let KEY_TITLE           =  "KEY_TITLE"
let KEY_VALUE           =  "KEY_VALUE"
let KEY_FACE_IMAGE      =  "KEY_FACE_IMAGE"
let KEY_FACE_IMAGE2     =  "KEY_FACE_IMAGE2"
let KEY_DOC1_IMAGE      =  "KEY_DOC1_IMAGE"
let KEY_DOC2_IMAGE      =  "KEY_DOC2_IMAGE"

struct Objects {
    var name : String!
    var objects : String!
    
    init(sName: String, sObjects: String) {
        self.name = sName
        self.objects = sObjects
    }
    
}

class ShowResultVC: UIViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK:- Outlet
    @IBOutlet weak var img_height: NSLayoutConstraint!
    @IBOutlet weak var lblLinestitle: UILabel!
    @IBOutlet weak var tblResult: UITableView!
    @IBOutlet weak var imgPhoto: UIImageView!
    
    
    @IBOutlet weak var viewTable: UIView!
    
    @IBOutlet weak var viewStatusBar: UIView!
    
    @IBOutlet weak var viewNavigationBar: UIView!
    
    @IBOutlet weak var labelTitle: UILabel!
    
    //MARK:- Variable
    let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var uniqStr = ""
    var mrz_val = ""
    
    var imgDoc: UIImage?
    var retval: Int = 0
    var lines = ""
    var success = false
    var isFLpershow = false
    var passportType = ""
    var country = ""
    var surName = ""
    var givenNames = ""
    var passportNumber = ""
    var passportNumberChecksum = ""
    var correctPassportChecksum = ""
    var nationality = ""
    var birth = ""
    var birthChecksum = ""
    var correctBirthChecksum = ""
    var sex = ""
    var expirationDate = ""
    var otherID = ""
    var expirationDateChecksum = ""
    var correctExpirationChecksum = ""
    var personalNumber = ""
    var personalNumber2 = ""
    var personalNumberChecksum = ""
    var correctPersonalChecksum = ""
    var secondRowChecksum = ""
    var correctSecondrowChecksum = ""
    var placeOfBirth = ""
    var placeOfIssue = ""
    var issuedate = ""
    var departmentNumber = ""

    var fontImgRotation = ""
    var backImgRotation = ""
    
    var photoImage: UIImage?
    var documentImage: UIImage?
    
    var isFirstTime:Bool = false
    var arrDocumentData: [[String:AnyObject]] = [[String:AnyObject]]()
    var dictDataShow: [String:AnyObject] = [String:AnyObject]()
    var appDocumentImage: [UIImage] = [UIImage]()
    var pageType: NAV_PAGETYPE = .Default
    
    var matchImage: UIImage?
    var liveImage: UIImage?
    var bankCardImage: UIImage?
    
    let picker: UIImagePickerController = UIImagePickerController()
    var stLivenessResult: String = ""
    
    var scannedData: NSMutableDictionary = [:]
    
    var dictFaceData : NSMutableDictionary = [:]
    var dictSecurityData : NSMutableDictionary = [:]
    var dictFaceBackData : NSMutableDictionary = [:]
    var dictOCRTypeData: NSMutableDictionary = [:]
    var stFace : String?
    var imgViewCountryCard : UIImage?
    var imgSignature : UIImage?
    var imgViewFront : UIImage?
    var imgViewBack : UIImage?
    var arrSecurity = [String]()
    var arrSecurityTrueFalse = [String]()
    var dictScanningData:NSDictionary = NSDictionary()
    var imagePhoto : UIImage?
    var faceImage: UIImage?
    var imgCamaraFace: UIImage?
    var frontDataIndex: Int?
    var backDataIndex: Int?
    var securtiyDataIndex: Int?
    var arrFaceLivenessScor  = [Objects]()
    var arrFrontMail: [[String:AnyObject]] = [[String:AnyObject]]()
    var arrBackMail: [[String:AnyObject]] = [[String:AnyObject]]()
    var stCountryCardName: String?
    var imageCountryCard: UIImage?
    var isChecktrue: Bool?
    var faceScoreData: String?
    var isCheckLiveNess: Bool?
    var isBackSide: Bool?
    var arrDataForntKey: [String] = []
    var arrDataForntValue: [String] = []
    var arrDataBackKey: [String] = []
    var arrDataBackValue: [String] = []
    var arrDataForntValue1: [String] = []
    var arrDataBackValue1: [String] = []
    var arrOCRTypeData: [String] = []
    var plateNumber: String?
    var DLPlateImage: UIImage?
    var ischekLivess: Bool = false
    var livenessValue: String = ""
    var intID: Int?
    var orientation: UIInterfaceOrientationMask?

    
    //MARK:- UIViewContoller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        isCheckLiveNess = false
        viewStatusBar.backgroundColor = UIColor(red: 231.0 / 255.0, green: 52.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
        viewNavigationBar.backgroundColor = UIColor(red: 231.0 / 255.0, green: 52.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
        
        isFirstTime = true
        
        
//        AppDelegate.AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        /*
         FaceMatch SDK method to check if engine is initiated or not
         Return: true or false
         */
        NotificationCenter.default.addObserver(self, selector: #selector(loadPhotoCaptured), name: NSNotification.Name("_UIImagePickerControllerUserDidCaptureItem"), object: nil)
//                // print(dictScanningData)
                dictScanningData = NSDictionary(dictionary: scannedData)

                if let stFontRotaion:String = dictScanningData["fontImageRotation"] as? String{
                    fontImgRotation = stFontRotaion
                }
                if let stBackRotaion:String = dictScanningData["backImageRotation"] as? String{
                    backImgRotation = stBackRotaion
                }
                scanMRZData()
                if let image_photoImage: Data = dictScanningData["photoImage"] as? Data {
                    self.photoImage = UIImage(data: image_photoImage)
                }
                if let image_documentFontImage: Data = dictScanningData["docfrontImage"] as? Data  {
                    appDocumentImage.append(UIImage(data: image_documentFontImage)!)
                }
                
                if let image_documentImage: Data = dictScanningData["documentImage"] as? Data  {
                    appDocumentImage.append(UIImage(data: image_documentImage)!)
                }
                imgDoc = documentImage
        
        
        //**************************************************************//
        
        //Register Table cell
        self.tblResult.register(UINib.init(nibName: "UserImgTableCell", bundle: nil), forCellReuseIdentifier: "UserImgTableCell")
        
        self.tblResult.register(UINib.init(nibName: "ResultTableCell", bundle: nil), forCellReuseIdentifier: "ResultTableCell")
        
        self.tblResult.register(UINib.init(nibName: "DocumentTableCell", bundle: nil), forCellReuseIdentifier: "DocumentTableCell")
        
        self.tblResult.register(UINib.init(nibName: "FaceMatchResultTableViewCell", bundle: nil), forCellReuseIdentifier: "FaceMatchResultTableViewCell")
        
        self.tblResult.register(UINib.init(nibName: "DocumantVarifyCell", bundle: nil), forCellReuseIdentifier: "DocumantVarifyCell")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Set TableView Height
        self.tblResult.estimatedRowHeight = 60.0
        self.tblResult.rowHeight = UITableView.automaticDimension
        if pageType == .BankCard {
           
        } else if pageType != .ScanOCR {
            if isFirstTime{
                isFirstTime = false
                self.setData() // this function Called set data in tableView
            }
        } else{
            if isFirstTime{
                isFirstTime = false
                if dictScanningData.count != 0{
                    setOnlyMRZData()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    override func viewDidDisappear(_ animated: Bool) {
//        let orientastion = UIApplication.shared.statusBarOrientation
       
    }
    override func viewWillDisappear(_ animated: Bool) {
       
    }
    //MARK:- Custom Methods
    func scanMRZData(){
        if let strline: String =  dictScanningData["lines"] as? String {
            self.lines = strline
        }
        if let strpassportType: String =  dictScanningData["passportType"] as? String  {
            self.passportType = strpassportType
        }
        if let stRetval: String = dictScanningData["retval"] as? String   {
            self.retval = Int(stRetval) ?? 0
        }
        if let strcountry: String =  dictScanningData["country"] as? String {
            self.country = strcountry
        }
        if let strsurName: String = dictScanningData["surName"] as? String {
            self.surName = strsurName
        }
        if let strgivenNames: String =  dictScanningData["givenNames"] as? String  {
            self.givenNames = strgivenNames
        }
        if let strpassportNumber: String = dictScanningData["passportNumber"] as? String   {
            self.passportNumber = strpassportNumber
        }
        if let strpassportType: String =  dictScanningData["passportType"] as? String {
            self.passportType = strpassportType
        }
        
        if let strpassportNumberChecksum: String = dictScanningData["passportNumberChecksum"] as? String {
            self.passportNumberChecksum = strpassportNumberChecksum
        }
        if let stcorrectPassportChecksum: String = dictScanningData["correctPassportChecksum"] as? String{
            self.correctPassportChecksum = stcorrectPassportChecksum
        }
        if let strnationality: String =  dictScanningData["nationality"] as? String  {
            self.nationality = strnationality
        }
        if let strbirth: String = dictScanningData["birth"] as? String  {
            self.birth = strbirth
        }
        if let strbirthChecksum: String = dictScanningData["BirthChecksum"] as? String{
            self.birthChecksum = strbirthChecksum
        }
        if let stcorrectBirthChecksum: String = dictScanningData["correctBirthChecksum"] as? String{
            self.correctBirthChecksum = stcorrectBirthChecksum
        }
        if let strsex: String =  dictScanningData["sex"] as? String {
            self.sex = strsex
        }
        if let strexpirationDate: String = dictScanningData["expirationDate"] as? String {
            self.expirationDate = strexpirationDate
        }
        
        if let strexpirationDateChecksum: String = dictScanningData["expirationDateChecksum"] as? String  {
            self.expirationDateChecksum = strexpirationDateChecksum
        }
        if let stcorrectExpirationChecksum: String = dictScanningData["correctExpirationChecksum"] as? String{
            self.correctExpirationChecksum = stcorrectExpirationChecksum
        }
        if let strpersonalNumber: String = dictScanningData["personalNumber"] as? String{
            self.personalNumber = strpersonalNumber
        }
        if let strpersonalNumberChecksum: String = dictScanningData["personalNumberChecksum"] as? String {
            self.personalNumberChecksum = strpersonalNumberChecksum
        }
        if let stcorrectPersonalChecksum: String = dictScanningData["correctPersonalChecksum"] as? String{
            self.correctPersonalChecksum = stcorrectPersonalChecksum
        }
        if let strpersonalNumber2: String = dictScanningData["personalNumber2"] as? String{
            self.personalNumber2 = strpersonalNumber2
        }
        if let strsecondRowChecksum: String = dictScanningData["secondRowChecksum"] as? String {
            self.secondRowChecksum = strsecondRowChecksum
        }
        if let stcorrectSecondrowChecksum: String = dictScanningData["correctSecondrowChecksum"] as? String{
            self.correctSecondrowChecksum = stcorrectSecondrowChecksum
        }
        if let strplaceOfBirth: String = dictScanningData["placeOfBirth"] as? String{
            self.placeOfBirth = strplaceOfBirth
        }
        if let strplaceOfIssue: String = dictScanningData["placeOfIssue"] as? String {
            self.placeOfIssue = strplaceOfIssue
        }
        
        if let strissuedate: String = dictScanningData["issuedate"] as? String {
            self.issuedate = strissuedate
        }
        
        if let strdepartmentNumber: String = dictScanningData["departmentNumber"] as? String {
            self.departmentNumber = strdepartmentNumber
        }
    }
    
    func setOnlyMRZData(){
        for index in 0..<23{
            var dict: [String:AnyObject] = [String:AnyObject]()
            switch index {
            case 0:
                dict = [KEY_VALUE: lines] as [String : AnyObject]
                arrDocumentData.append(dict)
                break
            case 1:
                var firstLetter: String = ""
                var strFstLetter: String = ""
                let strPassportType = passportType.lowercased()
                if !lines.isEmpty{
                    firstLetter = (lines as? NSString)?.substring(to: 1) ?? ""
                    strFstLetter = firstLetter.lowercased()
                }
                var dType: String = ""
                if strPassportType == "v" || strFstLetter == "v" {
                    dType = "VISA"
                }
                else if passportType == "p" || strFstLetter == "p" {
                    dType = "PASSPORT"
                }
                else if passportType == "d" || strFstLetter == "p" {
                    dType = "DRIVING LICENCE"
                }
                else {
                    if (strFstLetter == "d") {
                        dType = "DRIVING LICENCE"
                    } else {
                        dType = "ID"
                    }
                }
                dict = [KEY_VALUE: dType,KEY_TITLE:"Document"] as [String : AnyObject]
                arrDocumentData.append(dict)
                break
            case 2:
                if surName != ""{
                    dict = [KEY_VALUE: surName,KEY_TITLE:"Last Name"] as [String : AnyObject]
                    arrDocumentData.append(dict)
                    
                }
                break
            case 3:
                if givenNames != ""{
                    dict = [KEY_VALUE: givenNames,KEY_TITLE:"First Name"] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 4:
                if passportNumber != ""{
                    let stringWithoutSpaces = passportNumber.replacingOccurrences(of: "<", with: "")
                    dict = [KEY_VALUE: stringWithoutSpaces,KEY_TITLE:"Document No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
            case 5:
                if passportNumberChecksum != ""{
                    dict = [KEY_VALUE: passportNumberChecksum,KEY_TITLE:"Document Check No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 6:
                if correctPassportChecksum != ""{
                    dict = [KEY_VALUE: correctPassportChecksum,KEY_TITLE:"Correct Document Check No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
                
            case 7:
                if country != ""{
                    dict = [KEY_VALUE: country,KEY_TITLE:"Country"] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 8:
                if nationality != ""{
                    dict = [KEY_VALUE: nationality,KEY_TITLE:"Nationality"] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
                
            case 9:
                var stSex: String = ""
                if sex == "F" {
                    stSex = "FEMALE";
                }else if sex == "M" {
                    stSex = "MALE";
                } else {
                    stSex = sex
                }
                dict = [KEY_VALUE: stSex,KEY_TITLE:"Sex"] as [String : AnyObject]
                arrDocumentData.append(dict)
                break
                
            case 10:
                if birth != "" {
                    let birthDate = date(toFormatedDate: birth)
                    if birthDate != "" && birthDate != nil{
                        
                        dict = [KEY_VALUE: birthDate,KEY_TITLE:"Date of Birth"] as [String : AnyObject]
                        arrDocumentData.append(dict)
                    }
                }
                break
            case 11:
                if birthChecksum != ""{
                    dict = [KEY_VALUE: birthChecksum,KEY_TITLE:"Birth Check No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 12:
                if correctBirthChecksum != ""{
                    dict = [KEY_VALUE: correctBirthChecksum,KEY_TITLE:"Correct Birth Check No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
                
            case 13:
                if expirationDate != "" {
                    let expiryDate = date(toFormatedDate: expirationDate)
                    
                    if expiryDate != "" && expiryDate != nil{
                        
                        dict = [KEY_VALUE: expiryDate,KEY_TITLE:"Date of Expiry"] as [String : AnyObject]
                        arrDocumentData.append(dict)
                    }
                }
                break
            case 14:
                if expirationDateChecksum != ""{
                    dict = [KEY_VALUE: expirationDateChecksum,KEY_TITLE:"Expiration Check No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 15:
                if correctExpirationChecksum != ""{
                    dict = [KEY_VALUE: correctExpirationChecksum,KEY_TITLE:"Correct Expiration Check No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 16:
                if personalNumber != ""{
                    dict = [KEY_VALUE: personalNumber,KEY_TITLE:"Other ID"] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 17:
                if personalNumberChecksum != ""{
                    dict = [KEY_VALUE: personalNumberChecksum,KEY_TITLE:"Other ID Check No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 18:
                if personalNumber2 != ""{
                    dict = [KEY_VALUE: personalNumber2,KEY_TITLE:"Other ID 2"] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 19:
                if secondRowChecksum != ""{
                    dict = [KEY_VALUE: secondRowChecksum,KEY_TITLE:"Second Row Check No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 20:
                if correctSecondrowChecksum != ""{
                    dict = [KEY_VALUE: correctSecondrowChecksum,KEY_TITLE:"Correct Second Row Check No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
                
            case 21:
                if issuedate != "" {
                    let issueDate = date(toFormatedDate: issuedate)
                    if issueDate != "" && issueDate != nil{
                        dict = [KEY_VALUE: issueDate,KEY_TITLE:"Issue Date"] as [String : AnyObject]
                        arrDocumentData.append(dict)
                    }
                }
               
                break
            case 22:
                if departmentNumber != ""{
                    dict = [KEY_VALUE: departmentNumber,KEY_TITLE:"Department No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            default:
                break
            }
            
        }
        
    }
    
    /**
     * This method use set scanning data
     *
     */
    func setData(){
        //Set tableView Data
        for index in 0..<26 + appDocumentImage.count{
            var dict: [String:AnyObject] = [String:AnyObject]()
            switch index {
            case 0:
                if(photoImage != nil) {
                    dict = [KEY_FACE_IMAGE: photoImage] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                
                break
            case 1:
                break
                
            case 2:
                if(lines != "") {
                    dict = [KEY_VALUE: lines] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 3:
                
                var firstLetter: String = ""
                var strFstLetter: String = ""
                let strPassportType = passportType.lowercased()
                
                if !lines.isEmpty{
                    firstLetter = (lines as? NSString)?.substring(to: 1) ?? ""
                    strFstLetter = firstLetter.lowercased()
                }
                
                var dType: String = ""
                if strPassportType == "v" || strFstLetter == "v" {
                    dType = "VISA"
                }
                else if passportType == "p" || strFstLetter == "p" {
                    dType = "PASSPORT"
                }
                else if passportType == "d" || strFstLetter == "p" {
                    dType = "DRIVING LICENCE"
                }
                else {
                    if (strFstLetter == "d") {
                        dType = "DRIVING LICENCE"
                    } else {
                        dType = "ID"
                    }
                }
                if(dType != "") {
                    dict = [KEY_VALUE: dType,KEY_TITLE:"Document"] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 4:
                if(surName != "") {
                    dict = [KEY_VALUE: surName,KEY_TITLE:"Last Name"] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 5:
                if(givenNames != "") {
                    dict = [KEY_VALUE: givenNames,KEY_TITLE:"First Name"] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 6:
                let stringWithoutSpaces = passportNumber.replacingOccurrences(of: "<", with: "")
                if(stringWithoutSpaces != "") {
                    
                    dict = [KEY_VALUE: stringWithoutSpaces,KEY_TITLE:"Document No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                
            case 7:
                if(passportNumberChecksum != "") {
                    dict = [KEY_VALUE: passportNumberChecksum,KEY_TITLE:"Document Check No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 8:
                if(correctPassportChecksum != "") {
                    dict = [KEY_VALUE: correctPassportChecksum,KEY_TITLE:"Correct Document Check No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                    
                }
                break
            case 9:
                if(country != "") {
                    dict = [KEY_VALUE: country,KEY_TITLE:"Country"] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 10:
                if(nationality != "") {
                    dict = [KEY_VALUE: nationality,KEY_TITLE:"Nationality"] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 11:
                var stSex: String = ""
                if sex == "F" {
                    stSex = "FEMALE";
                }else if sex == "M" {
                    stSex = "MALE";
                } else {
                    stSex = sex
                }
                if(sex != "") {
                    dict = [KEY_VALUE: stSex,KEY_TITLE:"Sex"] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 12:
                if birth != "" {
                    let birthDate = date(toFormatedDate: birth)
                    if birthDate != "" && birthDate != nil{
                        
                        dict = [KEY_VALUE: birthDate,KEY_TITLE:"Date of Birth"] as [String : AnyObject]
                        arrDocumentData.append(dict)
                    }
                }
                break
            case 13:
                if(birthChecksum != "") {
                    dict = [KEY_VALUE: birthChecksum,KEY_TITLE:"Birth Check No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 14:
                if(correctBirthChecksum != "") {
                    dict = [KEY_VALUE: correctBirthChecksum,KEY_TITLE:"Correct Birth Check No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 15:
                if expirationDate != "" {
                    let expiryDate = date(toFormatedDate: expirationDate)
                    
                    if expiryDate != "" && expiryDate != nil{
                        
                        dict = [KEY_VALUE: expiryDate,KEY_TITLE:"Date of Expiry"] as [String : AnyObject]
                        arrDocumentData.append(dict)
                    }
                }
                break
            case 16:
                if(expirationDateChecksum != "") {
                    dict = [KEY_VALUE: expirationDateChecksum,KEY_TITLE:"Expiration Check No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 17:
                if(correctExpirationChecksum != "") {
                    dict = [KEY_VALUE: correctExpirationChecksum,KEY_TITLE:"Correct Expiration Check No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 18:
                if(personalNumber != "") {
                    dict = [KEY_VALUE: personalNumber,KEY_TITLE:"Other ID"] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 19:
                if(personalNumberChecksum != "") {
                    dict = [KEY_VALUE: personalNumberChecksum,KEY_TITLE:"Other ID Check No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 20:
                if personalNumber2 != ""{
                    dict = [KEY_VALUE: personalNumber2,KEY_TITLE:"Other ID 2"] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 21:
                if(secondRowChecksum != "") {
                    dict = [KEY_VALUE: secondRowChecksum,KEY_TITLE:"Second Row Check No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 22:
                if(correctSecondrowChecksum != "") {
                    dict = [KEY_VALUE: correctSecondrowChecksum,KEY_TITLE:"Correct Second Row Check No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 23:
                if issuedate != "" {
                    let issueDate = date(toFormatedDate: issuedate)
                    if issueDate != "" && issueDate != nil{
                        dict = [KEY_VALUE: issueDate,KEY_TITLE:"Issue Date"] as [String : AnyObject]
                        arrDocumentData.append(dict)
                    }
                }
                break
            case 24:
                if departmentNumber != ""{
                    dict = [KEY_VALUE: departmentNumber,KEY_TITLE:"Department No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 25:
                dict = [KEY_DOC1_IMAGE: !appDocumentImage.isEmpty ? appDocumentImage[0] : nil] as [String : AnyObject]
                arrDocumentData.append(dict)
                break
            case 26:
                dict = [KEY_DOC2_IMAGE: appDocumentImage.count == 2 ? appDocumentImage[1] : nil] as [String : AnyObject]
                arrDocumentData.append(dict)
                break
            default:
                break
            }
        }
    }
    
    func configureGradientBackground(arrcolors:[AnyObject],inLayer:CALayer){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = UIScreen.main.bounds
        gradient.colors = arrcolors
        gradient.startPoint =  CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        inLayer.addSublayer(gradient)
    }
    
    func convertImageToBase64(image: UIImage) -> String {
        let imageData = image.jpeg(.medium)
      return imageData!.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }

    
    
    
    //MARK:- Image Rotation
    @objc func loadPhotoCaptured() {
        let img = allImageViewsSubViews(picker.viewControllers.first?.view)?.last
        if img != nil {
            if let imgView: UIImageView = img as? UIImageView{
                imagePickerController(picker, didFinishPickingMediaWithInfo: convertToUIImagePickerControllerInfoKeyDictionary([convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage) : imgView.image!]))
            }
        } else {
            picker.dismiss(animated: true)
        }
    }
    
    /**
     * This method is used to get captured view
     * Param: UIView
     * Return: array of UIImageview
     */
    func allImageViewsSubViews(_ view: UIView?) -> [AnyHashable]? {
        var arrImageViews: [AnyHashable] = []
        if (view is UIImageView) {
            if let view = view {
                arrImageViews.append(view)
            }
        } else {
            for subview in view?.subviews ?? [] {
                if let all = allImageViewsSubViews(subview) {
                    arrImageViews.append(contentsOf: all)
                }
            }
        }
        return arrImageViews
    }
    
    /**
     * This method is used to compress image in particular size
     * Param: UIImage and covert size
     * Return: compress UIImage
     */
    func compressimage(with image: UIImage?, convertTo size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        image?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let destImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return destImage
    }
    
    //MARK: UIButton Method Action
    @IBAction func onCancelAction(_ sender: Any) {
//        if orientation ==  .landscapeLeft {
//            AppDelegate.AppUtility.lockOrientation(.landscapeLeft, andRotateTo: .landscapeLeft)
//        } else if orientation ==  .landscapeRight{
//            AppDelegate.AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
//        }
        if pageType == .ScanOCR{
            removeAllData()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- Other Method
    func removeAllData(){
        dictFaceData.removeAllObjects()
        dictSecurityData.removeAllObjects()
        dictFaceBackData.removeAllObjects()
        arrSecurity.removeAll()
        arrDataForntKey.removeAll()
        arrDataBackKey.removeAll()
        arrDataForntValue.removeAll()
        arrDataBackValue.removeAll()
        arrDataForntValue1.removeAll()
        arrDataBackValue1.removeAll()
        faceScoreData = ""
        stFace = nil
        imagePhoto = nil
        imgViewBack = nil
        imgViewFront = nil
        imgCamaraFace = nil
        faceImage = nil
    }
    
    //MARK: - UITableView Delegate and Datasource Method
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return  self.arrDocumentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let  dictResultData: [String:AnyObject] = arrDocumentData[indexPath.row]
            let index = indexPath.row
            // print(dictResultData)
            if dictResultData[KEY_FACE_IMAGE] != nil{
                //Set User Image
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserImgTableCell") as! UserImgTableCell
                cell.selectionStyle = .none
                if let imageFace: UIImage =  dictResultData[KEY_FACE_IMAGE]  as? UIImage{
                    cell.User_img2.isHidden = true
                    cell.view2.isHidden = true
//                    if (UIDevice.current.orientation == .landscapeRight) {
//                        cell.user_img.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
//                    } else if (UIDevice.current.orientation == .landscapeLeft) {
//                        cell.user_img.transform = CGAffineTransform(rotationAngle: CGFloat(-(Double.pi / 2)))
//                    }
                    cell.user_img.image = imageFace
                }
                if imgCamaraFace != nil{
                    cell.User_img2.isHidden = false
                    cell.view2.isHidden = false
                    cell.User_img2.image = imgCamaraFace
                   
                }
                return cell
            }else if dictResultData[KEY_TITLE] != nil || dictResultData[KEY_VALUE] != nil{
                //Set Document data
                let cell = tableView.dequeueReusableCell(withIdentifier: "ResultTableCell") as! ResultTableCell
                cell.selectionStyle = .none
                if dictResultData[KEY_TITLE] == nil && dictResultData[KEY_VALUE] != nil{
                    cell.lblValue.isHidden = false
                    cell.lblName.isHidden = false
                    //                cell.lblSinglevalue.isHidden = true
                    
                }else{
                    cell.lblValue.isHidden = false
                    cell.lblName.isHidden = false
                }
                if dictResultData[KEY_TITLE] == nil && dictResultData[KEY_VALUE] != nil{
                    //                cell.lblSinglevalue.text = dictResultData[KEY_VALUE] as? String ?? ""
                    cell.lblSide.text = "MRZ"
                    cell.constarintViewHaderHeight.constant = 60
                    cell.lblName.text = "MRZ"
                    cell.lblValue.text = dictResultData[KEY_VALUE] as? String ?? ""
                }else{
                    cell.constarintViewHaderHeight.constant = 0
                    cell.lblName.text = dictResultData[KEY_TITLE] as? String ?? ""
                    cell.lblValue.text = dictResultData[KEY_VALUE] as? String ?? ""
                }
                
                return cell
            }else{
                //Set Document Images
                let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentTableCell") as! DocumentTableCell
                cell.selectionStyle = .none
                cell.imgDocument.contentMode = .scaleAspectFit
                if dictResultData[KEY_DOC1_IMAGE] != nil {
                    if pageType == .ScanAadhar || pageType == .ScanPan{
                        cell.lblDocName.text = ""
                        cell.constraintLblHeight.constant = 0
                    }else{
//                        cell.lblDocName.text = "Front Side"
                        cell.constraintLblHeight.constant = 60
                    }
                    if let imageDoc1: UIImage =  dictResultData[KEY_DOC1_IMAGE]  as? UIImage{
                        cell.imgDocument.image = imageDoc1
                        cell.lblDocName.text = "Front Side"
//                        cell.constraintLblHeight.constant = 25
                    }
                }
                
                if dictResultData[KEY_DOC2_IMAGE] != nil {
                    if pageType == .ScanAadhar || pageType == .ScanPan{
                        cell.lblDocName.text = ""
                        cell.constraintLblHeight.constant = 0
                    }else{
                        cell.lblDocName.text = "Back Side"
                        
                        cell.constraintLblHeight.constant = 60
                    }
                    if let imageDoc2: UIImage =  dictResultData[KEY_DOC2_IMAGE]  as? UIImage{
//                        cell.lblDocName.text = "Back Side"
                        
//                        cell.constraintLblHeight.constant = 25
                        cell.imgDocument.image = imageDoc2
                    }
                }
                return cell
            }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            let  dictResultData: [String:AnyObject] = arrDocumentData[indexPath.row]
            if dictResultData[KEY_FACE_IMAGE] != nil{
                return UITableView.automaticDimension
            } else if dictResultData[KEY_TITLE] != nil && dictResultData[KEY_VALUE] != nil{
                return UITableView.automaticDimension
            }
            else if dictResultData[KEY_TITLE] != nil || dictResultData[KEY_VALUE] != nil{
                return UITableView.automaticDimension
            }
            else if dictResultData[KEY_DOC1_IMAGE] != nil {
                return 310.0
            }else if let _ = dictResultData[KEY_DOC2_IMAGE] as? UIImage{
                return 310.0
            } else {
                return 0.0
            }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: viewTable.frame.width, height: 0))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
            return headerView
    }
    
    func tableViewReslut(cell: ResultTableCell, objData: String, objTrueFalse: String){
        if let decodedData = Data(base64Encoded: objData, options: .ignoreUnknownCharacters) {
            let image = UIImage(data: decodedData)
            let attachment = NSTextAttachment()
            attachment.image = image
            let attachmentString = NSAttributedString(attachment: attachment)
            cell.lblName.attributedText = attachmentString
        }
        let attachment1 = NSTextAttachment()
        if objTrueFalse == "true"{
            attachment1.image = UIImage(named: "tick")
        }else{
            attachment1.image = UIImage(named: "close")
        }
        let attachmentString1 = NSAttributedString(attachment: attachment1)
        cell.lblValue.attributedText = attachmentString1
    }
    func setText(cell: ResultTableCell, name: String, color: UIColor){
        cell.lblName.font = UIFont(name: name, size: 14.0)
        cell.lblValue.font = UIFont(name: name, size: 14.0)
        
        cell.lblName.textColor = color
        cell.lblValue.textColor = color
    }

    
    //MARK:- UIImagePickerController Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
    }
    
     func resizeImage(image: UIImage, targetSize: CGRect) -> UIImage {
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        var newX = targetSize.origin.x - (targetSize.size.width * 0.4)
        var newY = targetSize.origin.y - (targetSize.size.height * 0.4)
        var newWidth = targetSize.size.width * 1.8
        var newHeight = targetSize.size.height * 1.8
        if newX < 0 {
            newX = 0
        }
        if newY < 0 {
            newY = 0
        }
        if newX + newWidth > image.size.width{
            newWidth = image.size.width - newX
        }
        if newY + newHeight > image.size.height{
            newHeight = image.size.height - newY
        }
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        let image1: UIImage = UIImage(cgImage: imageRef)
        return image1
    }
    
    //MARK:- Custom
    func date(toFormatedDate dateStr: String?) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMdd"
        let date: Date? = dateFormatter.date(from: dateStr ?? "")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if let date = date {
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    func date(to dateStr: String?) -> String? {
        // Convert string to date object
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyMMdd"
        let date: Date? = dateFormat.date(from: dateStr ?? "")
        dateFormat.dateFormat = "yy-MM-dd"
        if let date = date {
            return dateFormat.string(from: date)
        }
        return nil
    }
    
    func setFaceImage(){
        if(imagePhoto != nil)
        {
            faceImage = imagePhoto
        }
        else{
            faceImage = UIImage(named: "default_user")
        }
    }

   @objc func buttonClickedFaceMatch(sender:UIButton)
    {
    let orientastion = UIApplication.shared.statusBarOrientation
    if orientastion ==  UIInterfaceOrientation.landscapeLeft {
        orientation = .landscapeLeft
    } else if orientastion == UIInterfaceOrientation.landscapeRight {
        orientation = .landscapeRight
    } else {
        orientation = .portrait
    }
        AppDelegate.AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
//        picker.delegate = self
//        picker.allowsEditing = false
//        picker.sourceType = .camera
//        picker.cameraDevice = .front
//        picker.mediaTypes = ["public.image"]
//        self.present(picker, animated: true, completion: nil)
    }
    
   @objc func buttonClickedLiveness(sender:UIButton)
    {
    let orientastion = UIApplication.shared.statusBarOrientation
    if orientastion ==  UIInterfaceOrientation.landscapeLeft {
        orientation = .landscapeLeft
    } else if orientastion == UIInterfaceOrientation.landscapeRight {
        orientation = .landscapeRight
    } else {
        orientation = .portrait
    }
        AppDelegate.AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
 
    
        
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIImagePickerControllerInfoKeyDictionary(_ input: [String: Any]) -> [UIImagePickerController.InfoKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIImagePickerController.InfoKey(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

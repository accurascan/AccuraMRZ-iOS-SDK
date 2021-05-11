
import UIKit
//import SVProgressHUD
import AccuraMRZ
struct CountryName {
    let id : Int?
    var country_name : String?
    let id_card : Int?
    let passport : Int?
    let pdf_file : Int?
  
    init( id:Int, country_name:String, id_card:Int, passport:Int, pdf_file:Int) {
        self.id = id
        self.country_name = country_name
        self.id_card = id_card
        self.passport = passport
        self.pdf_file = pdf_file
    }
}


class CountryNameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //MARK:- Outlet
    @IBOutlet weak var tblViewCountryList: UITableView!
    
    @IBOutlet weak var viewNavigationBar: UIView!
    
    @IBOutlet weak var buttonOrtientation: UIButton!
    @IBOutlet weak var viewStatusBar: UIView!
    @IBOutlet weak var lablelDataNotFound: UILabel!
    
    
    //MARK:- Variable
    var searchTxt = ""
    var arrCountryList = NSMutableArray()
    var isMRZCell = false
    var isPDFCell = false
    var isBankCard = false
    var accuraCameraWrapper: AccuraCameraWrapper? = nil
    
    //MARK:- View Controller Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let orientastion = UIApplication.shared.statusBarOrientation
        if(orientastion ==  UIInterfaceOrientation.portrait) {
            buttonOrtientation.isSelected = false
        } else {
            buttonOrtientation.isSelected = true
        }

//        SVProgressHUD.show(withStatus: "Loading...")
        lablelDataNotFound.isHidden = true
        viewStatusBar.backgroundColor = UIColor(red: 231.0 / 255.0, green: 52.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
        viewNavigationBar.backgroundColor = UIColor(red: 231.0 / 255.0, green: 52.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
        accuraCameraWrapper = AccuraCameraWrapper.init()
        accuraCameraWrapper?.setDefaultDialogs(true)
        accuraCameraWrapper?.showLogFile(true) // Set true to print log from KYC SDK
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let sdkModel = self.accuraCameraWrapper?.loadEngine(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String)
            if(sdkModel != nil)
            {
                if(sdkModel!.isMRZEnable)
                {
                    self.isMRZCell = true
                }
                else{
                    self.isMRZCell = false
                }
                if(sdkModel!.isBankCardEnable) {
                    self.isBankCard = true
                } else {
                    self.isBankCard = false
                }
            }
            if(self.isMRZCell)
            {
                self.arrCountryList.add("Passport MRZ")
                self.arrCountryList.add("ID card MRZ")
                self.arrCountryList.add("VISA MRZ")
                self.arrCountryList.add("Other MRZ")
            }
            
             if(sdkModel != nil){
             if sdkModel!.i > 0{
                self.accuraCameraWrapper?.setFaceBlurPercentage(80)
                self.accuraCameraWrapper?.setHologramDetection(true)
                self.accuraCameraWrapper?.setLowLightTolerance(10)
                 self.accuraCameraWrapper?.setMotionThreshold(25)
                self.accuraCameraWrapper?.setGlarePercentage(6, intMax: 99)
                self.accuraCameraWrapper?.setBlurPercentage(60)
                self.accuraCameraWrapper?.setCameraFacing(.CAMERA_FACING_BACK)
//                self.accuraCameraWrapper?.setCheckPhotoCopy(false, stCheckPhotoMessage: "")
             }
            }
            
            self.tblViewCountryList.delegate = self
            self.tblViewCountryList.dataSource = self
            self.tblViewCountryList.reloadData()
//            SVProgressHUD.dismiss()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    

    
    //MARK:- Button Action
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonChangeOriwentation(_ sender: UIButton) {
        if(sender.isSelected == true) {
            sender.isSelected = false
            AppDelegate.AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        } else {
            sender.isSelected = true
            AppDelegate.AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
        }
        
    }
    
    
    //MARK:- TableView Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(arrCountryList.count == 0)
        {
            lablelDataNotFound.isHidden = false
        }
        else{
            lablelDataNotFound.isHidden = true
        }
        return arrCountryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CountryListCell = tableView.dequeueReusableCell(withIdentifier: "CountryListCell") as! CountryListCell
        cell.layer.cornerRadius = 8.0
        let cellDict = arrCountryList.object(at: indexPath.row)
        if let stringCell = cellDict as? String {
            cell.viewCountryName.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)
            cell.lblCountryName.text = stringCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellDict = arrCountryList.object(at: indexPath.row)
        if let stringCell = cellDict as? String {
            
                let vc: ViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                if(stringCell == "Passport MRZ") {
                    vc.MRZDocType = 1
                } else if(stringCell == "ID card MRZ") {
                    vc.MRZDocType = 2
                } else if(stringCell == "VISA MRZ") {
                    vc.MRZDocType = 3
                } else {
                    vc.MRZDocType = 0
                }
                vc.isCheckScanOCR = false
                self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MAARK: - Extension View
extension UIView {
    func setShadowToView() {
        self.layer.cornerRadius = 8.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 0.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3.0
        self.layer.shadowOffset = CGSize(width: 0, height: 5.0)
    }
}

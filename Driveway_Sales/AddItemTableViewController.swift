//
//  AddItemTableViewController.swift
//  Driveway_Sales
//
//  Created by Jingzhi Zhang on 4/8/17.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//
//  Purpose: add items to the year and season section

import UIKit
import CoreData

class AddItemTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    @IBOutlet weak var AddItemImageView: UIImageView!
    @IBOutlet weak var addItemName: UITextField!
    @IBOutlet weak var addItemDesc: UITextView!
    @IBOutlet weak var addItemCond: UITextField!
    @IBOutlet weak var addItemQty: UITextField!
    @IBOutlet weak var addSuggPrice: UITextField!
    @IBOutlet weak var AddCaption: UILabel!
    @IBAction func unwindToAddNewItem(_ sender: UIStoryboardSegue) {
        if sender.source is ScannerViewController{
            if let senderVC = sender.source as? ScannerViewController {
                barcodeString = senderVC.messageLabel.text
                print(barcodeString)
            }
        }
    }
    
    @IBAction func unwindToAddNewItemFromGen(_ sender: UIStoryboardSegue) {
        if sender.source is GenerateViewController{
            if let senderVC = sender.source as? GenerateViewController {
                barcodeString = senderVC.itemName
                print(barcodeString)
            }
        }
    }
    
    // variable of choosing year and season to show the items under this section
    var keyYear:NSNumber?
    var keySeason:String?
    //####
    var barcodeString: String!
    
    // Mark: UITextField delegate methods
    // This function dismisses the keyboard
    
    //managedObjectContext
    var manageObjectContext: NSManagedObjectContext?{
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //show save bar
        setSaveBarButton()
      
        //dismiss the keyboard
        self.hideKeyboardWhenTappedAround()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setSaveBarButton(){
        let saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target:self, action:#selector(AddItemTableViewController.saveItem))
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    @IBAction func addNewItemImage(_ sender: UITapGestureRecognizer) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        let alertController = UIAlertController(title: "Add a Picture", message:"Choose From", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title:"Camera", style: .default){(action) in pickerController.sourceType = .camera
        
        self.present(pickerController, animated: true, completion:nil)
            
        }
        let photosLibraryAction = UIAlertAction(title: "Photos Library", style: .default){(action) in pickerController.sourceType = .photoLibrary
            self.present(pickerController,animated: true, completion:nil)
        }
        let savedPhotosAction = UIAlertAction(title: "Saved Photos Album", style: .default){(action) in pickerController.sourceType = .savedPhotosAlbum
            self.present(pickerController,animated: true, completion:nil)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photosLibraryAction)
        alertController.addAction(savedPhotosAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.AddItemImageView.image = image
            AddCaption.isHidden = true
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func saveItem(){
        if addItemName.text!.isEmpty || addItemQty.text!.isEmpty || addItemCond.text!.isEmpty || addSuggPrice.text!.isEmpty || barcodeString == nil || AddItemImageView.image == nil {
            let alertController = UIAlertController(title: "OOPS", message: "You need to enter all the required information to save this item.", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }else{
            
            //Here we save
            if let moc = manageObjectContext {
                let sellingItem = SellingItemMO(context: moc)
              
                sellingItem.itemDesc = addItemDesc.text!
                sellingItem.itemCondition = addItemCond.text!
                sellingItem.itemQuantity = Int16(addItemQty.text!)!
                sellingItem.suggestPrice = Float(addSuggPrice.text!)!
                sellingItem.itemName = addItemName.text!
                // shouble be
                sellingItem.year = keyYear as! Int16
                sellingItem.season = keySeason
                sellingItem.barcode = barcodeString
                //add barcode string to core data
                
                
                if let data = UIImageJPEGRepresentation(self.AddItemImageView.image!, 1.0){
                    sellingItem.itemImage = data as NSData
                }
                
                saveToCoreData(){
                    self.navigationController!.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    func saveToCoreData(completion: @escaping ()->Void){
        manageObjectContext!.perform {
            do{
                try self.manageObjectContext?.save()
                completion()
                print("Item saved.")
            }catch let error {
                print("Could not save this item to CoreData: \(error.localizedDescription)")
            }
        }

        }
    
    //#### Add barcode
    @IBAction func addBarcode(sender: UIButton) {
        if (addItemName.text?.isEmpty)! {
            let tipAlert = UIAlertController(title: "Tips", message: "please input item name first!", preferredStyle: .alert)
            tipAlert.addAction(UIAlertAction(title: "Continue", style: .default){ (action) -> Void in
            })
            present(tipAlert, animated: true, completion: nil)
            print("please input item name first!")
        } else{
            let alert = UIAlertController(title: "Add Barcode", message: "Please choose the method you like", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Scan existing barcode", style: .default){ (action) -> Void in
                let ScannerViewController = self.storyboard?.instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController
                
                ScannerViewController.ItemNameString = self.addItemName.text!
                /*
                ScannerViewController.clickValueClosure {(text) in
                    if text != nil{
                        self.addItemName.text = text!
                    }
                }
 */
                ScannerViewController.postValueBlock = { (str) in
                    self.addItemName.text = str
                }
                
                self.navigationController!.pushViewController(ScannerViewController, animated: true)
            })

            alert.addAction(UIAlertAction(title: "generate new barcode", style: .default){ (action) -> Void in

                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let GenerateViewController = storyboard.instantiateViewController(withIdentifier: "GenerateViewController") as! GenerateViewController

                GenerateViewController.itemName = self.addItemName.text!

                //self.barcodeString
                GenerateViewController.postValueBlock = { (str) in
                    self.addItemName.text = str
                }
                self.navigationController!.pushViewController(GenerateViewController, animated: true)


            })

            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            alert.addAction(cancelAction)

            present(alert, animated: true, completion: nil)

        }



    }
    
    
    
    
    
    
    

    
    }

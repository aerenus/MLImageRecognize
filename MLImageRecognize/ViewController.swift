//
//  ViewController.swift
//  MLImageRecognize
//
//  Created by Eren FAIKOGLU on 27.07.2020.
//  Copyright © 2020 Eren FAIKOGLU. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var result: UILabel!
    var chosenImg = CIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func chooseImg(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        if let chosenImg = CIImage(image: image.image!) {
            recImg(image: chosenImg)
        }
    }
    
    func recImg(image: CIImage){
        result.text = "Please wait..."
        if let model = try? VNCoreMLModel(for: MobileNetV2().model){
            let request = VNCoreMLRequest(model: model) { (VNReq, Error) in
                if let results = VNReq.results as? [VNClassificationObservation]{
                    if results.count > 0 {
                        let topResult = results.first
                        DispatchQueue.main.async {
                            //let level = Int()*100
                            let confidenceLevel = (topResult?.confidence ?? 0) * 100
                            let rounded = Int (confidenceLevel * 100) / 100
                            self.result.text = "\(rounded) %, it's \(topResult?.identifier ?? "Err")"
                        
                    }
                }
            }
                
              

    
}
            let handler = VNImageRequestHandler(ciImage: image)
                          DispatchQueue.global(qos: .userInteractive).async {
                            do { try handler.perform([request])} catch {print("err.")}
                          }
                }

                
            }
}

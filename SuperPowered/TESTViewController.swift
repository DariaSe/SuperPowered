//
//  TESTViewController.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 15/10/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class TESTViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let baseView = UIView()
    let imageView = UIImageView()
    let button = UIButton()
    var image: UIImage?
    
    var color: UIColor = UIColor.goalColor(index: 3)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        view.addSubview(baseView)
        baseView.center(in: view)
        baseView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        baseView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        baseView.backgroundColor = color
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        image = #imageLiteral(resourceName: "Achievements")
        image = image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.textColor
        imageView.image = image
        
        view.addSubview(button)
        button.constrainToEdges(of: view, leading: 100, trailing: 100, top: 50, bottom: nil)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.setTitle("Choose image", for: .normal)
        button.setTitleColor(.textColor, for: .normal)
        button.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        
    }
    
    @objc func pickImage() {

        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let alertController = UIAlertController(title: "Выберите источник", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Камера", style: .default, handler: { action in
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil) })
            alertController.addAction(cameraAction) }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Медиатека", style: .default, handler: { action in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true,completion: nil) })
            alertController.addAction(photoLibraryAction) }
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                image = selectedImage.grayScaled
//                image = image?.withRenderingMode(.alwaysTemplate)
//                imageView.tintColor = UIColor.textColor
                imageView.image = image
           
    //            let imageEncoder = NSCoder()
    //            if let encodedImage = try? imageEncoder.encode(selectedImage) {
                
    //            }
                dismiss(animated: true, completion: nil)
            }
        }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func convertToGrayScale(image: UIImage) -> UIImage {

        // Create image rectangle with current image width/height
        let imageRect:CGRect = CGRect(x:0, y:0, width: image.size.width, height: image.size.height)

        // Grayscale color space
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width = image.size.width
        let height = image.size.height

        // Create bitmap content with current image size and grayscale colorspace
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)

        // Draw image into current context, with specified rectangle
        // using previously defined context (with grayscale colorspace)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        context?.draw(image.cgImage!, in: imageRect)
        let imageRef = context!.makeImage()

        // Create a new UIImage object
        let newImage = UIImage(cgImage: imageRef!)

        return newImage
    }
}

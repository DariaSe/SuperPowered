//
//  ColorPickerViewController.swift
//  Triggio
//
//  Created by Дарья Селезнёва on 15/09/2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

protocol ColorPickerDelegate {
    func colorPicked(at index: Int)
}

class ColorPickerViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var selectColorLabel: UILabel!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    var delegate: ColorPickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.cornerRadius = 10
        containerView.backgroundColor = UIColor.backgroundColor
        colorCollectionView.backgroundColor = UIColor.backgroundColor
        selectColorLabel.textColor = UIColor.textColor
        selectColorLabel.font = UIFont(name: montserratMedium, size: 20)
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        colorCollectionView.register(UINib(nibName: "ColorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "colorCell")
        let dismissRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissRecognizerTapped))
        dismissRecognizer.delegate = self
        self.view.addGestureRecognizer(dismissRecognizer)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissRecognizerTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
    
    
}

extension ColorPickerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colorCollectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorCollectionViewCell
        cell.colorView.backgroundColor = goalColors[indexPath.row]
        return cell
    }
    
    
}

extension ColorPickerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.colorPicked(at: indexPath.row)
        self.dismiss(animated: true, completion: nil)
    }
}

extension ColorPickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: colorCollectionView.frame.width / 5 - 1, height: colorCollectionView.frame.height / 4 - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

//
//  StatisticsCollectionViewContainer.swift
//  Trigo
//
//  Created by Дарья Селезнёва on 17.11.2019.
//  Copyright © 2019 dariaS. All rights reserved.
//

import UIKit

class StatisticsCollectionViewContainer: UIView {
    
    var statisticsItems: [StatisticsItem] = []

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    func commonInit() {
        Bundle.main.loadNibNamed("StatisticsCollectionViewContainer", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "StatisticsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "statisticsCell")
        collectionView.backgroundColor = .clear
        configureAppearance()
    }
    
    func configureAppearance() {
        contentView.backgroundColor = UIColor.backgroundColor
//        self.dropShadow(shadowRadius: 6, opacity: 0.25, cornerRadius: 10)
        collectionView.reloadData()
    }
}

extension StatisticsCollectionViewContainer: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statisticsItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "statisticsCell", for: indexPath) as! StatisticsCollectionViewCell
        cell.numberLabel.text = statisticsItems[indexPath.row].numberText
        cell.textLabel.text = statisticsItems[indexPath.row].text
        cell.configureAppearance()
        return cell
    }
}

extension StatisticsCollectionViewContainer: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension StatisticsCollectionViewContainer: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfRows = (statisticsItems.count / 3).cgFloat
        return CGSize(width: collectionView.frame.width / 3 - 6, height: (collectionView.frame.height / numberOfRows) - 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}

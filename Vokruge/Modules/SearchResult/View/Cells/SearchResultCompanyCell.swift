//
//  SearchResultCompanyCell.swift
//  Vokruge
//
//  Created by Дмитрий Яровой on 24.11.2019.
//  Copyright © 2019 Vokruge. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

class SearchResultCompanyCell: UITableViewCell, NibReusable {
    
    @IBOutlet private weak var nameCompanyLabel: UILabel! {
        didSet {
            nameCompanyLabel.font = R.font.sfProTextMedium(size: 16)
            nameCompanyLabel.textColor = .companyNameCellTextColor
            nameCompanyLabel.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(goToCompanyDetails))
            nameCompanyLabel.addGestureRecognizer(tap)
        }
    }
    @IBOutlet private weak var typeCompanyLabel: UILabel! {
        didSet {
            typeCompanyLabel.font = R.font.sfProTextRegular(size: 12)
            typeCompanyLabel.textColor = .companyTypeCellTextColor
        }
    }
    @IBOutlet private weak var addressCompanyLabel: UILabel! {
        didSet {
            addressCompanyLabel.font = R.font.sfProTextRegular(size: 12)
            addressCompanyLabel.textColor = .companyAddressCellTextColor
            addressCompanyLabel.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(selectedAddress))
            addressCompanyLabel.addGestureRecognizer(tap)
        }
    }
    @IBOutlet private weak var distLabel: UILabel! {
        didSet {
            distLabel.font = R.font.sfProTextRegular(size: 12)
            distLabel.textColor = .distanceCellTextColor
        }
    }
    
    private var addressTap = PublishRelay<GeoLocation>()
    private var nameCompanyTap = PublishRelay<Company>()
    private var company: Company!
    
    
    func configurationCell(company: Company,
                           distance: String,
                           categoriesName: String,
                           addressTap: PublishRelay<GeoLocation>,
                           nameCompanyTap: PublishRelay<Company>) {
        self.addressTap = addressTap
        self.nameCompanyTap = nameCompanyTap
        self.company = company
        nameCompanyLabel.text = company.caption
        typeCompanyLabel.text = categoriesName
        addressCompanyLabel.text = company.coordinates.first?.normalAddress
        distLabel.text = distance
    }
    
    @objc private func selectedAddress() {
        
        guard let lat = company.coordinates.first?.latitude,
              let long = company.coordinates.first?.longitude else { return }
        let location = GeoLocation(latitude: lat, longitude: long)
        
        addressTap.accept(location)
    }
    
    @objc private func goToCompanyDetails() {
        nameCompanyTap.accept(company)
    }
    
}

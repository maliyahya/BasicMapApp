//
//  PlaceDetailViewController.swift
//  MapApp
//
//  Created by Muhammet Ali Yahyaoğlu on 26.01.2024.
//

import UIKit

class PlaceDetailViewController: UIViewController {
    
    private let place:PlaceAnnotation
    
    init(place: PlaceAnnotation) {
        self.place = place
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let infosStackView:UIStackView={
       let stack=UIStackView()
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints=false
        stack.axis = .vertical
        stack.spacing = UIStackView.spacingUseSystem
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        return stack
    }()
    private let actionStackView:UIStackView={
       let stack=UIStackView()
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints=false
        stack.axis = .horizontal
        stack.spacing = UIStackView.spacingUseSystem
        return stack
    }()
    private lazy var nameLabel:UILabel={
       let label=UILabel()
        label.numberOfLines=0
        label.text=place.name
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    private lazy var addressLabel:UILabel={
        let label=UILabel()
         label.text=place.address
         label.translatesAutoresizingMaskIntoConstraints = false
         label.textAlignment = .left
         label.font = UIFont.preferredFont(forTextStyle: .body)
        label.alpha = 0.4
         return label
     }()
    private  var directionButton:UIButton={
        let button=UIButton()
        button.backgroundColor = .secondarySystemBackground
        button.setTitleColor(UIColor.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints=false
        button.setTitle("Directions", for: .normal)
       return button
    }()
    private  var callButton:UIButton={
        let button=UIButton()
        button.backgroundColor = .secondarySystemBackground
        button.setTitleColor(UIColor.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints=false
        button.setTitle("Call", for: .normal)
       return button
    }()
    
    @objc private func didTapCallButton(){
        guard  let url=URL(string: "tell://\(place.phone.formatPhoneForCall)") else { return }
        print(url)

        UIApplication.shared.open(url)
    }
    @objc private func didTapDirectionButton(){
        let cordinate=place.location.coordinate
        guard let url = URL(string: "http://maps.apple.com/?daddr=\(cordinate.latitude),\(cordinate.longitude)") else { return }
        UIApplication.shared.open(url)
    }
    
 

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        configureConstraints()

    }
    private func setupUI(){
        view.addSubview(infosStackView)
        view.addSubview(actionStackView)
        infosStackView.addArrangedSubview(nameLabel)
        infosStackView.addArrangedSubview(addressLabel)
        infosStackView.addArrangedSubview(actionStackView)
        actionStackView.addArrangedSubview(directionButton)
        actionStackView.addArrangedSubview(callButton)
        directionButton.addTarget(self, action: #selector(didTapDirectionButton), for: .touchUpInside)
        callButton.addTarget(self, action: #selector(didTapCallButton), for: .touchUpInside)
        
    }
    private func configureConstraints(){
        NSLayoutConstraint.activate([
            nameLabel.widthAnchor.constraint(equalToConstant: view.bounds.width-20),
            callButton.widthAnchor.constraint(equalToConstant: 90),
            directionButton.widthAnchor.constraint(equalToConstant: 90),
        ])
        
    }
    
}

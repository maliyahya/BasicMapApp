//
//  ViewController.swift
//  MapApp
//
//  Created by Muhammet Ali Yahyaoğlu on 25.01.2024.
//

import UIKit
import MapKit


class ViewController: UIViewController {
    private var places:[PlaceAnnotation]=[]
    
    let mapView:MKMapView={
       var mapView=MKMapView()
        mapView.showsUserLocation=true
        mapView.isZoomEnabled=true
        mapView.translatesAutoresizingMaskIntoConstraints=false
        return mapView
    }()
    let searchTextField:UITextField={
       let search=UITextField()
        search.autocorrectionType = .no
        search.translatesAutoresizingMaskIntoConstraints=false
        search.placeholder="Search"
        search.clipsToBounds=true
        search.backgroundColor = .secondarySystemBackground
        search.layer.cornerRadius=10
        search.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        search.leftViewMode = .always
        search.returnKeyType = .go
        return search
    }()
    var locationManager:CLLocationManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        locationManager=CLLocationManager()
        locationManager?.delegate=self
        searchTextField.delegate=self
        mapView.delegate=self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestLocation()
        setupUI()
        configureConstraints()
    }
    private func setupUI(){
        view.addSubview(mapView)
        view.addSubview(searchTextField)
    }
    private func findNearByPlaces(by query:String){
        mapView.removeAnnotations(mapView.annotations)
        let request=MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = mapView.region
        let search=MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let response = response , error == nil else { return}
            
            self?.places =  response.mapItems.map(PlaceAnnotation.init)
            self?.places.forEach { place in
                self?.mapView.addAnnotation(place)
                
            }
            if let places=self?.places{
                self!.presentPlacesList(places: places )
            }
        }
    }
    private func presentPlacesList(places:[PlaceAnnotation]){
        
        guard let locationManager=locationManager,
              let userLocation=locationManager.location
        else { return }
        
        let page=PlacesTableViewController(userLocation: userLocation, places: places)
        page.modalPresentationStyle = .pageSheet
        if let sheet = page.sheetPresentationController{
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(),.large()]
            present(page,animated: true)
        }
    }

    private func checkLocationAuthorization(){
        guard let locationManager=locationManager,
              let location=locationManager.location else { return }
        switch locationManager.authorizationStatus{
            
        case .notDetermined:
            print("failed")
        case .restricted:
            print("failed")
        case .denied:
            print("failed")
        case .authorizedAlways:
            let location=MKCoordinateRegion(center: location.coordinate, latitudinalMeters:750,longitudinalMeters: 750)
            mapView.setRegion(location, animated: true)
        case .authorizedWhenInUse:
            let location=MKCoordinateRegion(center: location.coordinate, latitudinalMeters:750,longitudinalMeters: 750)
            mapView.setRegion(location, animated: true)
        @unknown default:
            print("failed")
        }
        
    }
    private func configureConstraints(){
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20),
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 44)

        ])
        
    }


}
extension ViewController:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
}

extension ViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text=textField.text ?? ""
        if !text.isEmpty{
            textField.resignFirstResponder()
            findNearByPlaces(by: text)
        }
        return true
    }
    
}

extension ViewController:MKMapViewDelegate{
    private func clearAllSelections(){
        self.places = self.places.map({ place in
            place.isSelected = false
            return place
        })
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        clearAllSelections()
        guard let selectionAnnotation = annotation as? PlaceAnnotation else { return }
        let placesAnnotation = self.places.first(where: {$0.id==selectionAnnotation.id})
        placesAnnotation?.isSelected=true
        
        presentPlacesList(places: self.places)
    }
    
}

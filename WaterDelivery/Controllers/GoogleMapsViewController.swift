//Import necessary libraries: Google Maps, Kingfisher and Core Location.
import UIKit
import GoogleMaps
import Kingfisher

//Create a class called GoogleMapsViewController that subclasses UIViewController, and implements CLLocationManagerDelegate, GMSMapViewDelegate protocols.
class GoogleMapsViewController: BaseViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    //Add IBOutlets for the view that displays information about the markers, and its image, name, and address labels.
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var infoViewImage: UIImageView!
    @IBOutlet weak var infoViewNameLabel: UILabel!
    @IBOutlet weak var infoViewAddressLabel: UILabel!
    
    //Create a property called sellPointsManager of type SellPointsManager.
    let sellPointsManager = SellPointsManager()
    //Create another property called manager of type CLLocationManager for handling location updates.
    let manager = CLLocationManager()
    var mapView: GMSMapView?

    //Override viewDidLoad method, set the delegate of manager to self and request location authorization.
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    //Create a custom method loadData that fetches the sell points using the sellPointsManager object and creates markers for each of them.
    func loadData() {
        sellPointsManager.getSellPoints {
            self.sellPointsManager.models.forEach { sellPoint in
                self.createMarker(model: sellPoint)
            }
        }
    }
    
    //Implement locationManager(_:didUpdateLocations:) method. Set the camera position on a Google Maps view with a specified latitude, longitude, and zoom level. Set the delegate for the Google Maps view to self. Add the Google Maps view as a subview to the current view. Bring the infoView to the front of the view hierarchy. Call the loadData() method.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let camera = GMSCameraPosition.camera(withLatitude: 47.385494 , longitude: 8.493396, zoom: 8.0)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView?.delegate = self
        guard let mapView = mapView else { return }
        self.view.addSubview(mapView)
        self.view.bringSubviewToFront(infoView)
        loadData()
    }
    
    //Create a custom method createMarker(model:) that takes a SellPoint model and creates a marker with its latitude and longitude. Assign the marker to the mapView.
    func createMarker(model: SellPoint) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: model.geopoint.latitude, longitude: model.geopoint.longitude)
        marker.map = mapView
    }
    
    //Implement the mapView(_:didTap:) method to show the info view when a marker is tapped.
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        showInfoViewWith(marker: marker)
        return false
    }
    
    //  Create a custom method showInfoViewWith(marker:) that takes a GMSMarker and sets its image, name, and address to the info view's image, name, and address labels respectively. Use the Kingfisher library to set the image in the info view using the URL of the image in the sell point model. Use the MapManager class to get the address from the latitude and longitude of the sell point, and set it to the address label in the info view. Show the info view.
    func showInfoViewWith(marker: GMSMarker) {
        guard let sellPoint = sellPointsManager.getModel(by: .init(latitude: marker.position.latitude, longitude: marker.position.longitude)) else { return }
        guard let source = URL.init(string: sellPoint.imageURL) else { return}
        infoViewImage.kf.setImage(with: source)
        infoViewNameLabel.text = sellPoint.addressName
        MapManager.getAddressFromLatLon(pdblLatitude: "\(sellPoint.geopoint.latitude)", withLongitude: "\(sellPoint.geopoint.longitude)") { address in
            self.infoViewAddressLabel.text = address
            self.infoView.isHidden = false
        }
    }
    
    //Implement the mapView(_:willMove:) method to hide the info view when the map is moved.
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        infoView.isHidden = true
    }
}

//
//  AppDelegate.swift
//  EAO
//
//  Created by Work on 2017-03-03.
//  Copyright © 2017 FreshWorks. All rights reserved.
//
import Fabric
import Crashlytics
import Parse
import Photos

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	@objc var shouldRotate = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent
		if ProcessInfo.processInfo.arguments.contains("UITests") {
			UIView.setAnimationsEnabled(false)
			window?.layer.speed = 500
		}
        
		Fabric.with([Crashlytics.self])

        if let path = Bundle.main.path(forResource: "Parse", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) as? [String: String],
            let appId: String = dict["ParseAppId"], let clientKey: String = dict["ParseClientKey"], let server: String = dict["ParseServer"]
        {
            let configuration = ParseClientConfiguration {
                $0.applicationId = appId
                $0.clientKey     = clientKey
                $0.server        = server
                $0.isLocalDatastoreEnabled = true
            }
            Parse.initialize(with: configuration)
        } 

		UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.blue
		UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])

        //Camera
        AVCaptureDevice.requestAccess(for: AVMediaType.video) {response in}

        //Photos
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {PHPhotoLibrary.requestAuthorization({status in})}
        return true
    }

	func application(_ application: UIApplication,supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
		return shouldRotate ? .allButUpsideDown : .portrait
	}
}

extension AppDelegate{
	@objc static var reference: AppDelegate?{
		return UIApplication.shared.delegate as? AppDelegate
	}
	@objc static var root: UIViewController?{
		return AppDelegate.reference?.window?.rootViewController
	}
}

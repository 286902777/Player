//
//  HPUMPManager.swift
//  HPlayer
//
//  Created by HF on 2024/3/18.
//
//

import Foundation
//import GoogleMobileAds
//import UserMessagingPlatform

class HPUMPManager: NSObject {
    static let shared = HPUMPManager()
    
//    var canRequestAds: Bool {
//        return UMPConsentInformation.sharedInstance.canRequestAds
//    }
//    
//    var isPrivacyOptionsRequired: Bool {
//        return UMPConsentInformation.sharedInstance.privacyOptionsRequirementStatus == .required
//    }
//    
//    /// Helper method to call the UMP SDK methods to request consent information and load/present a
//    /// consent form if necessary.
//    func gatherConsent(
//        from consentFormPresentationviewController: UIViewController,
//        consentGatheringComplete: @escaping (Error?) -> Void
//    ) {
//        let parameters = UMPRequestParameters()
//        
//        //For testing purposes, you can force a UMPDebugGeography of EEA or not EEA.
//#if DEBUG
//        let debugSettings = UMPDebugSettings()
////        debugSettings.testDeviceIdentifiers = ["951D6AFC-673E-44D1-9CA0-BE3DB00E50E4"]
//        
//        debugSettings.geography = UMPDebugGeography.EEA
//        
//        parameters.debugSettings = debugSettings
//#endif
//        // Requesting an update to consent information should be called on every app launch.
//        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: parameters) {
//            requestConsentError in
//            guard requestConsentError == nil else {
//                return consentGatheringComplete(requestConsentError)
//            }
//            
//            UMPConsentForm.loadAndPresentIfRequired(from: consentFormPresentationviewController) {
//                loadAndPresentError in
//                // Consent has been gathered.
//                consentGatheringComplete(loadAndPresentError)
//            }
//        }
//    }
//    
//    /// Helper method to call the UMP SDK method to present the privacy options form.
//    func getPrivacyOptionsForm(
//        from vc: UIViewController, completionHandler: @escaping (Error?) -> Void
//    ) {
//        UMPConsentForm.presentPrivacyOptionsForm(
//            from: vc, completionHandler: completionHandler)
//    }
}

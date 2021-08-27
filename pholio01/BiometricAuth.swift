//
// BiometricAuth
// JournalApp
//
// Created by DevTechie Interactive on 2/2/19.
// Copyright © 2019 Devtechie. All rights reserved.
//

import Foundation
import LocalAuthentication

class BiometricAuth {
    let context = LAContext()
    var loginReason = "Logging in with "
    
    enum BiometricType {
        case none
        case touchID
        case FaceID
    }
    
    func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    func biometricType() -> BiometricType {
        let _ = context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil)
        
        switch context.biometryType {
        case .none:
            return .none
        case .touchID:
            loginReason = loginReason + "TouchID."
            return .touchID
        case .faceID:
            loginReason = loginReason + "FaceID."
            return .FaceID
        @unknown default:
            fatalError()
        }
    }
    
    func authenticateUser(completion: @escaping (String?) -> Void) {
        guard canEvaluatePolicy() else {
            completion("Biometric auth not available.")
            return
        }
        
        context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: loginReason) { (success, error) in
            if success {
                DispatchQueue.main.async {
                    completion(nil)
                }
            } else {
                let message: String
                
                switch error {
                case LAError.authenticationFailed?:
                    message = "Identity not verified."
                case LAError.userCancel?:
                    message = "User cancelled."
                case LAError.userFallback?:
                    message = "User choose to use passcode."
                case LAError.biometryNotAvailable?:
                    message = "FaceID/TouchID is not available on device."
                case LAError.biometryNotEnrolled?:
                    message = "FaceID/TouchID is not enrolled on device."
                case LAError.biometryLockout?:
                    message = "FaceID/TouchID is locked out on device."
                default:
                    message = "FaceID/TouchID may not be configured."
                }
                completion(message)
            }
        }
    }
}

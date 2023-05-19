import UIKit
import AuthenticationServices
import FBSDKLoginKit
import GoogleSignIn

class SocialPlatformAuthorizationUtil {

    fileprivate static var loginManager = LoginManager()
    fileprivate static var googleClientID = "99838163458-ufemgib9nb4dcvnto8jqi6sbv1o6angs.apps.googleusercontent.com"
    fileprivate static var appStoreAppID = "1534079797"

    static func appleAuthorization(_ currentVC: UIViewController,
                                   _ delegate: ASAuthorizationControllerDelegate,
                                   _ presentController: ASAuthorizationControllerPresentationContextProviding) {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = delegate
            authorizationController.presentationContextProvider = presentController
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
            Toast.show(message: "For Apple login minimum 13.0 iOS version required", controller: currentVC)
        }
    }

    static func googleAuthorization(_ currentVC: UIViewController) {
        let signInConfig = GIDConfiguration.init(clientID: googleClientID)
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: currentVC) { user, error in
            guard error == nil else { return }
            guard let user = user, let userID = user.userID, let email = user.profile?.email else { return }
            let userData = AuthorizationRequestModel.init(email: email, socialUserId: userID)
            socialPlatformAuthorizationAPI(userData, currentVC)
        }
    }

    static func facebookAuthorization(_ currentVC: UIViewController) {
        if AccessToken.current == nil {
            loginManager.logIn(permissions: ["public_profile", "email"], from: currentVC) { (result, error) in
                if let resultInfo = result {
                    if resultInfo.isCancelled {

                    } else {
                        if error == nil {
                            self.getFBUserData(currentVC)
                        } else {
                            Toast.show(message: error?.localizedDescription ?? "", controller: currentVC)
                        }
                    }
                }
            }
        } else {
            loginManager.logOut()
        }
    }

    fileprivate static func getFBUserData(_ currentVC: UIViewController) {
        let params = ["fields": "id, name, first_name, last_name, picture.type(large), email "]
        let graphRequest = GraphRequest.init(graphPath: "/me", parameters: params)
        let connection = GraphRequestConnection()
        connection.add(graphRequest) { ( _, result, _ ) in
            if let resultInfo = result {
                let info = resultInfo as? NSDictionary
                let email = info?["email"] as? String
                let id = info?["id"] as? String
                var fullName = String()
                if let firstname = info?["first_name"] as? String {
                    if let lastname = info?["last_name"] as? String {
                        fullName = firstname + " " + lastname
                        debugPrint("fullName is: ", fullName)
                    }
                }
                // TODOs: Perform api operation
                let userData = AuthorizationRequestModel.init(email: email, socialUserId: id)
                socialPlatformAuthorizationAPI(userData, currentVC)
            }
        }
        connection.start()
    }

    static func socialPlatformAuthorizationAPI(_ userData: AuthorizationRequestModel, _ currentVC: UIViewController) {
        // TODOs: under construction 😊
    }
}

extension UIViewController: ASAuthorizationControllerDelegate {
    @available(iOS 13.0, *)
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        /*  let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
         self.present(alert, animated: true, completion: nil)*/
    }

    @available(iOS 13.0, *)
    public func authorizationController(controller: ASAuthorizationController,
                                        didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Create an account in your system.
            // store details in the keychain.
            KeychainItem.savedEmail = appleIDCredential.email
            if let identityTokenData = appleIDCredential.identityToken,
               let identityToken = String(data: identityTokenData, encoding: .utf8) {
                // TODOs: Perform api operation
                debugPrint("identityToken is: ", identityToken)
                let userData = AuthorizationRequestModel.init(email: appleIDCredential.email,
                                                              socialUserId: appleIDCredential.user)
                SocialPlatformAuthorizationUtil.socialPlatformAuthorizationAPI(userData, self)
            }
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
                let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
                let alertController = UIAlertController(title: "Keychain Credential Received",
                                                        message: message,
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

extension UIViewController: ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

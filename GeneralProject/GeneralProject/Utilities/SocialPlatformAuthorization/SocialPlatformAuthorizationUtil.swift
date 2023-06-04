import UIKit
import AuthenticationServices
import FBSDKLoginKit
import GoogleSignIn
import Swifter
import SafariServices

extension UIViewController {

    func appleAuthorization() {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
            Toast.show(message: "For Apple login minimum 13.0 iOS version required", controller: self)
        }
    }

    func googleAuthorization() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            guard error == nil else { return }
            guard let result else { return }
            if let userProfileData = result.user.profile, let socialId = result.user.userID {
                let name: String = userProfileData.name
                let email: String = userProfileData.email
                LogHandler.shared.reportLogOnConsole(nil, "name is: \(name) and email is: \(email) and socialId is: \(socialId)")
                // TODOs: Perform api operation
            }
        }
    }

    func twitterAuthorization() {
        let swifter = Swifter(consumerKey: AppConfiguration.shared.twitterConsumerKey,
                              consumerSecret: AppConfiguration.shared.twitterConsumerSecretKey)

        guard let callBackURL = URL(string: AppConfiguration.shared.twitterCallbackUrl) else {
            LogHandler.shared.reportLogOnConsole(nil, "Invalid twitter callBack URL.")
            return
        }

        swifter.authorize(withCallback: callBackURL, presentingFrom: self, success: { accessToken, _ in
            self.getTwitterUserData(swifter, accessToken)
        }, failure: { _ in
            print("ERROR: Trying to authorize")
        })
    }

    func facebookAuthorization() {
        if AccessToken.current == nil {
            AppConfiguration.shared.loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
                if let resultInfo = result {
                    if resultInfo.isCancelled {

                    } else {
                        if error == nil {
                            self.getFBUserData(self)
                        } else {
                            Toast.show(message: error?.localizedDescription ?? "", controller: self)
                        }
                    }
                }
            }
        } else {
            AppConfiguration.shared.loginManager.logOut()
        }
    }

    fileprivate func getTwitterUserData(_ swifter: Swifter, _ accToken: Credential.OAuthAccessToken?) {

        swifter.verifyAccountCredentials(includeEntities: false, skipStatus: false, includeEmail: true, success: { json in
            var twitterUserId = ""
            var twitterUserHandle = ""
            var twitterUserName = ""
            var twitterUserEmail = ""
            var twitterUserProfilePicURL = ""
            let twitterUserAccessToken = ""

            // Twitter Id
            if let twitterId = json["id_str"].string {
                print("Twitter Id: \(twitterId)")
                twitterUserId = twitterId
            } else {
                Toast.show(message: "Twitter UserId not exists", controller: self)
            }

            // Twitter Handle
            if let twitterHandle = json["screen_name"].string {
                print("Twitter Handle: \(twitterHandle)")
                twitterUserHandle = twitterHandle
            } else {
                Toast.show(message: "Twitter User handle not exists", controller: self)
            }

            // Twitter Name
            if let twitterName = json["name"].string {
                print("Twitter Name: \(twitterName)")
                twitterUserName = twitterName
            } else {
                Toast.show(message: "Twitter Username not exists", controller: self)
            }

            // Twitter Email
            if let twitterEmail = json["email"].string {
                print("Twitter Email: \(twitterEmail)")
                twitterUserEmail = twitterEmail
            } else {
                Toast.show(message: "Twitter User email not exists", controller: self)
            }

            // Twitter Profile Pic URL
            if let twitterProfilePic = json["profile_image_url_https"].string?.replacingOccurrences(of: "_normal", with: "", options: .literal, range: nil) {
                twitterUserProfilePicURL = twitterProfilePic
            } else {
                Toast.show(message: "Twitter User profile pic not exists", controller: self)
            }

            if accToken?.key != "" && accToken?.key != nil {
                LogHandler.shared.reportLogOnConsole(nil, "user: \(twitterUserHandle)")
                LogHandler.shared.reportLogOnConsole(nil, "id: \(twitterUserId), name: \(twitterUserName), email: \(twitterUserEmail)")
                LogHandler.shared.reportLogOnConsole(nil, "pic: \(twitterUserProfilePicURL), token: \(twitterUserAccessToken)")
            } else {
                Toast.show(message: "Twitter Access token not exists", controller: self)
            }
        })
    }

    fileprivate func getFBUserData(_ visibleVC: UIViewController) {
        let params = ["fields": "id, name, first_name, last_name, picture.type(large), email "]
        let graphRequest = GraphRequest.init(graphPath: "/me", parameters: params)
        let connection = GraphRequestConnection()
        connection.add(graphRequest) { ( _, result, _ ) in
            if let resultInfo = result {
                let info = resultInfo as? NSDictionary
                let email = info?["email"] as? String ?? "email not available"
                let id = info?["id"] as? String ?? "id not available"
                var fullName = String()
                if let firstname = info?["first_name"] as? String {
                    if let lastname = info?["last_name"] as? String {
                        fullName = firstname + " " + lastname
                        LogHandler.shared.reportLogOnConsole(nil, "fullname is: \(fullName), id is: \(id) and email is: \(email)")
                    }
                }
                // TODOs: Perform api operation
            }
        }
        connection.start()
    }

    func socialPlatformAuthorizationAPI(_ userData: AuthorizationRequestModel, _ visibleVC: UIViewController) {
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
                LogHandler.shared.reportLogOnConsole(nil, "identityToken is: \(identityToken)")
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

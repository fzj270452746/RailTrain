
import UIKit
import AppTrackingTransparency

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options conn: UIScene.ConnectionOptions) {
        guard let stage = scene as? UIWindowScene else { return }
        let pane = UIWindow(windowScene: stage)
        pane.rootViewController = LobbyHelm()
        pane.makeKeyAndVisible()
        window = pane
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            ATTrackingManager.requestTrackingAuthorization {_ in }
        }
    }
}

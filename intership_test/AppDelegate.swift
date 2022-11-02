import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Override point for customization after application launch.
        createWindow()
        return true
    }

    private func createWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootVc = MainViewController()
        let navigationController = UINavigationController(rootViewController: rootVc)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

//
//  SceneDelegate.swift
//  MVVM+CleanArchitecture
//
//  Created by yujaehong on 1/7/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene), let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        window = UIWindow(windowScene: windowScene)
        let coredata = UserCoreData(viewContext: appDelegate.persistentContainer.viewContext)
        let network = UserNetwork(manager: NetworkManager(session: UserSession()))
        let userRP = UserRepository(coreData: coredata, network: network)
        let userUC = UserListUsecase(repository: userRP)
        let userVM = UserListViewModel(usecase: userUC)
        let userVC = UserListViewController(viewModel: userVM)
        let userNC = UINavigationController(rootViewController: userVC)
        window?.rootViewController = userNC
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
    
    
}


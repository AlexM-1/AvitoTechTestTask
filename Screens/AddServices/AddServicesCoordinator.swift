//
//  AddServicesCoordinator.swift
//  AvitoTechTestTask
//
//  Created by Alex M on 19.04.2023.
//

import UIKit

final class AddServicesCoordinator {
    
    private var navController: UINavigationController
    
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    func showAddServices() {
        let viewModel = AddServicesViewModel(coordinator: self)
        let controller = AddServicesController(viewModel: viewModel)
        self.navController.pushViewController(controller, animated: true)
    }
    
    
    func showAlert(title: String, message: String?) {
        DispatchQueue.main.async {
            TextPicker.default.showInfo(showIn: self.navController, title: title, message: message)
        }
    }
    
}





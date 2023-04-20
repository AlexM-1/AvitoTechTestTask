//
//  AddServicesViewModel.swift
//  AvitoTechTestTask
//
//  Created by Alex M on 19.04.2023.
//

import Foundation


final class AddServicesViewModel {
    
    enum Action {
        case buttonDidTap
        case cellIsSelected(Int)
        case viewIsReady
    }
    
    enum State {
        case initial
        case loading
        case loaded
        case error
    }
    
    let coordinator: AddServicesCoordinator
    
    var addServices = AddServicesResponseCodable(status: "", result: Result(title: "", actionTitle: "", selectedActionTitle: "", list: []))
    
    var stateChanged: ((State) -> Void)?
    private(set) var state: State = .initial {
        didSet {
            stateChanged?(state)
        }
    }
    
    init(coordinator: AddServicesCoordinator) {
        self.coordinator = coordinator
    }
    
    private func fetchAddServices() {
        self.addServices = NetworkManager.shared.loadFromBundleJSON("data.json")
    }
    
    func changeState(_ action: Action) {
        switch action {
            
        case .viewIsReady:
            self.state = .loading
            delay(0.6) {
                self.fetchAddServices()
                self.state = .loaded
            }
            
        case .buttonDidTap:
            var servicesText = ""
            var titleText = ""
            addServices.result.list.forEach {
                if $0.isSelected == true {
                    servicesText.append(contentsOf: "- \($0.title)\n")
                }
            }
            titleText = (servicesText == "") ? "Услуги не выбраны." : "Выбраны услуги:"
            coordinator.showAlert(title: titleText, message: servicesText)
            
        case .cellIsSelected(let index):
            addServices.result.list[index].isSelected.toggle()
            
        }
    }
}


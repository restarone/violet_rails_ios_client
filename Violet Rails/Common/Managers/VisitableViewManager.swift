//
//  VisitableViewManager.swift
//  Violet Rails
//
//  Created by Joses Solmaximo on 05/05/23.
//

import Foundation

class VisitableViewManager {
    static let shared = VisitableViewManager()

    private(set) var loadingViewControllers = Set<BaseVisitableViewController>()
    private(set) var baseURLs: [URL] = [URL(string: App.ENDPOINT)!]
    private(set) var selectedURL: URL = URL(string: App.ENDPOINT)!

    private var onLoad: (() -> Void)?

    private init() { }

    func addLoadingViewController(_ viewController: BaseVisitableViewController) {
        loadingViewControllers.insert(viewController)
    }

    func removeLoadingViewController(_ viewController: BaseVisitableViewController) {
        loadingViewControllers.remove(viewController)

        if loadingViewControllers.isEmpty {
            onLoad?()
        }
    }

    func registerOnLoadListener(onLoad: @escaping () -> Void) {
        self.onLoad = onLoad
    }

    func removeOnLoadListener(){
        self.onLoad = nil
    }

    func setSelectedURL(_ url: URL) {
        selectedURL = url
    }

    func addBaseURL(_ url: URL) {
        baseURLs.append(url)
    }
    
    func removeBaseURL(_ url: URL) {
        if let index = baseURLs.firstIndex(where: { $0 == url }) {
            baseURLs.remove(at: index)
        }
    }
}

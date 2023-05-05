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
    private(set) var baseURLs: [String] = [App.ENDPOINT]
    private(set) var selectedURL: String = App.ENDPOINT

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

    func setSelectedURL(_ endpoint: String) {
        selectedURL = endpoint
    }

    func addBaseURL(_ url: URL) {
        baseURLs.append(url.absoluteString)
    }
}

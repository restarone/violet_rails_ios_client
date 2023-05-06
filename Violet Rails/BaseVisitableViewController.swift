//
//  BaseVisitableViewController.swift
//  Violet Rails
//
//  Created by Joses Solmaximo on 23/04/23.
//

import UIKit
import WebKit
import Turbo

class BaseVisitableViewController: UIViewController, Visitable {
    weak var visitableDelegate: VisitableDelegate?
    var visitableURL: URL!
    
    private lazy var session: Session = {
        let configuration = WKWebViewConfiguration()
        configuration.applicationNameForUserAgent = "VioletRailsiOS"
        let session = Session(webViewConfiguration: configuration)
        session.delegate = self
        return session
    }()

    public convenience init(url: URL) {
        self.init()
        self.visitableURL = url
        
        installVisitableView()
    }
    
    // MARK: View Lifecycle

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        visitableDelegate?.visitableViewWillAppear(self)
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        visitableDelegate?.visitableViewDidAppear(self)
    }

    // MARK: Visitable

    open func visitableDidRender() {
        navigationItem.title = visitableView.webView?.title
    }
    
    open func showVisitableActivityIndicator() {
        visitableView.showActivityIndicator()
    }
    
    open func hideVisitableActivityIndicator() {
        visitableView.hideActivityIndicator()
    }
    
    // MARK: Visitable View

    open private(set) lazy var visitableView: VisitableView! = {
        let view = VisitableView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private func installVisitableView() {
        view.addSubview(visitableView)
        
        NSLayoutConstraint.activate([
            visitableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            visitableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            visitableView.topAnchor.constraint(equalTo: view.topAnchor),
            visitableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        visit(url: visitableURL)
    }
    
    private func visit(url: URL) {
        visitableURL = url
        session.visit(self)
        
        VisitableViewManager.shared.addLoadingViewController(self)
    }
}

extension BaseVisitableViewController: SessionDelegate {
    func session(_ session: Turbo.Session, didFailRequestForVisitable visitable: Turbo.Visitable, error: Error) {
        
    }
    
    func session(_ session: Turbo.Session, didProposeVisit proposal: Turbo.VisitProposal) {
        visit(url: proposal.url)
    }
    
    func sessionWebViewProcessDidTerminate(_ session: Turbo.Session) {
        
    }
    
    func sessionDidLoadWebView(_ session: Session) {
        VisitableViewManager.shared.removeLoadingViewController(self)
    }
}

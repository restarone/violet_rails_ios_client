//
//  TabManager.swift
//  Violet Rails
//
//  Created by Joses Solmaximo on 27/03/23.
//

import Foundation

class TabManager {
    static let shared = TabManager()
    
    public var fetchedTabs: [TabNavigation] = []
}

//
//  NavigationTab.swift
//  Violet Rails
//
//  Created by Joses Solmaximo on 31/03/23.
//

import Foundation

struct NavigationTab: Hashable {
    var title: String
    var path: String
}

let navigationTabs: [NavigationTab] = [
    .init(title: "Home", path: ""),
    .init(title: "Blog", path: "/blog"),
    .init(title: "Forum", path: "/forum"),
]

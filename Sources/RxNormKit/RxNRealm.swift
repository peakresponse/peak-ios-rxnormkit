//
//  RxNRealm.swift
//  RxNormKit
//
//  Created by Francis Li on 12/10/21.
//

import Foundation
import RealmSwift

open class RxNRealm {
    @MainActor public static var main: Realm!
    @MainActor public static var mainURL: URL?
    @MainActor public static var mainMemoryIdentifier: String? = "rxnorm.realm"
    @MainActor public static var isMainReadOnly = false
    
    @MainActor public static func configure(url: URL?, isReadOnly: Bool) {
        RxNRealm.main = nil
        RxNRealm.mainURL = url
        RxNRealm.isMainReadOnly = isReadOnly
        RxNRealm.mainMemoryIdentifier = url != nil ? nil : "rxnorm.realm"
    }

    @MainActor public static func open() -> Realm {
        if Thread.current.isMainThread && RxNRealm.main != nil {
            if !RxNRealm.main.configuration.readOnly {
                RxNRealm.main.refresh()
            }
            return RxNRealm.main
        }
        let config = Realm.Configuration(fileURL: mainURL,
                                         inMemoryIdentifier: RxNRealm.mainMemoryIdentifier,
                                         readOnly: RxNRealm.isMainReadOnly,
                                         objectTypes: [RxNConcept.self])
        let realm = try! Realm(configuration: config)
        if Thread.current.isMainThread {
            RxNRealm.main = realm
        }
        return realm
    }
}

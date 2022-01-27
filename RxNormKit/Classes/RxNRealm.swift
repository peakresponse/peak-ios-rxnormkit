//
//  RxNRealm.swift
//  RxNormKit
//
//  Created by Francis Li on 12/10/21.
//

import RealmSwift

open class RxNRealm {
    public static var main: Realm!
    public static var mainURL: URL?
    public static var mainMemoryIdentifier: String? = "rxnorm.realm"
    public static var isMainReadOnly = false
    
    public static func configure(url: URL?, isReadOnly: Bool) {
        RxNRealm.main = nil
        RxNRealm.mainURL = url
        RxNRealm.isMainReadOnly = isReadOnly
        RxNRealm.mainMemoryIdentifier = url != nil ? nil : "rxnorm.realm"
    }

    public static func open() -> Realm {
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

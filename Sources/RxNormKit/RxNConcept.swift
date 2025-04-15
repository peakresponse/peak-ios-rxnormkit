//
//  RxNConcept.swift
//  RxNormKit
//
//  Created by Francis Li on 12/10/21.
//

import RealmSwift

open class RxNConcept: Object {
    @Persisted(primaryKey: true) open var rxcui: Int
    @Persisted open var rxaui: String
    @Persisted open var sab: String
    @Persisted open var tty: String
    @Persisted open var code: String
    @Persisted open var name: String
    @Persisted open var isCurrentPrescribable: Bool
}

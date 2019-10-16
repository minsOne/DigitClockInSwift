//
//  Indicating.swift
//  Librarys
//
//  Created by minsone on 2019/10/05.
//  Copyright © 2019 minsone. All rights reserved.
//

import Foundation
import RxSwift

extension Observable where Element == Bool {
    public func negate() -> Observable<Bool> {
        return map { value in !value}
    }
}

public func LibrarysFuncA() {
    _ = Observable.just(false).debug().negate().subscribe(onNext: { print("Hello world \($0)")})
}

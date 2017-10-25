//
//  ObservableConvertibleType+CatchError.swift
//  Pods
//
//  Created by 王小涛 on 2017/9/7.
//
//

import RxSwift

extension ObservableConvertibleType {
    
    public func catchErrorWithComplete(handler: @escaping (NSError) -> Void) -> Observable<E> {
        return self.asObservable()
            .catchError { error in
                DispatchQueue.main.async {
                    handler(error as NSError)
                }
                return Observable.empty()
        }
    }
}

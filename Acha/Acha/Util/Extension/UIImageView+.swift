//
//  UIImageView+.swift
//  Acha
//
//  Created by 조승기 on 2022/12/01.
//

import UIKit
import RxSwift

extension UIImageView {
    func setImage(url: String, disposeBag: DisposeBag) {
        DefaultImageService.shared.loadImage(url: url)
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { data in
                self.image = UIImage(data: data)
            },onError: {
                print($0)
            }).disposed(by: disposeBag)
    }
}

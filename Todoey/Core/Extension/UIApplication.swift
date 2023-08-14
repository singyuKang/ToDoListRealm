//
//  UIApplication.swift
//  Todoey
//
//  Created by 강신규 on 2023/08/10.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import UIKit


extension UIApplication {
    class func topViewController() -> UIViewController? {
        if let keyWindow = UIApplication.shared.keyWindow {
            if var viewController = keyWindow.rootViewController {
                while viewController.presentedViewController != nil {
                    viewController = viewController.presentedViewController!
                }
                print("topViewController -> \(String(describing: viewController))")
                return viewController
            }
        }
        return nil
    }
    
    func showAlert(title: String = "알림",
                   message: String?,
                   hideCancel:Bool = true,
                   cancelTitle: String = "취소",
                   confirmTitle: String = "확인",
                   cancelHandler: (() -> Void)? = nil,
                   confirmHandler: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: cancelTitle, style: .cancel, handler: { action in
            Log.print(message: "cancel")
            cancelHandler?()
        })
        let ok = UIAlertAction(title: confirmTitle, style: .default, handler: { action in
            Log.print(message: "confirm")
            confirmHandler?()
        })
        if hideCancel == true {
            alert.addAction(ok)
        } else {
            alert.addAction(cancel)
            alert.addAction(ok)
        }
        
        let topView = UIApplication.topViewController()
        topView?.present(alert, animated: true, completion: nil)
//        keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
//    //MARK: - PIN View
//    func PINView(title:String = "간편 로그인",
//                 content:String = "PIN번호 입력",
//                 hint:String = "6자리 입력",
//                 register:Bool = false,
//                 data:[String:String] = [:],
//                 completeHandler: ((String, String) -> Void)? = nil,
//                 cancelHandler: (() -> Void)? = nil) {
//
//        let vc = PINVC.instantiate(storyboard: "PIN")
//        vc.title_name = title
//        vc.content = content
//        vc.hint = hint
//        vc.register = register
//        vc.parameter = data
//        vc.completeHandler = completeHandler
//        vc.cancelHandler = cancelHandler
//
//        let topView = UIApplication.topViewController()
//        topView?.present(vc, animated: true, completion: nil)
//    }
//
//    //MARK: - Pattern View
//    func patternView(title:String = "간편 로그인",
//                     content:String = "패턴 입력",
//                     hint:String = "패턴을 그려주세요",
//                     register:Bool = false,
//                     data:[String:String] = [:],
//                     completeHandler: ((String) -> Void)? = nil,
//                     cancelHandler: ((String) -> Void)? = nil) {
//
//        let vc = PatternVC.instantiate(storyboard: "Pattern")
//        vc.title_name = title
//        vc.content = content
//        vc.hint = hint
//        vc.register = register
//        vc.data = data
//        vc.complete = completeHandler
//        vc.failed = cancelHandler
//
//        let topView = UIApplication.topViewController()
//        topView?.present(vc, animated: true, completion: nil)
//    }
//
//    //MARK: - Bio View
//    func bioView(register:Bool = false,
//                 data:[String:String] = [:],
//                 completeHandler: ((String) -> Void)? = nil,
//                 cancelHandler: ((String, Int32) -> Void)? = nil) {
//
//        let vc = BioVC()
//        vc.register = register
//        vc.data = data
//        vc.complete = completeHandler
//        vc.failed = cancelHandler
//        vc.setupView()
//    }
//
//    //MARK: - OCR View
//    func ocrView(serverData:[String:Any] = [:], completeHandler: (([String:String]) -> Void)? = nil) {
//        let vc = OcrVC.instantiate(storyboard: "Ocr")
//        vc.completeHandler = completeHandler
//        vc.serverData = serverData
//        let topView = UIApplication.topViewController()
//        topView?.present(vc, animated: true, completion: nil)
//    }
//
//    //MARK: - Certificate
//    func certificate(scraping: Bool = false,
//                     management: Bool = false,
//                     parameters:[String:Any] = [:],
//                     completeHandler: (([String:String]) -> Void)? = nil) {
//        let vc = CertListVC.instantiate(storyboard: "CertList")
//        vc.complete = completeHandler
//        vc.scraping = scraping
//        vc.parameters = parameters
//        vc.management = management
//
//        let topView = UIApplication.topViewController()
//        topView?.present(vc, animated: true, completion: nil)
//    }
//
//    //MARK: - Capcha
//    func capcha(image64: String,
//                refreshHandler:(() -> Void)? = nil,
//                completeHandler: (([String:String]) -> Void)? = nil) {
//        let vc = CaptchaVC.instantiate(storyboard: "Captcha")
//        vc.image = image64
//        vc.completeHandler = completeHandler
//        vc.refreshHandler = refreshHandler
//        let topView = UIApplication.topViewController()
//        topView?.present(vc, animated: true, completion: nil)
//    }
    
}




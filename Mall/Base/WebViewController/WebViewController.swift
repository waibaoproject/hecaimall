//
//  WebViewController.swift
//  Football
//
//  Created by 王小涛 on 2017/7/14.
//  Copyright © 2017年 bet007. All rights reserved.
//

import WebKit
import SnapKit
//import WebViewJavascriptBridge

class WebViewController: UIViewController {
    
    lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.suppressesIncrementalRendering = false
        
        let view = WKWebView(frame: .zero, configuration: configuration)
        return view
    }()
    
    private lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor = .white
        view.progressTintColor = .red
        return view
    }()
    
    private var observation1: NSKeyValueObservation?
    private var observation2: NSKeyValueObservation?

    
//    fileprivate var bridge: WKWebViewJavascriptBridge?
    
    var urlString: String? {
        didSet {
            guard let string = urlString else {
                return
            }
            url = URL(string: string)
        }
    }
    
    var url: URL? {
        didSet {
            guard let url = url else {
                return
            }
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    deinit {
//        webView.removeObserver(self, forKeyPath: "title")
//        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userAgent: String = {
            var agent = ""
            agent = "hotchoose platform=iOS"
            if let accessToken = LoginCenter.default.accessToken {
                agent += " "
                agent += "accesstoken=\(accessToken)"
            }
            return agent
        }()
      
        webView.customUserAgent = userAgent
        setupViews()
        
    }
    
    func setupViews() {
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
//        observation1 = webView.observe(\.title) { [weak self] (webView, changed) in
//            self?.title = webView.title
//        }
//
//        observation2 = webView.observe(\.estimatedProgress) { [weak self] (webView, changed) in
//            guard let `self` = self else {return}
//            self.progressView.progress = Float(webView.estimatedProgress)
//            if self.progressView.progress >= 1.0 {
//                self.progressView.isHidden = true
//            } else {
//                self.progressView.isHidden = false
//            }
//        }
        
//        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
//        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        view.addSubview(webView)
//        view.addSubview(progressView)
        
        webView.snp.updateConstraints {
            $0.edges.equalToSuperview()
        }
        
//        progressView.snp.updateConstraints {
//            $0.top.equalToSuperview()
//            $0.left.equalToSuperview()
//            $0.right.equalToSuperview()
//            $0.height.equalTo(2)
//        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.reload()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let key = keyPath else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        guard let ofObject = object as? WKWebView, ofObject == webView else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if key == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
            if progressView.progress >= 1.0 {
                progressView.isHidden = true
            } else {
                progressView.isHidden = false
            }
        }
        
        if key == "title" {
            self.title = webView.title
        }
    }
}

//extension WebViewController {
//    
//    fileprivate func setupBridge() {
//        
//        bridge = WKWebViewJavascriptBridge(for: webView)!
//        bridge?.setWebViewDelegate(self)
//        
//        bridge?.registerHandler("route") { (data, callback) in
//            print("get route: \(String(describing: data))")
//            guard let urlString = data as? String else {
//                return
//            }
//            guard let url = URL(string: urlString) else {
//                return
//            }
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
//    }
//}


extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        completionHandler(.performDefaultHandling, nil)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
    }
}

extension WebViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void) {
        
        let controller = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "确认", style: .default, handler: { (_) in
            completionHandler()
        }))
        present(controller, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Swift.Void) {
        
        let controller = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "确认", style: .default, handler: { (_) in
            completionHandler(true)
        }))
        controller.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
            completionHandler(false)
        }))
        present(controller, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Swift.Void) {
        
        let controller = UIAlertController(title: prompt, message: nil, preferredStyle: .alert)
        controller.addTextField { (textField) in
            textField.text = defaultText
        }
        controller.addAction(UIAlertAction(title: "完成", style: .default, handler: {[weak controller] (_) in
            completionHandler(controller?.textFields?.first?.text)
        }))
        present(controller, animated: true, completion: nil)
    }
}



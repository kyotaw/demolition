//
//  FirstViewController.swift
//  WebBreaker
//
//  Created by 渡部郷太 on 2018/09/15.
//  Copyright © 2018 watanabe kyota. All rights reserved.
//

import UIKit
import WebKit

func loadScript(name: String) -> String {
    var jsSource = ""
    let path = Bundle.main.path(forResource: name, ofType: "js")!
    if let data = NSData(contentsOfFile: path){
        jsSource = String(NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)!)
    }
    return jsSource
}

class FirstViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    override func loadView() {
        var jsSource = loadScript(name: "init")
        
        // WKUserScriptを作成、injectionTimeにJavaScriptを実行するタイミングを指定します
        let userScript1 = WKUserScript(source: jsSource, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
        
        let controller = WKUserContentController()
        controller.addUserScript(userScript1)
        controller.add(self, name: JsHandler.initHandler.rawValue)
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController = controller
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //let myURL = URL(string:"https://www.apple.com")
        let myURL = URL(string:"https://www.msn.com/ja-jp")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if(message.name == JsHandler.initHandler.rawValue) {
            print(message.body)
            let script = loadScript(name: "buildStage")
            self.webView.evaluateJavaScript(script, completionHandler: buildStageHandler)
        }
    }
    
    func buildStageHandler(res: Any?, error: Error?) {
        print(res)
        print(error.debugDescription)
    }

    var webView: WKWebView!
}


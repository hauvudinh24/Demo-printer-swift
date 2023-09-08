//
//  ContentView.swift
//  Demo Printer
//
//  Created by Mac on 05/09/2023.
//

import SwiftUI
import Foundation
import UIKit
import WebKit
class PrintJobCoordinator: NSObject, ObservableObject, WKNavigationDelegate {
    @Published var pdfData: Data?
    @Published var isPrinting = false // Track printing status
    
    func convertHtmlToPdf() {
        let htmlString = loadHTMLFile(fileName: "print_2")
        if let htmlString = htmlString {
          print(htmlString)
        } else {
          print("Could not load HTML file")
        }
        
        let controller = UIPrintInteractionController.shared

        let printInfo = UIPrintInfo.printInfo()
        printInfo.jobName = "Print"
        printInfo.outputType = .general

        controller.printInfo = printInfo
        var formatter =  UIMarkupTextPrintFormatter(markupText: htmlString ?? "");
        formatter.perPageContentInsets = .zero
        
        let renderer = UIPrintPageRenderer()
        renderer.addPrintFormatter(formatter, startingAtPageAt: 0)
        renderer.drawPage(at: 0, in: CGRect(x: 0, y: 0, width: 172, height: 172))
        
        controller.printPageRenderer = renderer
        controller.showsPaperSelectionForLoadedPapers = true
        controller.showsPageRange = true

        // Present the print UI
        do {
          try controller.present(animated: true, completionHandler: nil)
        } catch {
          // Handle the error
        }
    }
    
    func loadHTMLFile(fileName: String) -> String? {
      let bundle = Bundle.main
      let url = bundle.url(forResource: fileName, withExtension: "html")
      if let url = url {
        let data = try? Data(contentsOf: url)
        if let data = data {
          let string = String(data: data, encoding: .utf8)
          return string
        }
      }
      return nil
    }
    
}

struct ContentView: View {
    @StateObject private var coordinator = PrintJobCoordinator()
    
    var body: some View {
        VStack {
            Button("Click here to print") {
                coordinator.convertHtmlToPdf()
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



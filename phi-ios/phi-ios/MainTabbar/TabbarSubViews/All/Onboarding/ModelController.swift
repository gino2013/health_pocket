//
//  ModelController.swift
//  phi-ios
//
//  Created by Kenneth Wu on 2024/12/3.
//

import UIKit
/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */

enum OnboardingData: CaseIterable {
    case page1
    case page2
    case page3
    case page4
    
    var lottieName: String {
        switch self {
        case .page1:
            return "MedReminderGuide_1"
        case .page2:
            return "MedReminderGuide_2"
        case .page3:
            return "MedReminderGuide_3"
        case .page4:
            return "MedReminderGuide_4"
        }
    }
    
    var pageTitle: String {
        switch self {
        case .page1:
            return "1.選取並組合藥品"
        case .page2:
            return "2.「作息與提醒」設定 (初次設定)"
        case .page3:
            return "3.「用藥頻率」設定"
        case .page4:
            return "4.關於多組提醒組合設定"
        }
    }
    
    var pageContent: String {
        switch self {
        case .page1:
            return """
請選取要組合的藥品，然後點擊「設定提醒」。

若只選擇單一藥品，可點擊「設定提醒」與「編輯藥品」。

附註：
只有相同的「用法」和「服用時間」可以組合!
"""
        case .page2:
            return """
若初次設定用藥提醒，會跳出「作息與提醒設定」畫面，幫助您一次性完成三餐、睡前以及提醒時間。

若點擊「略過」，會直接跳至「用藥頻率設定」，當下次在設定用藥提醒時會再次出現此設定。
"""
        case .page3:
            return """
為了確保用藥期間與頻率，請依序設定「預計服用日期」、「用藥頻率」與「服用時間」。

設定好「用藥頻率」請點擊「設定提醒」，會顯示您組合好的「提醒1」，點擊「完成」即可完成設定。

附註：
如果已設定好「作息與提醒設定」，「服用時間」會顯示設定好的三餐與睡前時間。
"""
        case .page4:
            return """
如果您除了「提醒1」組合外還有其他藥品，請繼續照「步驟1」和「步驟3」進行設定。
            
若各藥品組合已設定完畢，請點擊「完成」即可完成多組設定。
"""
        }
    }
}

class ModelController: NSObject, UIPageViewControllerDataSource {
    var pageData: [OnboardingData] = []
    
    override init() {
        super.init()
        // Create the data model.
        // let dateFormatter = DateFormatter()
        // pageData = dateFormatter.monthSymbols
        pageData = [OnboardingData.page1,
                    OnboardingData.page2,
                    OnboardingData.page3,
                    OnboardingData.page4]
    }
    
    func viewControllerAtIndex(_ index: Int, storyboard: UIStoryboard) -> DataViewController? {
        // Return the data view controller for the given index.
        if (self.pageData.count == 0) || (index >= self.pageData.count) {
            return nil
        }
        // Create a new view controller and pass suitable data.
        let dataViewController = storyboard.instantiateViewController(withIdentifier: "DataViewController") as! DataViewController
        dataViewController.dataObject = self.pageData[index]
        return dataViewController
    }
    
    func indexOfViewController(_ viewController: DataViewController) -> Int {
        // Return the index of the given data view controller.
        // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
        return pageData.firstIndex(of: viewController.dataObject) ?? NSNotFound
    }
    
    // MARK: - Page View Controller Data Source
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! DataViewController)
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! DataViewController)
        
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        if index == self.pageData.count {
            return nil
        }
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
}

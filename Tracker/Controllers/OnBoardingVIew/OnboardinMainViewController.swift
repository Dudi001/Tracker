//
//  OnboardinMainViewController.swift
//  Tracker
//
//  Created by Мурад Манапов on 19.10.2023.
//

import UIKit


final class OnboardinMainViewController: UIPageViewController {
    private lazy var pages: [OnboardingViewController] = {
       let fistController = OnboardingViewController(
        header: NSLocalizedString("onboard.titleOne", comment: ""),
        backgroundImage: Resourses.Images.firstImageForOnboarding!)
        
        let secondController = OnboardingViewController(
            header: NSLocalizedString("onboard.titleTwo", comment: ""),
            backgroundImage: Resourses.Images.secondImageForOnboardin!)
        
        return [fistController, secondController]
    }()
    
    private lazy var pageControl: UIPageControl = {
       let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = .gray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var buttonStart: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("onboard.startButton.title", comment: ""), for: .normal)
        button.backgroundColor = .ypBlack
        button.setTitleColor(.ypWhite, for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        view.addSubview(buttonStart)
        view.addSubview(pageControl)
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        addConstraints()
    }
    
    
    @objc
    private func buttonTapped() {
        let tabBarViewController = TabBarViewController()
        tabBarViewController.modalPresentationStyle = .fullScreen
        skipOnBoarding()
        present(tabBarViewController, animated: true)
    }
    
    private func skipOnBoarding() {
        UserDefaults.standard.set(true, forKey: "isFirstLaunch")
    }
    
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -168),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonStart.heightAnchor.constraint(equalToConstant: 60),
            buttonStart.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            buttonStart.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStart.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}


extension OnboardinMainViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController as! OnboardingViewController) else { return nil}
        
        var indexBefore = viewControllerIndex - 1
        
        if indexBefore < 0 {
            indexBefore = pages.count - 1
        }
        
        return pages[indexBefore]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.firstIndex(of: viewController as! OnboardingViewController) else { return nil}
        
        var indexAfter = viewControllerIndex + 1
        
        if indexAfter > pages.count - 1 {
            indexAfter = 0
        }
        
        return pages[indexAfter]
    }
}

extension OnboardinMainViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController as! OnboardingViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}

//
//  ScrollProgressControl.swift
//  TableViewTest
//
//  Created by 山不在高 on 17/6/27.
//  Copyright © 2017年 山不在高. All rights reserved.
//

import UIKit

class ScrollProgressControl: UIView {

    fileprivate var scrollView: UIScrollView
    fileprivate var proColor: UIColor;
    fileprivate lazy var proWidth: CGFloat = {
        let proW = self.frame.width / 2
        return proW
    }()
    fileprivate lazy var progressView: UIView = UIView()
    fileprivate var isDragging = false
    
    init(frame: CGRect, scrollView: UIScrollView, proColor: UIColor = UIColor.lightGray) {
        self.scrollView = scrollView
        self.proColor = proColor
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        scrollView.removeObserver(self, forKeyPath: "isDragging")
    }
}
// MARK:- 设置UI
extension ScrollProgressControl {
    fileprivate func setupUI() {
        self.clipsToBounds = true
        progressView.backgroundColor = proColor
        progressView.frame = CGRect(x: 0, y: 0, width: proWidth, height: 0)
        self.addSubview(progressView)
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        progressView.layer.cornerRadius = proWidth / 2
    }
    // 正在滑动
    fileprivate func dragging() {
        let totalHei = frame.height
        
        let itemHeight = scrollView.frame.height * totalHei / scrollView.contentSize.height
        let progress = scrollView.contentOffset.y / (scrollView.contentSize.height - scrollView.frame.height)
        let itemY = progress * (totalHei - itemHeight)
        progressView.frame = CGRect(x: 0, y: itemY, width: proWidth, height: itemHeight)
        progressView.isHidden = false
        
    }
    // 已经停止滑动
    fileprivate func didEndDragged() {
        progressView.isHidden = true
    }
}


// MARK:- KVO + 回调
extension ScrollProgressControl {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        dragging()
        if isDragging == false {
            perform(#selector(timeOut), with: nil, afterDelay: 0.25)
            isDragging = true
        }
        
    }
    @objc fileprivate func timeOut() {
        isDragging = false
        didEndDragged()
    }
}






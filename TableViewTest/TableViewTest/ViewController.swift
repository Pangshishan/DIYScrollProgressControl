//
//  ViewController.swift
//  TableViewTest
//
//  Created by 山不在高 on 17/6/27.
//  Copyright © 2017年 山不在高. All rights reserved.
//

import UIKit
import MJRefresh

func ScreenWidth() -> CGFloat {
    return UIScreen.main.bounds.width
}
func ScreenHeight() -> CGFloat {
    return UIScreen.main.bounds.height
}

let HeaderViewHeight: CGFloat = 200
let HeaderBGColor = UIColor.red
let TableViewCellID = "TableViewCellID"
let ProgressControlWidth: CGFloat = 6

class ViewController: UIViewController {

    fileprivate lazy var headerView = UIView()
    fileprivate var tableView: UITableView!
    fileprivate var cellCount: Int = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

// MARK:- 设置UI
extension ViewController {
    fileprivate func setupUI() {
        setupTableView()
        setupHeaderView()
        setupScrollProgressControl()
        setupRefresh()
    }
    fileprivate func setupHeaderView() {
        headerView.frame = CGRect(x: 0, y: 0, width: ScreenWidth(), height: HeaderViewHeight)
        headerView.backgroundColor = HeaderBGColor
        tableView.addSubview(headerView)
        
    }
    fileprivate func setupTableView() {
        let tRect = CGRect(x: 0, y: 0, width: ScreenWidth(), height: ScreenHeight())
        tableView = UITableView(frame: tRect, style: .grouped)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: TableViewCellID)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: HeaderViewHeight))
        tableView.showsVerticalScrollIndicator = false
    }
    fileprivate func setupScrollProgressControl() {
        let pFrame = CGRect(x: ScreenWidth() - 0 - ProgressControlWidth, y: HeaderViewHeight, width: ProgressControlWidth, height: ScreenHeight() - HeaderViewHeight)
        let progressC = ScrollProgressControl(frame: pFrame, scrollView: tableView)
        view.addSubview(progressC)
    }
    
    fileprivate func adjustHeaderView() {
        let offSetY = tableView.contentOffset.y
        if offSetY <= 0 {
            headerView.frame.origin.y = offSetY
        } else {
            headerView.frame.origin.y = 0
        }
       
    }
    fileprivate func setupRefresh() {
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] in
            self?.perform(#selector(self?.setupHeaderData), with: nil, afterDelay: 1.5)
        })
        tableView.mj_header.ignoredScrollViewContentInsetTop = -HeaderViewHeight
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.perform(#selector(self?.setupFooterData), with: nil, afterDelay: 0.5)
        })
    }
}

// tableView代理方法
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellID, for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}
// MARK:- 数据方法
extension ViewController {
    @objc fileprivate func setupHeaderData() {
        cellCount = 30
        tableView.reloadData()
        self.tableView.mj_header.endRefreshing()
    }
    @objc fileprivate func setupFooterData() {
        cellCount += 30
        tableView.reloadData()
        self.tableView.mj_footer.endRefreshing()
    }
}

// scrollView代理方法
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            adjustHeaderView()
        }
    }
}

























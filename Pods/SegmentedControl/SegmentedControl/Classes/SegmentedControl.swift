//
//  SegmentedControl.swift
//  Pods
//
//  Created by 王小涛 on 2016/12/19.
//
//

import UIKit

@IBDesignable
public class SegmentedControl: UIView {
    
    fileprivate let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.alwaysBounceHorizontal = false
        view.alwaysBounceVertical = false
        view.isDirectionalLockEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        return view
    }()
    
    fileprivate let maskHolderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    fileprivate let segmentedControl: UISegmentedControl = {
        let view = UISegmentedControl()
        view.apportionsSegmentWidthsByContent = true
        return view
    }()
    
    public convenience init(items: [String]) {
        self.init(frame: .zero)
        items.enumerated().forEach { segmentedControl.insertSegment(withTitle: $1, at: $0, animated: true) }
    }
    
    
    @IBInspectable
    public override var tintColor: UIColor? {
        didSet {
            super.tintColor = tintColor
            segmentedControl.tintColor = .clear
        }
    }
    
    @IBInspectable
    public var items: [String] {
        get {
            return segmentedControl.items
        }
        set {
            segmentedControl.items = newValue
        }
    }
    
    @IBInspectable
    public var automaticallyAdjustsItemWidth: Bool = true
    
    public var itemWidths: [CGFloat] = [] {
        didSet {
            automaticallyAdjustsItemWidth = false
        }
    }
    
    @IBInspectable
    public var segmentSpacing: CGFloat {
        get {
            return segmentedControl.segmentSpacing
        }
        set {
            segmentedControl.segmentSpacing = newValue
        }
    }
    
    @IBInspectable
    public var overlap: CGFloat = 0
    
    public var contentInset: UIEdgeInsets {
        get {
            return scrollView.contentInset
        }
        set {
            scrollView.contentInset = newValue
        }
    }
    
    public func setTitleTextAttributes(_ attributes: [AnyHashable : Any]?, for state: UIControlState) {
        segmentedControl.setTitleTextAttributes(attributes, for: state)
    }
    
    public var segmentBackgroundView: ((_ selected: Bool) -> UIView)? {
        didSet {
            makeMaskViews()
        }
    }
    
    fileprivate var selectedSegmentMaskView: UIView?
    fileprivate var selectedSegmentMaskViewIsMoving: Bool = false
    
    public var animatedDuration: TimeInterval = 0.3
    
    @IBInspectable
    public var animated: Bool = true
    
    public var didSelect: ((Int) -> Void)? = nil
    
    @IBInspectable
    public var selectedSegmentIndex: Int = 0 {
        
        didSet {
            
            guard selectedSegmentIndex >= 0 && selectedSegmentIndex < segmentedControl.numberOfSegments else { return }
            
            // 滑块滑动
            let newFrame = CGRect(x: segmentedControl.contentOffsetForSegment(at: selectedSegmentIndex).x, y: 0, width: segmentedControl.widthForSegment(at: selectedSegmentIndex), height: bounds.height)
            
            if animated {
                selectedSegmentMaskViewIsMoving = true
                UIView.animate(withDuration: animatedDuration, animations: { 
                    self.selectedSegmentMaskView?.frame = newFrame
                }, completion: { _ in
                    self.selectedSegmentMaskViewIsMoving = false
                })
                
            }else {
                selectedSegmentMaskView?.frame = newFrame
            }
            
            
            // 看不见的部分要移动到看得见的地方来
            let delta = segmentedControl.contentOffsetForSegment(at: selectedSegmentIndex).x - scrollView.contentOffset.x - overlap
            if delta < 0 {
                var contentOffset = scrollView.contentOffset
                contentOffset.x = max(-scrollView.contentInset.left, contentOffset.x + delta)
                // 往右滑动，contentOffset.x 变小
                scrollView.setContentOffset(contentOffset, animated: true)
            }else {
                
                let delta = (segmentedControl.contentOffsetForSegment(at: selectedSegmentIndex).x + segmentedControl.widthForSegment(at: selectedSegmentIndex)) - (scrollView.contentOffset.x + scrollView.bounds.width) + overlap
                if delta > 0 {
                    var contentOffset = scrollView.contentOffset
                    contentOffset.x = min(scrollView.contentSize.width + scrollView.contentInset.right - scrollView.bounds.width, contentOffset.x + delta)
                    // 往左滑动，contentOffset.x 变大
                    scrollView.setContentOffset(contentOffset, animated: true)
                }
            }
            
            segmentedControl.selectedSegmentIndex = selectedSegmentIndex
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        reload()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public func updateItem(_ item: String, atIndex index: Int) {
        segmentedControl.setTitle(item, forSegmentAt: index)
    }
    
    public func reload() {
        
        if automaticallyAdjustsItemWidth {
            let width = (bounds.width - CGFloat((segmentedControl.numberOfSegments - 1)) * segmentedControl.segmentSpacing - contentInset.left - contentInset.right) / CGFloat(segmentedControl.numberOfSegments)
            segmentedControl.itemWidths = (0..<segmentedControl.numberOfSegments).map{ _ in width }
        }else {
            segmentedControl.itemWidths = itemWidths
        }
        
        scrollView.frame = bounds
        segmentedControl.frame = CGRect(x: 0, y: 0, width: segmentedControl.contentLength, height: bounds.height)
        scrollView.contentSize = CGSize(width: segmentedControl.frame.width, height: bounds.height)
        maskHolderView.frame = segmentedControl.frame
        makeMaskViews()
        segmentedControl.selectedSegmentIndex = selectedSegmentIndex
    }
}

public extension SegmentedControl {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard animated && !selectedSegmentMaskViewIsMoving else {
            return
        }
        
        let offsetX = scrollView.contentOffset.x
        let index = offsetX / scrollView.bounds.width
        let preIndex = Int(index)
        let nextIndex = preIndex + 1
        
        guard preIndex >= 0 && preIndex < segmentedControl.numberOfSegments else { return }
        guard nextIndex >= 0 && nextIndex < segmentedControl.numberOfSegments else { return }
        
        // 滑块滑动
        let preIndexFrame = CGRect(x: segmentedControl.contentOffsetForSegment(at: preIndex).x, y: 0, width: segmentedControl.widthForSegment(at: preIndex), height: bounds.height)
        let nextIndexFrame = CGRect(x: segmentedControl.contentOffsetForSegment(at: nextIndex).x, y: 0, width: segmentedControl.widthForSegment(at: nextIndex), height: bounds.height)
        let deltaMinX = nextIndexFrame.minX - preIndexFrame.minX
        let deltaWidth = nextIndexFrame.width - preIndexFrame.width

        let minX = (index - CGFloat(preIndex)) * deltaMinX + preIndexFrame.minX
        let width = (index - CGFloat(preIndex)) * deltaWidth + preIndexFrame.width
        
        let frame = CGRect(x: minX, y: 0, width: width, height: bounds.height)
        
        UIView.animate(withDuration: animatedDuration) {
            self.selectedSegmentMaskView?.frame = frame
        }
    }
}

private extension SegmentedControl {

    func setup() {
        addSubview(scrollView)
        scrollView.addSubview(maskHolderView)
        scrollView.addSubview(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(sender:)), for: .valueChanged)
    }
    
    func makeMaskViews() {
        
        maskHolderView.removeAllSubviews()
        selectedSegmentMaskView?.removeFromSuperview()
        selectedSegmentMaskView = nil
        
        guard let segmentBackgroundView = segmentBackgroundView else {
            return
        }
        
        (0..<segmentedControl.numberOfSegments).forEach {
            let frame = CGRect(x: segmentedControl.contentOffsetForSegment(at: $0).x, y: 0, width: segmentedControl.widthForSegment(at: $0), height: segmentedControl.bounds.height)
            
            let maskView = segmentBackgroundView(false)
            maskView.frame = frame
            maskHolderView.insertSubview(maskView, at: $0)
        }
        
        let frame = CGRect(x: segmentedControl.contentOffsetForSegment(at: selectedSegmentIndex).x, y: 0, width: segmentedControl.widthForSegment(at: selectedSegmentIndex), height: segmentedControl.bounds.height)
        let maskView = segmentBackgroundView(true)
        maskView.frame = frame
        selectedSegmentMaskView = maskView
        maskHolderView.addSubview(maskView)
    }
    
    @objc func segmentedControlValueChanged(sender: UISegmentedControl) {
        selectedSegmentIndex = sender.selectedSegmentIndex
        didSelect?(selectedSegmentIndex)
    }
}



import UIKit
import FoundationExtension

class ItemsSelectionView: UIView, AsPicker {
    
    var items: [String] = [] {
        didSet {
            picker.reloadAllComponents()
        }
    }
    
    var selectedIndex: Int = 0 {
        didSet {
            guard selectedIndex >= 0 && selectedIndex < picker.numberOfRows(inComponent: 0) else {return}
            delay(time: 0.3) {
                self.picker.selectRow(self.selectedIndex, inComponent: 0, animated: true)
                self.picker.reloadAllComponents()
            }
        }
    }
    
    var selected: ((String, Int) -> Void)?
    
//    func dismiss() {
//        let selectedItem = items[selectedIndex]
//        selected?(selectedItem, selectedIndex)
//        (superview as? PickerView)?.dismiss()
//    }
    
    fileprivate lazy var picker: UIPickerView = { [unowned self] in
        let view = UIPickerView()
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .white
        self.addSubview(view)
        
        return view
        }()
    
    override func updateConstraints() {
        
        picker.snp.updateConstraints({
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        })
        
        super.updateConstraints()
    }
}

extension ItemsSelectionView: UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
}

extension ItemsSelectionView: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 33
    }
    
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.bounds.width
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        picker.isSeperatorHidden = true
        let item = items[row]
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 15)
        label.text = item
        return label
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadAllComponents()
        selectedIndex = row
        
        if row < items.count {
            let selectedItem = items[row]
            selected?(selectedItem, row)
        }
    }
}


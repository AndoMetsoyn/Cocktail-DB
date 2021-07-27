//
//  HeaderSectionView.swift
//  Cocktail-DB
//
//  Created by Ando Metsoyan on 7/26/21.
//

import UIKit

class HeaderSectionView: UIView {

    private let SECTION_LEFT_MARGIN: CGFloat = 20
    
    public var title: String {
        set {
            self.titleLabel.text = newValue.uppercased()
        }
        get {
            return self.titleLabel.text!
        }
    }
    
    private var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
        self.createUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
        self.createUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupUI()
    }
        
    private func configure() {
        self.backgroundColor = UIColor.appColor.paleGrey.color()
    }
    
    private func createUI() {
        self.createTitleLabel()
    }
    
    private func setupUI() {
        self.titleLabel.frame = self.geTitleLabelFrame()
    }
    
    private func createTitleLabel() {
        self.titleLabel = UILabel()
        self.titleLabel.textAlignment = .left
        self.titleLabel.font = UIFont.systemFont(ofSize: 17)
        self.titleLabel.numberOfLines = 0
        self.titleLabel.textColor = UIColor.appColor.textGrey.color()
        self.addSubview(self.titleLabel)
    }
    
    private func geTitleLabelFrame() -> CGRect {
        var rect = CGRect()
        rect.origin.x = self.SECTION_LEFT_MARGIN
        rect.size.width = self.frame.width - 2 * rect.origin.x
        rect.size.height = self.frame.height
        return rect
    }
    
}

//
//  CalendarDayCell.swift
//  Active
//
//  Created by Tiago Maia Lopes on 09/07/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import JTAppleCalendar

/// Cell in charge of displaying the calendar's days.
@IBDesignable class CalendarDayCell: JTAppleCell {

    // MARK: Parameters

    /// The day's title label.
    var dayTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "SFProText-Regular", size: 21)
        label.textColor = UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    /// The circle view to be displayed.
    var circleView: UIView = {
        let circleView = UIView()
        circleView.translatesAutoresizingMaskIntoConstraints = false

        return circleView
    }()

    /// The cell's bottom separator.
    var bottomSeparator: CALayer = {
        let separatorLayer = CALayer()
        separatorLayer.backgroundColor = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1).cgColor

        return separatorLayer
    }()

    /// MARK: Life cycle

    override func layoutSubviews() {
        super.layoutSubviews()

        handleSubviews()
        applyLayout()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        layoutIfNeeded()
        dayTitleLabel.text = String(Int.random(0..<32))
    }

    // MARK: Imperatives

    /// Handles the cell's main views, if they should be added as a subview or not.
    private func handleSubviews() {
        if !subviews.contains(circleView) {
            contentView.addSubview(circleView)
        }

        if !subviews.contains(dayTitleLabel) {
            contentView.addSubview(dayTitleLabel)
        }

        if let sublayers = layer.sublayers, !sublayers.contains(bottomSeparator) {
            contentView.layer.addSublayer(bottomSeparator)
        }
    }

    /// Applies the layout to the subviews, if appropriate.
    private func applyLayout() {
        dayTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        dayTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

        circleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        circleView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        circleView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.65).isActive = true
        circleView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.65).isActive = true
        circleView.layer.cornerRadius = frame.size.width * 0.65

        bottomSeparator.frame = CGRect(
            x: 0,
            y: contentView.frame.size.height - 1,
            width: contentView.frame.size.width,
            height: 1
        )
    }
}

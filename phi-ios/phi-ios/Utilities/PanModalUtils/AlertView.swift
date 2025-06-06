//
//  AlertView.swift
//  phi-app-ios
//
//  Created by Kenneth Wu on 2024/7/19.
//

import UIKit

class AlertView: UIView {

    // MARK: - Views

    private let colors = [#colorLiteral(red: 0.7215686275, green: 0.9098039216, blue: 0.5607843137, alpha: 1), #colorLiteral(red: 0.7176470588, green: 0.8784313725, blue: 0.9882352941, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.937254902, blue: 0.4666666667, alpha: 1), #colorLiteral(red: 0.9490196078, green: 0.7568627451, blue: 0.9803921569, alpha: 1), #colorLiteral(red: 0.9960784314, green: 0.8823529412, blue: 0.6980392157, alpha: 1)]

    /*
    private lazy var icon: UIView = {
        let icon = UIView()
        icon.backgroundColor = colors.randomElement()
        icon.layer.cornerRadius = 6.0
        return icon
    }()
    */
    
    private lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "Checked")
        icon.contentMode = .scaleAspectFill
        icon.layer.cornerRadius = 6.0
        icon.clipsToBounds = true
        return icon
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "已編輯成功!"
        label.font = UIFont(name: "PingFangTC-Medium", size: 16.0)
        label.textColor = .white
        return label
    }()

    let message: UILabel = {
        let label = UILabel()
        label.text = "This is an example alert..."
        label.font = UIFont(name: "Lato-Regular", size: 13.0)
        label.textColor = #colorLiteral(red: 0.7019607843, green: 0.7058823529, blue: 0.7137254902, alpha: 1)
        return label
    }()

    private lazy var alertStackView: UIStackView = {
        //let stackView = UIStackView(arrangedSubviews: [titleLabel, message])
        let stackView = UIStackView(arrangedSubviews: [titleLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        //stackView.spacing = 4.0
        stackView.spacing = 0
        return stackView
    }()

    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func setupView() {
        backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1137254902, blue: 0.1294117647, alpha: 1)
        layoutIcon()
        layoutStackView()
    }

    private func layoutIcon() {
        addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        icon.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        icon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        icon.widthAnchor.constraint(equalTo: icon.heightAnchor).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        //icon.centerYAnchor.constraint(equalTo: self.centerYAnchor)
    }

    private func layoutStackView() {
        addSubview(alertStackView)
        alertStackView.translatesAutoresizingMaskIntoConstraints = false
        //alertStackView.topAnchor.constraint(equalTo: icon.topAnchor).isActive = true
        icon.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        alertStackView.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10).isActive = true
        alertStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14).isActive = true
        //alertStackView.bottomAnchor.constraint(equalTo: icon.bottomAnchor).isActive = true
        alertStackView.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
}

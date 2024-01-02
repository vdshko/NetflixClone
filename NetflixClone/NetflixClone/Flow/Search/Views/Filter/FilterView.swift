//
//  FilterView.swift
//  NetflixClone
//
//  Created by Vladyslav Shkodych on 02.01.2024.
//

import UIKit

final class FilterView: UIView {

    // MARK: - UI

    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView.init()
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()
//    private lazy var stackView: UIStackView = {
//        let stackView: UIStackView = UIStackView.init()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//
//        return stackView
//    }()
//    private lazy var stackView: UIStackView = {
//        let stackView: UIStackView = UIStackView.init()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//
//        return stackView
//    }()

    func createHeaderView() -> UIView {
        let screenWidth = UIScreen.main.bounds.width

        // Create the header view
        let headerView = UIView()//(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 320)) // Total height: 20 + 300 = 320

        // Create the stack view
        let stackView = UIStackView()//frame: CGRect(x: 0, y: 0, width: screenWidth, height: 320))
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill

        // Create the first subview with a height of 20
        let view1 = UIView()
        view1.backgroundColor = .blue

        // Create the second subview with a height of 300 initially
        let view2 = UIView()
        view2.backgroundColor = .green


        // Add the subviews to the stack view
        stackView.addArrangedSubview(view1)
        stackView.addArrangedSubview(view2)

        // Add the stack view to the header view
        headerView.addSubview(stackView)

        // Constraints for the stack view to fill the header view
        headerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view2.translatesAutoresizingMaskIntoConstraints = false
        view1.translatesAutoresizingMaskIntoConstraints = false
        let view2HeightConstraint = view2.heightAnchor.constraint(equalToConstant: 300.0)
        NSLayoutConstraint.activate([
            headerView.widthAnchor.constraint(equalToConstant: screenWidth),
            stackView.topAnchor.constraint(equalTo: headerView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            stackView.heightAnchor.constraint(lessThanOrEqualToConstant: 320.0),
            view1.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            view1.heightAnchor.constraint(equalToConstant: 20.0),
            view2.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            view2HeightConstraint,
        ])

        // Hide the longer view part after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {

            UIView.animate(withDuration: 0.3) {
                view2HeightConstraint.constant = 0
                view2.isHidden = true
                headerView.layoutIfNeeded()
//                self.tableView.tableHeaderView = headerView
            }
        }

        return headerView
    }
}

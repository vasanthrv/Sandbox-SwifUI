//
//  LineChartCell.swift
//  TrailApp
//
//  Created by CharismaInfotainment on 14/06/23.
//

import UIKit
import Charts

class LineChartViewCell: UITableViewCell {
    static let identifier = "LineChartViewCell"
    var startDate: String = ""
    var endDate: String = ""
    var typeSelected:String = "year"
    var startDateSelectionHandler: ((Date) -> Void)?
    var endDateSelectionHandler: ((Date) -> Void)?
    var filterButtonHandler: ((String, String) -> Void)?
//    var typeButtonHandler: ((ChartDisplayType) -> Void)?
    
    lazy var startDateButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 3
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Start Date", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 9)
        button.addTarget(self, action: #selector(startDateButtonTapped), for: .touchUpInside)
        //        button.isHidden = true
        
        return button
    }()
    
    lazy var loaderView: LoaderView = {
            let loaderView = LoaderView()
            return loaderView
    }()
    
    lazy var endDateButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 3
        button.setTitleColor(.black, for: .normal)
        button.setTitle("End Date", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 9)
        button.addTarget(self, action: #selector(endDateButtonTapped), for: .touchUpInside)
        //        button.isHidden = true
        
        return button
    }()
    
    lazy var filterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.layer.cornerRadius = 5
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Filter", for: .normal)
        
        button.titleLabel?.font = .systemFont(ofSize: 10)
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        //        button.isHidden = true
        
        return button
    }()
    
    lazy var chartView: UIView = {
        let chartView = UIView()
        // Customize the chart view properties here
        return chartView
    }()
    
    lazy var lineChartView: LineChartView = {
        let lineChart = LineChartView()
        lineChart.backgroundColor = UIColor.white
        lineChart.layer.borderWidth = 1.0
        lineChart.layer.borderColor = UIColor.lightGray.cgColor
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.leftAxis.drawGridLinesEnabled = true
        lineChart.leftAxis.gridColor = UIColor.lightGray
        lineChart.rightAxis.enabled = false
        lineChart.xAxis.granularity = 1
        lineChart.xAxis.labelRotationAngle = 45
//        lineChart.isUserInteractionEnabled = false
        lineChart.legend.enabled = false
        
        
        return lineChart
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        label.font =  .systemFont(ofSize: 20)
        label.text = "Registered Users"
        
        return label
    }()
    
    lazy var yearButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.layer.cornerRadius = 6
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Year", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10)
        button.addTarget(self, action: #selector(yearButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var monthButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.layer.cornerRadius = 6
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Month", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10)
        button.addTarget(self, action: #selector(monthButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var filterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .trailing
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loaderView.startAnimating()
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func filterButtonTapped() {
        loaderView.startAnimating()
        filterButtonHandler?(startDate, endDate)
    }
    
    @objc func yearButtonTapped() {
        // Handle year button tapped event
        yearButton.isSelected = true
        monthButton.isSelected = false
    }
    
    @objc func monthButtonTapped() {
        // Handle month button tapped event
        monthButton.isSelected = true
        yearButton.isSelected = false
    }
    
    @objc func startDateButtonTapped(_ sender: UIButton) {
        // Call the start date selection closure
        startDateSelectionHandler?(Date())
    }
    
    @objc func endDateButtonTapped(_ sender: UIButton) {
        // Call the start date selection closure
        endDateSelectionHandler?(Date())
    }
    private func setupUI() {
        contentView.addSubviews(titleLabel, filterStackView, startDateButton, endDateButton, filterButton, lineChartView, loaderView)
        filterStackView.addArrangedSubviews(yearButton, monthButton)
    }
    
    private func setupConstraints() {
        titleLabel.anchors(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            leadingConstant: 10,
            trailing: contentView.trailingAnchor)
        
        startDateButton.anchors(top: titleLabel.bottomAnchor,
                                topConstant: 10,
                                leading: contentView.leadingAnchor,
                                leadingConstant: 10,
                                widthConstant: 60)
        
        endDateButton.anchors(top: titleLabel.bottomAnchor,
                              topConstant: 10,
                              leading: startDateButton.trailingAnchor,
                              leadingConstant: 5,
                              widthConstant: 60)
        
        filterButton.anchors(top: titleLabel.bottomAnchor,
                             topConstant: 10,
                             leading: endDateButton.trailingAnchor,
                             leadingConstant: 10)
        
        filterStackView.anchors(
            top: titleLabel.bottomAnchor,
            topConstant: 10,
            trailing: contentView.trailingAnchor,
            trailingConstant: 15)
        
        lineChartView.anchors(
            top: startDateButton.bottomAnchor,
            topConstant: 10,
            leading: contentView.leadingAnchor,
            leadingConstant: 10,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            trailingConstant: 10
        )
        
        loaderView.anchors(
                    top: startDateButton.bottomAnchor,
                    topConstant: 10,
                    leading: contentView.leadingAnchor,
                    leadingConstant: 10,
                    bottom: contentView.bottomAnchor,
                    trailing: contentView.trailingAnchor,
                    trailingConstant: 10
                )
    }

    func countRegisteredUsersByMonth(objects: [RegisteredUsersResponse]) -> ([String], [Int]) {
        var months: [String] = []
        var counts: [Int] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        
        for object in objects {
            if let date = dateFormatter.date(from: object.createdAt) {
                let calendar = Calendar.current
                let month = calendar.component(.month, from: date)
                let year = calendar.component(.year, from: date)
                let key = "\(dateFormatter.monthSymbols[month - 1].prefix(3)) \(year)"
                let monthYearKey = String(format: "%04d-%02d", year, month)
                if let existingIndex = months.firstIndex(of: key) {
                    counts[existingIndex] += 1
                } else {
                    months.append(key)
                    counts.append(1)
                }
            }
        }
        return (months, counts)
    }


    func configure(with model: [RegisteredUsersResponse]) {
            let (months, counts) = self.countRegisteredUsersByMonth(objects: model)
            let dataEntries = counts.enumerated().map { (index, count) in
                return ChartDataEntry(x: Double(index), y: Double(count))
            }
            
        if dataEntries.isEmpty {
            // Show the loader and hide the chart view
            loaderView.startAnimating()
            lineChartView.isHidden = true
            contentView.backgroundColor = .white
            contentView.bringSubviewToFront(loaderView)
        } else {
                // Create a line chart data set
                let dataSet = LineChartDataSet(entries: dataEntries, label: "Registered Users")
                dataSet.colors = [UIColor.blue]
                // Create line chart data
                let lineChartData = LineChartData(dataSet: dataSet)
                // Configure the line chart
                lineChartView.data = lineChartData
                lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
                // Refresh the chart view
                lineChartView.notifyDataSetChanged()
                
                // Hide the loader and show the chart view
                if(!dataEntries.isEmpty) {
                    loaderView.stopAnimating()
                }
                lineChartView.isHidden = false
            contentView.bringSubviewToFront(lineChartView)
            }
        }
}

class LoaderView: UIView {
    let loader = UIActivityIndicatorView(style: .large)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLoader()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLoader() {
        addSubview(loader)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loader.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func startAnimating() {
        DispatchQueue.main.async {
            self.isHidden = false // Show the loader view on the main queue
            self.loader.startAnimating()
        }
    }
    
    func stopAnimating() {
        DispatchQueue.main.async {
            self.loader.stopAnimating()
            self.isHidden = true // Hide the loader view on the main queue
        }
    }
}

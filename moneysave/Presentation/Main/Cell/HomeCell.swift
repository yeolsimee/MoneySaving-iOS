//
//  HomeCell.swift
//  moneysave
//
//  Created by Mingoo on 2023/04/10.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import JTAppleCalendar
import SnapKit

protocol HomeCellPtorocol {
    func openRoutineView(title: String, selectDate: Date?)
    func routineDayAPI(data: String)
    func routineDeleteAPI()
    func routineCheckAPI(data: FindRoutineList, date: Date?)
}

class HomeCell: UICollectionViewCell {
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(imageSet: .logo)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var scrollContentsView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var btn_Calendar: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(imageSet: .main_Calendar), for: .normal)
        button.setTitle(" \(Date().toDayTime("yyyy년 MM월"))", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.instance(.pretendardExtraBold, size: 15)
        return button
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(imageSet: .main_CalendarArrow)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var dayLabelView: DayLabelView = {
        let view = DayLabelView()
        return view
    }()
    
    private lazy var dummyView: CalendarDummyView = {
        let view = CalendarDummyView()
        view.isHidden = true
        return view
    }()
    
    private lazy var dummyView_2: RoutineCellDummyView = {
        let view = RoutineCellDummyView()
        view.isHidden = true
        return view
    }()
    
    private lazy var calendarView: JTACMonthView = {
        let view = JTACMonthView(frame: .zero)
        view.backgroundColor = .white
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isScrollEnabled = false
        view.scrollingMode = .stopAtEachSection
        view.scrollDirection = .horizontal
        view.register(CalendarCell.self, forCellWithReuseIdentifier: "CalendarCell")
        return view
    }()
    
    private lazy var dateSelectView: DateSelectView = {
        let view = DateSelectView()
        view.pickerView.delegate = self
        view.pickerView.dataSource = self
        view.isHidden = true
        return view
    }()
    
    private lazy var btn_Expansion: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(imageSet: .main_BottomArrow), for: .normal)
        return button
    }()
    
    private lazy var btn_Add: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(imageSet: .main_Add), for: .normal)
        button.addTarget(self, action: #selector(addAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = Date().toDayTime("MM월 dd일 E요일")
        label.font = UIFont.instance(.pretendardExtraBold, size: 17)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(TableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: "TableViewHeaderView")
        tableView.register(RoutineCell.self, forCellReuseIdentifier: "RoutineCell")
        return tableView
    }()
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var isExpansionSelected: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private var numberRows: CGFloat = 1
    private var yearArray: [String] = []
    private var monthArray: [String] = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    
    private var isFirst: Bool? = false
    private var isScroll: Bool? = false
    private var isFirstOpen: Bool? = true
    private var isSelecteDate: Date?
    private var isYear: String?
    private var isMonth: String?
    
    private var routineDayData: [FindRoutineDayModel] = []
    let calendarEvent: PublishRelay<FindAllRoutineDayModel> = PublishRelay()
    let dayEvent: PublishRelay<FindRoutineDayModel> = PublishRelay()
    
    var calendarData: FindAllRoutinData?
    var delegate: HomeCellPtorocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        configure()
        bind()
        
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        
        calendarEvent
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.calendarData = value.data
                view.updateConfigure()
            })
            .disposed(by: disposeBag)

        dayEvent
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                view.routineDayData.removeAll()
                if value.data.categoryDatas.count > 0 {
                    view.routineDayData.append(value)
                }
                view.tableView.reloadData()
                view.updateTableViewHeight()
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("HomeCell Not implemented required init?(coder: NSCoder)")
    }
}

// MARK: - Func
extension HomeCell {
    func initView() {
        for i in 23 ... 99 {
            yearArray.append("20\(i)")
        }
        
        let firstYear = yearArray.firstIndex(of: Date().toDayTime("yyyy"))!
        isYear = yearArray[firstYear]
        let firstMonth = monthArray.firstIndex(of: Date().toDayTime("MM"))!
        isMonth = monthArray[firstMonth]
    }

    func bind() {
        let firstYear = yearArray.firstIndex(of: isYear!)!
        dateSelectView.pickerView.selectRow(Int(firstYear), inComponent: 0, animated: false)
        let firstMonth = monthArray.firstIndex(of: isMonth!)!
        dateSelectView.pickerView.selectRow(Int(firstMonth), inComponent: 1, animated: false)
        
        isExpansionSelected
            .asObservable()
            .bind(to: btn_Expansion.rx.isSelected)
            .disposed(by: disposeBag)
        
        btn_Expansion.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (view, _) in
                view.isExpansionSelected.accept(!view.isExpansionSelected.value)
                view.btnExpansionAction(state: view.isExpansionSelected.value)
            })
            .disposed(by: disposeBag)
        
        btn_Calendar.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (view, _) in
                if view.isExpansionSelected.value {
                    view.btnCalendarAction()
                }
            })
            .disposed(by: disposeBag)
        
        dateSelectView.cancelRx.tap
            .withUnretained(self)
            .subscribe(onNext: { (view, _) in
                view.dateSelectAction(state: false)
            })
            .disposed(by: disposeBag)
        
        dateSelectView.confirmRx.tap
            .withUnretained(self)
            .subscribe(onNext: { (view, _) in
                view.dateSelectAction(state: true)
            })
            .disposed(by: disposeBag)
    }
    
    func configure() {
        configureViews()
        configureConstraints()
    }
    
    func configureViews() {
        self.backgroundColor = .white
        
        [dummyView,
         dummyView_2,
         scrollView,
         btn_Add].forEach {
            self.addSubview($0)
        }
        
        scrollView.addSubview(scrollContentsView)
        
        [logoImageView,
         contentsView,
         dateSelectView].forEach {
            scrollContentsView.addSubview($0)
        }

        [btn_Calendar,
         arrowImageView,
         dayLabelView,
         calendarView,
         btn_Expansion,
         dateLabel,
         tableView].forEach {
            contentsView.addSubview($0)
        }
    }
    
    func configureConstraints() {
        dummyView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        
        dummyView_2.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        scrollContentsView.snp.makeConstraints { make in
            make.centerX.top.bottom.width.equalToSuperview()
        }
        
        btn_Add.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(20)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(28)
        }
        
        contentsView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
        
        dateSelectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        btn_Calendar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(28)
            make.right.lessThanOrEqualToSuperview().offset(-28)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.left.equalTo(btn_Calendar.snp.right).offset(7)
            make.centerY.equalTo(btn_Calendar.snp.centerY)
        }
        
        dayLabelView.snp.makeConstraints { make in
            make.top.equalTo(btn_Calendar.snp.bottom).offset(11)
            make.left.right.equalToSuperview().inset(22)
        }
        
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(dayLabelView.snp.bottom)
            make.left.right.equalToSuperview().inset(22)
            make.height.equalTo(1)
        }
        
        btn_Expansion.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(btn_Expansion.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(28)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0)
        }
    }
    
    private func btnExpansionAction(state: Bool) {
        if isScroll == nil {
            isScroll = true
        }
        
        if state {
            numberRows = 5
            btn_Expansion.setImage(UIImage(imageSet: .main_TopArrow), for: .selected)
        } else {
            numberRows = 1
            btn_Expansion.setImage(UIImage(imageSet: .main_BottomArrow), for: .normal)
        }
        
        updateConfigure()
    }
    
    private func btnCalendarAction() {
        let year = yearArray.firstIndex(of: isYear!)!
        let month = monthArray.firstIndex(of: isMonth!)!
        dateSelectView.pickerView.selectRow(year, inComponent: 0, animated: false)
        dateSelectView.pickerView.selectRow(month, inComponent: 1, animated: false)
        dateSelectView.dateText = btn_Calendar.titleLabel?.text ?? ""
        dateSelectView.isHidden = false
    }
    
    private func dateSelectAction(state: Bool) {
        if state {
            // 확인
            btn_Calendar.setTitle(" \(isYear!)년 \(isMonth!)월", for: .normal)
            
            isScroll = nil
            
            calendarView.reloadData()
        }
        
        dateSelectView.isHidden = true
    }
    
    private func updateTableViewHeight() {
        tableView.snp.updateConstraints { make in
            if routineDayData.count > 0 {
                let count = routineDayData[0].data.categoryDatas[0].routineDatas.count
                make.height.equalTo(dummyView_2.frame.size.height * CGFloat(count * 2) + 12)
            }
        }
    }
}

// MARK: - Calendar Delegate, DataSource
extension HomeCell: JTACMonthViewDelegate, JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        print("2541 configureCalendar")
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = formatter.date(from: "\(isYear!) \(isMonth!) 01")!
        let endDate = formatter.date(from: "2099 12 31")!
        
        calendar.minimumInteritemSpacing = 0
        calendar.minimumLineSpacing = 0
        
        calendar.selectDates([isSelecteDate ?? Date()], triggerSelectionDelegate: false)
        
        if let _ = isScroll {
            calendar.scrollToDate(isSelecteDate ?? Date(), animateScroll: false)
        }
        
        if numberRows == 5 {
            return ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: Int(numberRows), firstDayOfWeek: .monday)
        } else {
            return ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: Int(numberRows), generateInDates: .forAllMonths, generateOutDates: .tillEndOfGrid, firstDayOfWeek: .monday, hasStrictBoundaries: false)
        }
    }
    
    func sizeOfDecorationView(indexPath: IndexPath) -> CGRect {
        let stride = calendarView.frame.width * CGFloat(indexPath.section)
        return CGRect(x: stride + 5, y: 5, width: calendarView.frame.width - 10, height: calendarView.frame.height - 10)
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        // 클릭
        delegate?.routineDayAPI(data: cellState.date.toDayTime("yyyyMMdd"))
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        return true
    }
    
    private func configureCell(view: JTACDayCell?, cellState: CellState) {
        guard let cell = view as? CalendarCell  else { return }
        handleCellTextColor(cell: cell, cellState: cellState)
    }
    
    private func handleCellTextColor(cell: CalendarCell, cellState: CellState) {
        cell.title = cellState.text
        cell.textColor = .gray
        cell.textFont = UIFont.instance(.pretendardMedium, size: 10)
        cell.underHidden = true
        
        if cellState.dateBelongsTo == .thisMonth {
            // 현재 월
            cell.textColor = .black
            cell.img = UIImage(imageSet: .calendar_none)
            
            if let data = calendarData {
                for i in data.routineDays {
                    if cellState.date.toDayTime("yyyyMMdd") == i.day {
                        if i.routineAchievement == "BRONZE" {
                            cell.img = UIImage(imageSet: .calendar_yet)
                        } else if i.routineAchievement == "YET" {
                            cell.img = UIImage(imageSet: .calendar_none)
                        } else {
                            cell.img = UIImage(named: "calendar_\(i.routineAchievement.lowercased())")
                        }
                    }
                }
            }
            
            if cellState.date.toDayTime() == Date().toDayTime() {
                cell.img = UIImage(imageSet: .calendar_today)
            }
            
        } else {
            cell.img = UIImage(imageSet: .calendar_past)
        }
        
        if cellState.isSelected {
            dateLabel.text = cellState.date.toDayTime("MM월 dd일 E요일")
            cell.textFont = UIFont.instance(.pretendardExtraBold, size: 10)
            isSelecteDate = cellState.date.toDateTime()
            cell.underHidden = false
        }
        
    }
    
    private func updateConfigure() {
        DispatchQueue.main.async { [weak self] in
            self?.calendarView.snp.updateConstraints({ make in
                make.height.equalTo((self?.dummyView.frame.size.height)! * (self?.numberRows)!)
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let date = self?.isSelecteDate ?? Date()
                self?.isYear = date.toDayTime("yyyy")
                self?.isMonth = date.toDayTime("MM")
                
                self?.btn_Calendar.setTitle(" \(date.toDayTime("yyyy년 MM월"))", for: .normal)
                self?.calendarView.layoutIfNeeded()
                self?.calendarView.reloadData()
                self?.calendarView.scrollToDate(date, animateScroll: false)
            }
        }
    }
}

// MARK: - Picker Delegate, Datasource
extension HomeCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return yearArray.count
        } else {
            return monthArray.count
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return yearArray[row]
        } else {
            return monthArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            isYear = yearArray[row]
        } else {
            isMonth = monthArray[row]
        }
        
        dateSelectView.dateText = " \(isYear!)년 \(isMonth!)월"
    }
}

// MARK: TableView Delegate, DataSource
extension HomeCell: UITableViewDelegate, UITableViewDataSource, RoutinCellProtocol {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        
        if routineDayData.count > 0 {
            header.backgroundConfiguration?.backgroundColor = .white
        } else {
            header.backgroundConfiguration?.backgroundColor = .clear
        }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Section 생성
        if routineDayData.count > 0 {
            return routineDayData[0].data.categoryDatas.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableViewHeaderView") as! TableViewHeaderView
        
        if routineDayData.count > 0 {
            header.titleLabel.text = routineDayData[0].data.categoryDatas[section].categoryName
            return header
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Section 안 Row 생성
        if routineDayData.count > 0 {
            tableView.isScrollEnabled = true
            tableView.restore()
            return routineDayData[0].data.categoryDatas[section].routineDatas.count
            
        } else {
            tableView.isScrollEnabled = false
            tableView.setEmptyView(page: nil)
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoutineCell") as! RoutineCell
        
        let data = self.routineDayData[0].data.categoryDatas[indexPath.section].routineDatas[indexPath.row]
        
        cell.selectionStyle = .none
        
        cell.data = data
        
        cell.delegate = self
        
        cell.timeLabel.text = Int(data.routineTimeZone)!.toTimeZone()
        
        let alarmStatus = data.alarmStatus == "ON" ? false : true
        cell.alamView.isHidden = alarmStatus
        
        if !alarmStatus {
            let date = data.alarmTimeHour + ":" + data.alarmTimeMinute

            cell.alamLabel.text = date.toDateFormat(format: "HH:mm", changeFormat: "a hh:mm")
        }
        
        if data.routineCheckYN == "Y" {
            cell.titleLabel.attributedText = data.routineName.strikeThrough()
            cell.titleLabel.textColor = .black
            cell.roundView.backgroundColor = UIColor(colorSet: .Gray_240)
            cell.roundView.layer.borderColor = UIColor.black.cgColor
            cell.btn_Check.setImage(UIImage(imageSet: .routine_OnCheck), for: .normal)
        } else {
            cell.titleLabel.attributedText = nil
            cell.titleLabel.text = data.routineName
            cell.titleLabel.textColor = UIColor(colorSet: .Gray_153)
            cell.roundView.backgroundColor = .white
            cell.roundView.layer.borderColor = UIColor(colorSet: .Gray_153)?.cgColor
            cell.btn_Check.setImage(UIImage(imageSet: .routine_NonCheck), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
            let data = self?.routineDayData[0].data.categoryDatas[indexPath.section].routineDatas[indexPath.row]
            
            if let id = data?.routineId {
                UserInfo.routineId = "\(id)"
                self?.delegate?.routineDeleteAPI()
            }
            completion(true)
        }
        
        deleteAction.backgroundColor = .red
        deleteAction.image = UIImage(imageSet: .trash)
        deleteAction.title = nil
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

    @objc func addAction(_ sender: UIButton) {
        delegate?.openRoutineView(title: I18NStrings.Routine.add, selectDate: isSelecteDate)
    }
    
    func contentAction() {
        delegate?.openRoutineView(title: I18NStrings.Routine.edit, selectDate: nil)
    }
    
    func checkAction(data: FindRoutineList) {
        delegate?.routineCheckAPI(data: data, date: isSelecteDate)
    }
    
}

//
//  AlarmListViewModel.swift
//  GiftWallet
//
//  Created by Baem on 2023/04/22.
//

import Foundation

class AlarmListViewModel {
    var alarms = [AlarmModel]()
    var filteredAlarm: Observable<[AlarmModel]> = .init([])
    
    init() {
        setupInitAlarmData()
    }
    
    func filterAlarm(type: AlarmType) {
        filteredAlarm.value = alarms.filter { $0.notiType == type }
    }
    
    func filterAllData() {
        filteredAlarm.value = alarms
    }
    
    func createDetailGiftDatas(indexRow: Int) -> [Gift]? {
        guard let array = alarms[indexRow].numbers else { return nil }
        
        var gifts: [Gift]?
        
        switch CoreDataManager.shared.fetchData(of: array) {
            case .success(let data):
                gifts = data
            case .failure(let error):
                print(error.localizedDescription)
        }
        
        return gifts
    }
    
    private func setupInitAlarmData() {
        switch AlarmCoreDataManager.shared.fetchData() {
            case .success(let data):
                alarms = data
                
                do {
                    try sortAlarms()
                } catch {
                    print(error.localizedDescription)
                }
                
                filterAllData()
            case .failure(let error):
                print(error.localizedDescription)
        }
    }
    
    private func sortAlarms() throws {
        try alarms.sort {
            guard let firstDate = $0.date,
               let secondDate = $1.date else {
                throw AlarmListError.notHaveDate
            }
            
            return firstDate > secondDate
        }
        
        alarms = try alarms.filter {
            guard let date = $0.date else {
                throw AlarmListError.notHaveDate
            }
            
            let bool = isWithinDays(from: date, dueDay: 30)
            
            return bool
        }
    }
    
    private func isWithinDays(from targetDate: Date, dueDay: Int) -> Bool {
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: currentDate, to: targetDate)
        
        guard let days = components.day else {
            return false
        }
        
        if days <= dueDay && days < .zero {
            return true
        }
        
        if currentDate > targetDate {
            return true
        }
        
        return false
    }
}

enum AlarmListError: Error {
    case notHaveDate
}

//
//  CycleComponent.swift
//  paycycle
//
//  Created by Victor Castro on 15/12/22.
//

import SwiftUI

struct CycleModel: Hashable {
    let label: String
    let dateStart: Date
    let dateFinish: Date
    let datePay: Date
}

struct CycleComponent: View {
    
    var cycle: CCCycleEntity
    
    private let formatter = DateFormatter()
    
    private var subcycles: [CycleModel] {
        
        let parseStrategy = Date.ParseStrategy(format: "\(day: .twoDigits)-\(month: .twoDigits)-\(year: .defaultDigits)", timeZone: .current)
        
        let currentYear = Date().formatted(.dateTime.year())
        let currentMonth = Date().formatted(.dateTime.month(.twoDigits))
        let currentDay = Date().formatted(.dateTime.day())
        
        let datePay = try? Date("\(cycle.dayPay)-\(Int(currentMonth)! + 1)-\(currentYear)", strategy: parseStrategy)
        let dateFinish = try? Date("\(cycle.dayFinish)-\(currentMonth)-\(currentYear)", strategy: parseStrategy)
        let dateStart = try? Date("\(cycle.dayStart)-\(Int(currentMonth)! - 1)-\(currentYear)", strategy: parseStrategy)
        
        if (Int(currentDay)! > cycle.dayPay && Date.now > dateFinish!) {
            let datePay2 = try? Date("\(cycle.dayPay)-\(Int(currentMonth)! + 2)-\(currentYear)", strategy: parseStrategy)
            let dateFinish2 = try? Date("\(cycle.dayFinish)-\(Int(currentMonth)! + 1)-\(currentYear)", strategy: parseStrategy)
            let dateStart2 = try? Date("\(cycle.dayStart)-\(currentMonth)-\(currentYear)", strategy: parseStrategy)
            
            return [
                CycleModel(label: cycle.label!, dateStart: dateStart!, dateFinish: dateFinish!, datePay: datePay!),
                CycleModel(label: cycle.label!, dateStart: dateStart2!, dateFinish: dateFinish2!, datePay: datePay2!)
            ]
        }
        
        return [
            CycleModel(label: cycle.label!, dateStart: dateStart!, dateFinish: dateFinish!, datePay: datePay!)
        ]
    }
    
    private func labelSubCycle(cycle: CycleModel) -> Text {
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd MMM"
        
        return Text("Ciclo \(formatter.string(from: cycle.dateStart)) - \(formatter.string(from: cycle.dateFinish))").font(.system(.callout)).fontWeight(.bold)
    }
    
    private func textDate(date: Date) -> Text {
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd MMM"
        
        return Text(formatter.string(from: date))
    }
    
    
    var body: some View {
        VStack(spacing: 20) {
            Text(cycle.label!).font(.system(.title))
            ForEach(subcycles, id: \.self) { subcycle in
                VStack {
                    VStack(alignment: .leading, spacing: 5) {
                        labelSubCycle(cycle: subcycle)
                        HStack {
                            Text("Inicio")
                            Spacer()
                            Text("Cierre")
                            Spacer()
                            Text("Pago")
                        }
                        
                        Section() {
                            GeometryReader { geometry in
                                HStack(spacing: 0.0) {
                                    Section() {
                                        GeometryReader { g1 in
                                            Rectangle().fill(.green).frame(width: g1.size.width * 0.90)
                                        }
                                    }
                                    Section() {
                                        GeometryReader { g2 in
                                            Rectangle().fill(.red).frame(width: g2.size.width * 0.0)
                                        }
                                    }
                                }
                                .frame(width: geometry.size.width)
                                .background(.gray)
                            }
                        }.frame(height: 8)
                    }
                    
                    HStack {
                        textDate(date: subcycle.dateStart)
                        Spacer()
                        textDate(date: subcycle.dateFinish)
                        Spacer()
                        textDate(date: subcycle.datePay)
                    }
                    
                }
            }
        }
    }
}

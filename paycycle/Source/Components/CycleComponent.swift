//
//  CycleComponent.swift
//  paycycle
//
//  Created by Victor Castro on 15/12/22.
//

import SwiftUI

struct Cycle: Hashable {
    let id: String
    let label: String
    let dayStart: Date
    let dayFinish: Date
    let dayPay: Date
}

struct CycleComponent: View {
    
    var cycle: Cycle
    
    private let formatter = DateFormatter()
   
    private var subcycles: [Cycle] {
        print(cycle.dayFinish, Date.now)
        // if (Date.now >= cycle.dayFinish && Date.now <= cycle.dayPay ) {
            
            let newDayStart = Calendar.current.date(byAdding: .month, value: -1, to: cycle.dayStart)!
            let cycleInDays = Calendar.current.dateComponents([.day], from: cycle.dayStart, to: cycle.dayFinish)
            let diffCycleDays = Calendar.current.dateComponents([.day], from: cycle.dayStart, to: Date.now)
        (cycleInDays.day!, diffCycleDays.day!)
            
            return [
                Cycle(id: "001", label: "", dayStart: newDayStart, dayFinish: cycle.dayFinish, dayPay: cycle.dayPay),
                cycle
            ]
//        }
//
//        return [
//            cycle
//        ]
    }
    
    private func labelSubCycle(cycle: Cycle) -> Text {
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd MMM"
        
        return Text("Ciclo \(formatter.string(from: cycle.dayStart)) - \(formatter.string(from: cycle.dayFinish))").font(.system(.callout)).fontWeight(.bold)
    }
    
    private func textDate(date: Date) -> Text {
        
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd MMM"
        
        return Text(formatter.string(from: date))
    }
    
    
    var body: some View {
        VStack(spacing: 20) {
            Text(cycle.label).font(.system(.title))
            ForEach(subcycles, id: \.id) { subcycle in
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
                        textDate(date: subcycle.dayStart)
                        Spacer()
                        textDate(date: subcycle.dayFinish)
                        Spacer()
                        textDate(date: subcycle.dayPay)
                    }
                    
                }
            }
            
        }
        
    }
    
}

struct CycleComponent_Previews: PreviewProvider {
    static var previews: some View {
        CycleComponent(cycle: Cycle(id: "A001", label: "Banco BCP", dayStart: Date.now, dayFinish: Date.now, dayPay: Date.now))
            .previewLayout(.sizeThatFits)
    }
}

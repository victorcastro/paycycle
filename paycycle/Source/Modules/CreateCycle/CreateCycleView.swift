//
//  CreateCycleView.swift
//  paycycle
//
//  Created by Victor Castro on 16/12/22.
//

import SwiftUI

struct CreateCycleView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var cycles: FetchedResults<CCCycleEntity>
    
    @State private var label = ""
    @State private var dStart: Int?
    @State private var dFinish: Int?
    @State private var dPay: Int?
    
    private var days: [String] {
        var r: [String] = []
        for num in 1...25 {
            r.append("\(num)")
        }
        
        return r
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Nombre: ")
                TextField("", text: $label).textFieldStyle(.roundedBorder)
            }
            HStack {
                Text("Fecha de inicio: ")
                Spacer()
                PickerTextField(data: days, placeholder: "", lastSelectedIndex: $dStart).frame(width: 60, height: 40)
            }
            HStack {
                Text("Fecha de fin: ")
                Spacer()
                PickerTextField(data: days, placeholder: "", lastSelectedIndex: $dFinish).frame(width: 60, height: 40)
            }
            HStack {
                Text("Fecha de pago: ")
                Spacer()
                PickerTextField(data: days, placeholder: "", lastSelectedIndex: $dPay).frame(width: 60, height: 40)
            }
            Spacer()
            Button(action: saveCycle) {
                Text("Guardar")
            }
        }.padding(.horizontal)
    }
    
    private func saveCycle() {
        
        if let dStart = self.dStart, let dFinish = self.dFinish, let dPay = self.dPay {
            
            let cycle = CCCycleEntity(context: context)
            cycle.label = label
            cycle.dayStart = Int16(days[dStart])!
            cycle.dayFinish = Int16(days[dFinish])!
            cycle.dayPay = Int16(days[dPay])!
            cycle.order = Int16(cycles.last?.order ?? 0 + 1)
            cycle.timestamp = Date()
            
            try? self.context.save()
            dismiss()
        }
    }
}

struct CreateCycleView_Previews: PreviewProvider {
    static var previews: some View {
        CreateCycleView()
    }
}

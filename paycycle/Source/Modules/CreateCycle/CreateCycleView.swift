//
//  CreateCycleView.swift
//  paycycle
//
//  Created by Victor Castro on 16/12/22.
//

import SwiftUI

struct CreateCycleView: View {
    
    @Environment(\.managedObjectContext) var context
    
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
                PickerTextField(data: days, placeholder: "", lastSelectedIndex: $dStart)
            }
            HStack {
                Text("Fecha de fin: ")
                PickerTextField(data: days, placeholder: "", lastSelectedIndex: $dFinish)
            }
            HStack {
                Text("Fecha de pago: ")
                PickerTextField(data: days, placeholder: "", lastSelectedIndex: $dPay)
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
            print(cycle)
            
            try? self.context.save()
        }
    }
}

struct CreateCycleView_Previews: PreviewProvider {
    static var previews: some View {
        CreateCycleView()
    }
}

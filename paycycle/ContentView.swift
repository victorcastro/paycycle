//
//  ContentView.swift
//  paycycle
//
//  Created by Victor Castro on 15/12/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    //    @FetchRequest(
    //        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    //        animation: .default)
    
    @FetchRequest(entity: CCCycleEntity.entity(), sortDescriptors: []) var cycles: FetchedResults<CCCycleEntity>
    
    //    @FetchRequest(
    //        sortDescriptors: [NSSortDescriptor(keyPath: \CycleEntity.id, ascending: true)],
    //        animation: .default)
    
    
    // private var items: FetchedResults<Item>
    //    private var cycles: FetchedResults<CycleEntity>
    
    //    private var cycles: [Cycle] {
    //        let fmt = DateFormatter()
    //        fmt.locale = Locale(identifier: "en_US_POSIX")
    //        fmt.dateFormat = "yyyy-MM-dd"
    //
    //        return [
    //            Cycle(id: "001", label: "BCO", dayStart: fmt.date(from: "2022-12-12")!, dayFinish: fmt.date(from: "2023-01-11")!, dayPay: fmt.date(from: "2023-02-05")!),
    //            Cycle(id: "002", label: "BVA", dayStart: fmt.date(from: "2022-11-19")!, dayFinish: fmt.date(from: "2022-12-18")!, dayPay: fmt.date(from: "2023-01-06")!)
    //        ]
    //    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                DayComponent().padding(.horizontal)
                
                List {
                    ForEach(cycles, id: \.id) { c in
                        CycleComponent(cycle: c).padding(.horizontal)
                    }
                    .onDelete(perform: deleteCycles)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        NavigationLink(destination: CreateCycleView()) {
                            Label("Add Item", systemImage: "plus")
                        }
                        
                    }
                }.listStyle(.plain)
            }.navigationBarTitle("Home", displayMode: .inline)
        }
    }
    
    private func addItem() {
        withAnimation {
            
            
            
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteCycles(offsets: IndexSet) {
        withAnimation {
            offsets.map { cycles[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

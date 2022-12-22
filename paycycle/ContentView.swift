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
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.dayPay)]) var cycles: FetchedResults<CCCycleEntity>
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                DayComponent().padding(.horizontal)
                
                List {
                    ForEach(cycles) { c in
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

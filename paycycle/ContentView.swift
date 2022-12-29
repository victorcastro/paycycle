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
    
    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \CCCycleEntity.order, ascending: false)
    ]) var cycles: FetchedResults<CCCycleEntity>
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                DayComponent().padding(.horizontal)
                
                List {
                    ForEach(cycles) { c in
                        CycleComponent(cycle: c).padding(.horizontal)
                    }
                    .onDelete(perform: deleteCycles)
                    .onMove(perform: moveCycles)
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
            }
        }
    }
    
    private func moveCycles(from source: IndexSet, to destination: Int) {
        // Make an array of items from fetched results
        var revisedItems: [CCCycleEntity] = cycles.map { $0 }
        
        // change the order of the items in the array
        revisedItems.move(fromOffsets: source, toOffset: destination)
        
        // update the userOrder attribute in revisedItems to
        // persist the new order. This is done in reverse order
        // to minimize changes to the indices.
        for reverseIndex in stride(from: revisedItems.count - 1, through: 0, by: -1) {
            cycles[reverseIndex].order = Int16(reverseIndex)
        }
        
        try? viewContext.save()
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

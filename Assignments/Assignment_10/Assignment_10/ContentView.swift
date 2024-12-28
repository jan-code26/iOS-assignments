import CoreData
import SwiftUI

class TabBarViewModel: ObservableObject {
    @Published var isVisible: Bool = true
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject private var tabBarViewModel = TabBarViewModel()
    
    var body: some View {
        VStack {
            if tabBarViewModel.isVisible {
                TabView {
                    Customers()
                        .tabItem {
                            Label("Customers", systemImage: "person.fill")
                        }
                        .tag(0)
                    Policies()
                        .tabItem {
                            Label("Policies", systemImage: "scroll.fill")
                        }
                        .tag(1)
                }
            }
//            Button(action: {
//                tabBarViewModel.isVisible.toggle()
//            }) {
//                Text(tabBarViewModel.isVisible ? "Hide TabView" : "Show TabView")
//            }
        }
        .onAppear {
            loadDataIfNeeded()
        }
        
    }
    
    private func loadDataIfNeeded() {
        let dataLoadedKey = "dataLoaded"
        let userDefaults = UserDefaults.standard
        
        if !userDefaults.bool(forKey: dataLoadedKey) {
            APIUtils.getAllCustomerDetails(context: context)
            APIUtils.getAllInsuranceDetails(context: context)
            userDefaults.set(true, forKey: dataLoadedKey)
            do {
                try context.save()
                print("saved")
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}

#Preview {
    ContentView()
}

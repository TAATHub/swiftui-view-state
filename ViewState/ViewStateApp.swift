import SwiftUI

@main
struct ViewStateApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                List {
                    Section("As-is") {
                        NavigationLink("List view sample") {
                            CurrentViewStateListView()
                        }
                    }
                    
                    Section("To-be") {
                        NavigationLink("List view sample") {
                            NewViewStateListView()
                        }
                        
                        NavigationLink("Simple view sample") {
                            NewViewStateSimpleView()
                        }
                    }
                }
            }
        }
    }
}

//
//  Main.swift
//  Mythic
//
//  Created by Esiayo Alegbe on 8/9/2023.
//
//  Reference
//  https://github.com/1998code/SwiftUI2-MacSidebar
//

import SwiftUI
import Foundation
import OSLog

/*
 colors:
 gradient 1: #4800FF
 midpoint: #7318E0
 gradient 2: #9D30C1
*/

struct MainView: View {
    
    @State private var isAuthViewPresented: Bool = false
    
    @State private var epicUserAsync: String = "Loading..."
    @State private var signedIn: Bool = false
    
    @State private var appVersion: String = ""
    @State private var buildNumber: Int = 0
    
    func updateLegendaryAccountState() {
        epicUserAsync = "Loading..."
        DispatchQueue.global(qos: .userInitiated).async {
            let whoAmIOutput = Legendary.whoAmI()
            DispatchQueue.main.async { [self] in
                signedIn = Legendary.signedIn()
                epicUserAsync = whoAmIOutput
            }
        }
    }
    
    init() { updateLegendaryAccountState() }

    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: WelcomeView()) {
                    Label("Welcome", systemImage: "star")
                }
                
                Spacer()
                
                Text("DASHBOARD")
                    .font(.system(size: 10))
                    .fontWeight(.bold)
                
                Group{
                    NavigationLink(destination: HomeView()) {
                        Label("Home", systemImage: "house")
                    }
                    NavigationLink(destination: LibraryView()) {
                        Label("Library", systemImage: "books.vertical")
                    }
                    NavigationLink(destination: StoreView()) {
                        Label("Store", systemImage: "basket")
                    }
                }
                
                Spacer()
                
                Text("MANAGEMENT")
                    .font(.system(size: 10))
                    .fontWeight(.bold)
                
                Group {
                    NavigationLink(destination: WineView()) {
                        Label("Wine", systemImage: "wineglass")
                    }
                    NavigationLink(destination: SettingsView()) {
                        Label("Settings", systemImage: "gear")
                    }
                    NavigationLink(destination: SupportView()) {
                        Label("Support", systemImage: "questionmark.bubble")
                    }
                }
                
                Spacer()
                
                Divider()
                
                HStack {
                    Image(systemName: "person")
                        .foregroundStyle(.accent)
                    Text(epicUserAsync)
                        .onAppear {
                            updateLegendaryAccountState()
                        }
                }
                
                if epicUserAsync != "Loading..." {
                    if signedIn {
                        Button(action: {
                            let command = Legendary.command(args: ["auth", "--delete"], useCache: false)
                            if let commandStderrString = String(data: command.stderr, encoding: .utf8), commandStderrString.contains("User data deleted.") {
                                updateLegendaryAccountState()
                            }
                        }) {
                            HStack {
                                Image(systemName: "person.slash")
                                    .foregroundStyle(.accent)
                                Text("Sign Out")
                            }
                        }
                    } else {
                        Button(action: {
                            NSWorkspace.shared.open(URL(string: "http://legendary.gl/epiclogin")!)
                            isAuthViewPresented = true
                        }) {
                            HStack {
                                Image(systemName: "person")
                                    .foregroundStyle(.accent)
                                Text("Sign In")
                            }
                        }
                    }
                }
                
                if let displayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String,
                   let shortVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
                   let bundleVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
                    Text("\(displayName) \(shortVersion) (\(bundleVersion))")
                        .font(.footnote)
                        .foregroundStyle(.placeholder)
                }
            }
            
            .sheet(isPresented: $isAuthViewPresented) {
                AuthView(isPresented: $isAuthViewPresented)
                    .onDisappear {
                        updateLegendaryAccountState()
                    }
            }
            
            .listStyle(SidebarListStyle())
            .frame(minWidth: 150, idealWidth: 250, maxWidth: 300)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: toggleSidebar, label: {
                        Image(systemName: "sidebar.left")
                    })
                }
            }
            
            WelcomeView()
        }
    }
}

// Wrapper instead of manually doing NavigationLink
/*
extension View {
    func NavigationLinkWrapper(label: String, systemImage: String) -> some View {
        NavigationLink(destination: getViewForLabel(label)) {
            Label(label, systemImage: systemImage)
        }
    }
    
    func getViewForLabel(_ label: String) -> some View {
        let viewName = label + "View"
        if let viewType = NSClassFromString(viewName) as? any View.Type {
            return AnyView(viewType()) // womp womp
        } else {
            return AnyView(Text("Unknown View"))
        }
    }
}
*/

func toggleSidebar() {
    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

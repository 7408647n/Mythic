//
//  GameSettings.swift
//  Mythic
//
//  Created by Esiayo Alegbe on 28/9/2023.
//

// MARK: - Copyright
// Copyright © 2023 blackxfiied, Jecta

// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
// You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

// You can fold these comments by pressing [⌃ ⇧ ⌘ ◀︎], unfold with [⌃ ⇧ ⌘ ▶︎]

import SwiftUI
import SwiftyJSON

extension GameListView {
    // MARK: - SettingsView
    /// An extension of the `GameListView` that defines the `SettingsView` SwiftUI view for game settings.
    struct SettingsView: View {
        
        // MARK: - Bindings
        @Binding var isPresented: Bool
        @Binding var game: Game
        @Binding var gameThumbnails: [String: String]
        
        // MARK: - Variables
        public var game: Game
        
        // MARK: - Body View
        var body: some View {
            VStack {
                Text(game.title)
                    .font(.title)
                
                Spacer()
                
                HStack {
                    Button {
                        isPresented = false
                    } label: {
                        Text("Close")
                    }
                }
            }
            .padding()
            .fixedSize()
        }
    }
}

// MARK: - Preview
#Preview {
    GameListView.SettingsView(
        isPresented: .constant(true),
        game: .constant(.init(isLegendary: true, title: "Game", appName: "[AppName]", platform: .macOS, imageURL: URL(string: "https://cdn1.epicgames.com/ut/item/ut-39a5fa32c5534e0eabede7b732ca48c8-1288x1450-9a43b56b492819d279855ae612ad85cd-1288x1450-9a43b56b492819d279855ae612ad85cd.png"))),
        gameThumbnails: .constant(.init())
    )
}

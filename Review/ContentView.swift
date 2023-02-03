//
//  ContentView.swift
//  Review
//
//  Created by 茅根啓介 on 2023/02/03.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var setting: SettingObject
    @FocusState var isFocused: Field?
    @State var isAddingWord = false
    @State var newWord = ""
    @State var isAddingSite = false
    @State var newURL = ""
    @State var isShowingAlert = false
    @State var isShowingWordAlert = false
    @State var isShowingURLAlert = false
    
    enum Field: Hashable {
        case word
        case URL
        case displayed
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    ForEach(0..<setting.words.count, id: \.self){ num in
                        Text(setting.words[num])
                            .swipeActions(edge: .leading, allowsFullSwipe: false, content: {
                                Button(action: {
                                    setting.words.remove(at: num)
                                }) {
                                    Label("Remove This Word", systemImage: "trash")
                                }
                                .tint(.red)
                            })
                            .contextMenu {
                                Button(action: {
                                    setting.words.remove(at: num)
                                }) {
                                    Label("Remove This Word", systemImage: "trash")
                                }
                            }
                    }
                    
                    Group {
                        switch isAddingWord {
                        case true:
                            TextField("Adding Words Now", text: $newWord)
#if os(iOS)
                                .textInputAutocapitalization(.none)
#endif
                                .autocorrectionDisabled(true)
                                .focused($isFocused, equals: .word)
                                .onSubmit{
                                    if newWord != "" {
                                        setting.words.append(newWord)
                                        newWord = ""
                                    }
                                    isAddingWord = false
                                }
                        default:
                            Button(action: {
                                isAddingWord = true
                                isFocused = .word
                            }) {
                                Text("Add Words")
                            }
                        }
                    }
                } header: {
                    Text("Blocked Words")
                }
                
                Section {
                    ForEach(0..<setting.URLs.count, id: \.self){ num in
                        Text(setting.URLs[num])
                            .swipeActions(edge: .leading, allowsFullSwipe: false, content: {
                                Button(action: {
                                    setting.URLs.remove(at: num)
                                }) {
                                    Label("Remove This Sites", systemImage: "trash")
                                }
                                .tint(.red)
                            })
                            .contextMenu {
                                Button(action: {
                                    setting.URLs.remove(at: num)
                                }) {
                                    Label("Remove This Sites", systemImage: "trash")
                                }
                            }
                    }
                    
                    Group {
                        switch isAddingSite {
                        case true:
                            TextField("Adding Sites Now", text: $newURL)
#if os(iOS)
                                .textInputAutocapitalization(.none)
#endif
                                .autocorrectionDisabled(true)
                                .focused($isFocused, equals: .URL)
                                .onSubmit{
                                    if newURL != "" {
                                        setting.URLs.append(newURL)
                                        newURL = ""
                                    }
                                    isAddingSite = false
                                }
                        default:
                            Button(action: {
                                isAddingSite = true
                                isFocused = .URL
                            }) {
                                Text("Add Sites not Converting")
                            }
                        }
                    }
                } header: {
                    Text("Sites not Converting")
                }
                
                Section {
                    TextField("Word", text: $setting.displayedWord)
#if os(iOS)
                                .textInputAutocapitalization(.none)
#endif
                                .autocorrectionDisabled(true)
                                .focused($isFocused, equals: .displayed)
                                .onSubmit{
                                    if setting.displayedWord == "" {
                                        setting.displayedWord = setting.defaultDisplayedWord
                                    }
                                    isFocused = nil
                                }
                } header: {
                    Text("Text to be Displayed")
                }
                
                Section {
                    Button(action: {
                        isShowingWordAlert = true
                    }) {
                        Label("Delete All Words", systemImage: "exclamationmark.arrow.triangle.2.circlepath")
                            .foregroundColor(.red)
                    }
                    
                    Button(action: {
                        isShowingURLAlert = true
                    }) {
                        Label("Delete All URLs", systemImage: "exclamationmark.arrow.triangle.2.circlepath")
                            .foregroundColor(.red)
                    }
                }
                
                Section {
                    Button(action: {
                        isShowingAlert = true
                    }) {
                        Label("Reset All Settings", systemImage: "exclamationmark.arrow.triangle.2.circlepath")
                            .foregroundColor(.red)
                    }
                }
            }
            .alert("Reset all settings to default?", isPresented: $isShowingAlert){
                Button("Reset", role: .destructive){
                    setting.reset()
                }
            } message: {
                Text("Once settings are reset, they cannot be fully restored.")
            }
            .alert("Do you want to remove all blocked words?", isPresented: $isShowingWordAlert){
                Button("Remove", role: .destructive){
                    setting.resetWords()
                }
            } message: {
                Text("Once a word is deleted, it cannot be restored from the application.")
            }
            .alert("Do you want to remove all URLs?", isPresented: $isShowingURLAlert){
                Button("Remove", role: .destructive){
                    setting.resetURLs()
                }
            } message: {
                Text("Once a url is deleted, it cannot be restored from the application.")
            }
            .formStyle(.grouped)
            .navigationTitle("Settings")
#if os(iOS)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Done")
                    }
                }
            }
#endif
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SettingObject())
    }
}

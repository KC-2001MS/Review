//
//  SettingObject.swift
//  Hiyoko
//
//  Created by 茅根啓介 on 2023/01/23.
//

import Foundation

let keyValueStore = NSUbiquitousKeyValueStore.default

final class SettingObject: ObservableObject {
    //通知
    let  notification = NotificationCenter.default.publisher(for: NSUbiquitousKeyValueStore.didChangeExternallyNotification).receive(on: RunLoop.main)
    
    let defaultWords: Array<String> = []
    
    let defaultURLs: Array<String> = []
    
    let defaultDisplayedWord: String = NSLocalizedString("Peep🐤", comment: "")
    
    //設定可能な値
    @Published var words: Array<String> {
        didSet {
            keyValueStore.set(words, forKey: "Word")
        }
    }
    
    @Published var URLs: Array<String> {
        didSet {
            keyValueStore.set(URLs, forKey: "URL")
        }
    }
    
    @Published var displayedWord: String {
        didSet {
            keyValueStore.set(displayedWord, forKey: "Displayed")
        }
    }
    //イニシャライザ
    init() {
        //基本設定
        words = keyValueStore.array(forKey: "Word") as? Array<String> ?? defaultWords
        URLs = keyValueStore.array(forKey: "URL") as? Array<String> ?? defaultURLs
        displayedWord = keyValueStore.string(forKey: "Displayed") ?? defaultDisplayedWord
    }
    //iCloudから設定をロード
    func load() {
        //基本設定
        words = keyValueStore.array(forKey: "Word") as? Array<String> ?? defaultWords
        URLs = keyValueStore.array(forKey: "URL") as? Array<String> ?? defaultURLs
        displayedWord = keyValueStore.string(forKey: "Displayed") ?? defaultDisplayedWord
    }
    //基本設定のリセット
    func resetWords() {
        words = []
    }
    
    func resetURLs() {
        URLs = []
    }
    
    func reset() {
        words = []
        URLs = []
        displayedWord = defaultDisplayedWord
    }
}


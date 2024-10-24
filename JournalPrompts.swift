//
//  JournalTemplate.swift
//  Saga
//
//  Created by Stavan Gandhi on 7/31/22.
//

import SwiftUI

struct Prompts: Identifiable, Decodable {
    var id: Int
    
    var prompt: String
    var entry: String?
    
    var timeType: String    //   timeType : Day, Week, Month, Year
    var category: String
}

struct JournalTemplate: View {
    @State private var journalPrompts: [Prompts] = load("JournalPrompt.json")
    @State private var selectedJournalPrompts: [Prompts] = []
    
    @Binding var string: String
    @Binding var showTempleteSheet: Bool
    
    
    var body: some View{
        HStack{
            VStack{
                Text("Six Words Memoir")
                    .fontWeight(.medium)
                    .font(.system(.headline, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Six Words Memoir is a story told in only in six words. Can you write about your day in only six words.")
                    .multilineTextAlignment(.leading)
                    .opacity(0.5)
                    .font(.system(.subheadline, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Image(systemName: "ellipsis")
                .rotationEffect(Angle(degrees: 90))
        }
        .padding(.vertical)
        .overlay(
            JournalTemplateView(journalPrompts: $journalPrompts, selectedJournalPrompts: $selectedJournalPrompts, string: $string, showTempleteSheet: $showTempleteSheet)
        )
    }
}


struct JournalTemplateView: View {
    @Binding var journalPrompts: [Prompts]
    @Binding var selectedJournalPrompts: [Prompts]
    @Binding var string: String
    
    @Binding var showTempleteSheet: Bool
    
    var body: some View {
        NavigationLink(destination: {
            PromptsView(journalPrompts: $journalPrompts, selectedJournalPrompts: $selectedJournalPrompts, showTempleteSheet: $showTempleteSheet, string: $string)
        }) {
            EmptyView()
        }.opacity(0)
    }
}

struct PromptsView: View{
    @Binding var journalPrompts: [Prompts]
    @Binding var selectedJournalPrompts: [Prompts]
    @Binding var showTempleteSheet: Bool
    @Binding var string: String
    
    @State private var categoryPrompt: String = "Category"
    @State private var categoryPromptList: [String] = ["Category","Special Day", "Health", "Relationship", "Professional Development", "Financial Independence", "Family Happiness", "Personal Development", "Planning Goals", "The Realisation of Dreams", "Highlight", "Personal & Professional Development", "Self-realization"]

    @State private var timeTypePrompt: String = "Time"
    @State private var timeTypePromptList: [String] = ["Time", "Day", "Week", "Month", "Year"]
        
    var body: some View{
        List {
            filterPromptSection(categoryPrompt: $categoryPrompt, categoryPromptList: $categoryPromptList, timeTypePrompt: $timeTypePrompt, timeTypePromptList: $timeTypePromptList)
            selectedJournalPromptSection(journalPrompts: $journalPrompts, selectedJournalPrompts: $selectedJournalPrompts, categoryPrompt: $categoryPrompt, timeTypePrompt: $timeTypePrompt)
            journalPromptSection(journalPrompts: $journalPrompts, selectedJournalPrompts: $selectedJournalPrompts, categoryPrompt: $categoryPrompt, timeTypePrompt: $timeTypePrompt)
        }
//        .interactiveDismissDisabled()
        .navigationTitle("Prompts")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    for each in selectedJournalPrompts {
                        if each.entry == nil{
                            string = string + "\n\(each.prompt)"
                        } else {
                            string = string + "\n\(each.prompt)\n\(String(describing: each.entry)) "
                        }
                    }
                    showTempleteSheet.toggle()
                }) {
                    Image(systemName: "hand.tap")
                }
            }
        }
    }
}

struct filterPromptSection: View{
    @Binding var categoryPrompt: String
    @Binding var categoryPromptList: [String]
    
    @Binding var timeTypePrompt: String
    @Binding var timeTypePromptList: [String]
    
    var body: some View{
        HStack{
            Spacer()
            Picker("My Picker", selection: $timeTypePrompt) {
                ForEach(timeTypePromptList, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            Picker("My Picker", selection: $categoryPrompt) {
                ForEach(categoryPromptList, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
}

struct journalPromptSection: View{
    @Binding var journalPrompts: [Prompts]
    @Binding var selectedJournalPrompts: [Prompts]
    
    @Binding var categoryPrompt: String
    @Binding var timeTypePrompt: String
    
    var body: some View{
        Section{
            ForEach(journalPrompts, id: \.id) { each in
                journalPromptSectionLogic(journalPrompts: $journalPrompts, selectedJournalPrompts: $selectedJournalPrompts, categoryPrompt: $categoryPrompt, timeTypePrompt: $timeTypePrompt, each: each)
            }
        }
    }
}

struct journalPromptSectionLogic: View{
    @Binding var journalPrompts: [Prompts]
    @Binding var selectedJournalPrompts: [Prompts]
    
    @Binding var categoryPrompt: String
    @Binding var timeTypePrompt: String
    
    var each: Prompts
    
    var body: some View{
        if (each.category == categoryPrompt  || categoryPrompt == "Category") && (each.timeType == timeTypePrompt  || timeTypePrompt == "Time") {
            eachPrompt
        }
    }
    
    var eachPrompt: some View{
        Text(each.prompt)
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(action: {
                    selectedJournalPrompts.append(each)
                    journalPrompts.removeAll { $0.id == each.id }
                }) {
                    Image(systemName: "hand.tap")
                }
                .tint(.accentColor)
            }
    }
}

struct selectedJournalPromptSection: View{
    @Binding var journalPrompts: [Prompts]
    @Binding var selectedJournalPrompts: [Prompts]
    
    @Binding var categoryPrompt: String
    @Binding var timeTypePrompt: String
    
    var body: some View{
        if selectedJournalPrompts.count>0 {
            Section(header:Text("Added")){
                ForEach(selectedJournalPrompts, id: \.id) { each in
                    Text(each.prompt)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(action: {
                                journalPrompts.insert(each, at: 0)
                                selectedJournalPrompts.removeAll { $0.id == each.id }
                            }) {
                                Image(systemName: "trash")
                            }
                            .tint(.red)
                            Button(action: {
                                print("\(each)")
                            }) {
                                Image(systemName: "pencil")
                            }
                            .tint(.yellow)
                        }
                }
            }
        }
    }
}

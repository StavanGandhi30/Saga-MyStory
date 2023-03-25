//
//  JournalListView.swift
//  Saga
//
//  Created by Stavan Gandhi on 8/5/22.
//

import SwiftUI

struct journalListView: View{
    var data: JournalDataType
    @State var showFavorite: Bool = true
    
    var body: some View{
        VStack(spacing:0){
            HStack{
                Time
                VStack{
                    Title
                    Entry
                }
                if showFavorite{
                    image
                }
            }
            
            footer
        }
        .foregroundColor(Color.Default)
    }
    
    var Time: some View{
        VStack{
            Text(FirebaseTimeStampToString(TimeStamp: data.TimeStamp, to: "d"))
                .font(.system(.subheadline, design: .rounded))
            Text(FirebaseTimeStampToString(TimeStamp: data.TimeStamp, to: "MMM"))
                .font(.system(.caption, design: .rounded))
        }
        .padding()
    }
    
    var Title: some View{
        HStack{
            Text(data.title)
                .fontWeight(.medium)
                .font(.system(.subheadline, design: .rounded))
                .lineLimit(1)
            Spacer()
        }
    }
    
    var Entry: some View{
        HStack{
            Text(data.entry)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .opacity(0.5)
                .font(.system(.caption2, design: .rounded))
            Spacer()
        }
    }
    
    var image: some View{
        Image(systemName: data.Favorite ? "heart.fill":"heart")
            .padding()
    }
    
    var footer: some View{
        Divider()
    }
}

//
//  MessageListView.swift
//  RoomsToGo
//
//  Created by Ahmed Gedi on 7/12/24.
//

import SwiftUI

struct MessageListView: View {
    @Binding var messages: [Message]

    var body: some View {
        List(messages) { message in
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(message.message)
                        .font(.custom("Poppins", size: 14))
                        .foregroundColor(.black)
                }
                Spacer()
                Text(formatDate(message.date))
                    .font(.custom("Poppins", size: 12))
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 10)
        }
        .navigationTitle("Message Center")
        .listStyle(PlainListStyle())
    }

    private func formatDate(_ isoDate: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = isoFormatter.date(from: isoDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            dateFormatter.timeZone = TimeZone.current
            return dateFormatter.string(from: date)
        }
        return isoDate
    }
}

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView(messages: .constant([
            Message(name: "Michael Taylor", date: "2022-02-22T05:00:00.000Z", message: "Your order has been shipped. Track now!"),
            Message(name: "Michael Taylor", date: "2021-07-14T04:00:00.000Z", message: "Shop our patio savings now!")
        ]))
    }
}

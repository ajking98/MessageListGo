//
//  ContentView.swift
//  RoomsToGo
//
//  Created by Ahmed Gedi on 7/12/24.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MessageViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 40) {
                    Image("RTG-LOGO")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 18)
                        .foregroundColor(.blue)
                        .padding(.top, 20)

                    Text("Message Center")
                        .font(.custom("Poppins", size: 24))
                        .foregroundColor(.black)
                    
                    Text("Enter your email to search for your messages")
                        .font(.custom("Poppins", size: 16))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        TextField("Email", text: $viewModel.email)
                            .padding(.bottom, 10)
                            .overlay(
                                Rectangle()
                                    .frame(height: 2)
                                    .foregroundColor(.gray),
                                alignment: .bottom
                            )
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        Spacer()
                        
                        Button(action: viewModel.searchMessages){
                            Text("Search")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .font(.custom("Poppins", size: 16))
                        .background(Color(hex: "#004FB5"))
                        .foregroundColor(.white)
                        .buttonStyle(PlainButtonStyle())
                        .cornerRadius(25)
                    }
                    .padding(.horizontal, 20)
                }
                .padding()
                .alert(isPresented: $viewModel.showErrorAlert) {
                    Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
                }
                
                NavigationLink(destination: MessageListView(messages: $viewModel.messages), isActive: $viewModel.showMessageList) {
                        EmptyView()
                    }
                    .hidden()
                
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .foregroundColor(Color(hex: "#004FB5"))
                        .scaleEffect(1.5)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}

//
//  MessageViewModel.swift
//  RoomsToGo
//
//  Created by Ahmed Gedi on 7/12/24.
//

import Foundation

class MessageViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var messages: [Message] = []
    @Published var showMessageList: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false

    private let messageService = MessageService()

    func searchMessages() {
        guard isValidEmail(email) else {
            errorMessage = "Please enter a valid email address."
            showErrorAlert = true
            return
        }

        isLoading = true

        messageService.fetchMessages(for: email) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let messages):
                    if messages.isEmpty {
                        self?.errorMessage = "No messages found for this email."
                        self?.showErrorAlert = true
                    } else {
                        self?.messages = messages.sorted { $0.date > $1.date }
                        self?.showMessageList = true
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showErrorAlert = true
                }
            }
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

struct Message: Identifiable, Codable {
    var id: UUID {
        UUID()
    }
    let name: String
    let date: String
    let message: String
}

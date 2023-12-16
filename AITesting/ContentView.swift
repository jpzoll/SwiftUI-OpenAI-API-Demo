//
//  ContentView.swift
//  AITesting
//
//  Created by Joe Zoll on 12/14/23.
//

import SwiftUI
import OpenAI



struct ContentView: View {
    @State private var userInput: String = ""
    @State private var outputText: String = ""
    
    let openAI = OpenAI(apiToken: "insert API key here") // Make sure you have an instance of OpenAI
        
    var body: some View {
        ScrollView {
            TextField("Ask me something...", text: $userInput)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Send") {
                // Call a function to send the query to OpenAI
                sendQuery()
            }
            .padding()
            
            Text("Output: \(outputText)")
                .padding()
        }
        .padding()
    }

    // Function to send the query to OpenAI
    private func sendQuery() {
        let query = ChatQuery(model: .gpt3_5Turbo, messages: [.init(role: .user, content: userInput)])
        
        openAI.chats(query: query) { result in
            switch result {
            case .success(let chatResult):
                DispatchQueue.main.async {
                    // Update UI with the assistant's response
                    outputText = chatResult.choices.first?.message.content ?? "No response"
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ContentView()
}

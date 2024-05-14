//
//  ContentView.swift
//  AleoSwiftDemo
//
//  Created by Nafeh Shoaib on 3/12/24.
//

import SwiftUI
import os

struct ContentView: View {
    
    @State var viewModel = AleoViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                ProgressView(value: viewModel.progress)
            }
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            Button("Run Hello") {
                Task {
                    await runHello()
                }
            }
        }
        .padding()
    }
    
    func runHello() async {
        do {
            try await viewModel.executeHello()
        } catch let DecodingError.dataCorrupted(context) {
            os_log("\(context.debugDescription)")
        } catch let DecodingError.keyNotFound(key, context) {
            os_log("Key '\(key.stringValue)' not found: \(context.debugDescription)")
            os_log("codingPath: \(context.codingPath)")
        } catch let DecodingError.valueNotFound(value, context) {
            os_log("Value '\(value)' not found: \(context.debugDescription)")
            os_log("codingPath: \(context.codingPath)")
        } catch let DecodingError.typeMismatch(type, context)  {
            os_log("Type '\(type)' mismatch: \(context.debugDescription)")
            os_log("codingPath: \(context.codingPath)")
        } catch {
            os_log("Failed to execute hello program with error: \(error)")
        }
    }
}

#Preview {
    ContentView()
}

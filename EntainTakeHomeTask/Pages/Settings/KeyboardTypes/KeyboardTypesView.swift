//
//  KeyboardTypesView.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/25.
//

import SwiftUI

struct KeyboardTypesView: View {
    @State var myText = ""
    let textPlaceholder = "Text Placeholder"
    var body: some View {
        List {
            VStack(spacing: 15) {
                
                Text("Alphabetical")
                    .font(.largeTitle)
                    .padding()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("asciiCapable")
                        TextField(textPlaceholder, text: $myText)
                            .keyboardType(.asciiCapable)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("numbersAndPunctuation")
                        TextField(textPlaceholder, text: $myText)
                            .keyboardType(.numbersAndPunctuation)
                    }
                }
                
                Divider()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("URL")
                        TextField(textPlaceholder, text: $myText)
                            .keyboardType(.URL)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("twitter")
                        TextField(textPlaceholder, text: $myText)
                            .keyboardType(.twitter)
                    }
                }
                
                Divider()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("namePhonePad")
                        TextField(textPlaceholder, text: $myText)
                            .keyboardType(.namePhonePad)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("websearch")
                        TextField(textPlaceholder, text: $myText)
                            .keyboardType(.webSearch)
                    }
                }
                
                Divider()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("emailAddress")
                        TextField(textPlaceholder, text: $myText)
                            .keyboardType(.emailAddress)
                    }
                    
//                    VStack(alignment: .leading) {
//                        Text("alphabet (deprecated)") // this was deprecated
//                        TextField(textPlaceholder, text: $myText)
//                            .keyboardType(.alphabet) // same as asciiCapable
//                    }
                }
                                
                Text("Num Pads")
                    .font(.largeTitle)
                    .padding()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("phonePad")
                        TextField(textPlaceholder, text: $myText)
                            .keyboardType(.phonePad)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("asciiCapableNumberPad")
                        TextField(textPlaceholder, text: $myText)
                            .keyboardType(.asciiCapableNumberPad)
                    }
                    
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("decimalPad")
                        TextField(textPlaceholder, text: $myText)
                            .keyboardType(.decimalPad)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("numberPad")
                        TextField(textPlaceholder, text: $myText)
                            .keyboardType(.numberPad)
                    }
                }
            }
            .onTapGesture {
//                 deprecated in iOS 15.0
//                UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.endEditing(true)
                // TODO: This will make preview crash
//                UIApplication.shared.keyWindow?.endEditing(true)
            }
            .padding()
        }
    }
}

#Preview("light") {
    KeyboardTypesView()
        .preferredColorScheme(.light)
}

#Preview("dark") {
    KeyboardTypesView()
        .preferredColorScheme(.dark)
}

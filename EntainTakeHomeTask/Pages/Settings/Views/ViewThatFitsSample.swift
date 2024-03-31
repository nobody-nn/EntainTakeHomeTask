//
//  ViewThatFitsSample.swift
//  EntainTakeHomeTask
//
//  Created by nana Zhang on 2024/3/28.
//

import SwiftUI

struct MyAdaptableView: View {
    var body: some View {
        VStack {
            if #available(iOS 16.0, *) {
                ViewThatFits {
                    Image(systemName: "figure.table.tennis") // biggest view that could appear
                        .resizable()
                        .frame(width: 300, height: 300)
                    
                    HStack { // second biggest width view that could appear
                        Image(systemName: "figure.table.tennis")
                            .imageScale(.large)
                        
                        Text("This is a table tennis player")
                    }
                    
                    VStack { // third biggest width view that could appear
                        Image(systemName: "figure.table.tennis")
                            .imageScale(.large)
                        Text("Table Tennis!")
                    }
                    
                    Image(systemName: "figure.table.tennis") // smallest width view that could appear
                        .imageScale(.large)
                }
            } else {
                Text("Under iOS 15, do not support ViewThatFits")
            }
        }
        .border(Color.red)
    }
}

struct ViewThatFitsSample: View {
    var body: some View {
        VStack {
            MyAdaptableView()
                .frame(width: 20)
            MyAdaptableView()
                .frame(width: 100)
            MyAdaptableView()
                .frame(width: 250)
            MyAdaptableView()
                .frame(width: 300)
        }
    }
}

#Preview {
    ViewThatFitsSample()
}

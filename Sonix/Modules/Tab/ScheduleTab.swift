//
//  ScheduleTab.swift
//  Sonix
//
//  Created by Jake Round on 01/11/2022.
//

import SwiftUI

struct ScheduleTab: View {
    
    @State private var showSheet = true
    
    var body: some View {
        NavigationView {
            VStack {
               Text("Sticky Sheet")
            }
        }
        .navigationTitle("Today")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

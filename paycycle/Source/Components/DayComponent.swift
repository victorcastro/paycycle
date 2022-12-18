//
//  DateComponent.swift
//  paycycle
//
//  Created by Victor Castro on 15/12/22.
//

import SwiftUI

struct DayComponent: View {
    var body: some View {
        HStack {
            Text(Date.now, format: .dateTime.day()).font(.system(size: 40))
            Text(Date.now, format: .dateTime.month()).font(.system(size: 16))
        }
    }
}

struct DayComponent_Previews: PreviewProvider {
    static var previews: some View {
        DayComponent()
    }
}

//
//  RandomUserSwiftUICellView.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2025/2/19.
//

import SwiftUI

// MARK: - RandomUserSwiftUICellView

struct RandomUserSwiftUICellView: View {
    var user: RandomUser?

    var body: some View {
        HStack {
            if let url = user?.getThumbnail() {
                AsyncImage(url: URL(string: url)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
            }
            Text(user?.getFullName() ?? "")
            Spacer()
            Image(systemName: "person.crop.circle.fill")
                .foregroundColor(.gray)
        }
        .listRowBackground(Color.red)
        .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 20, trailing: 10))
    }
}

// MARK: - RandomUserSwiftUICellView_Previews

struct RandomUserSwiftUICellView_Previews: PreviewProvider {
    static var previews: some View {
        RandomUserSwiftUICellView()
    }
}

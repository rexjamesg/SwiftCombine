//
//  RandomUserSwiftUIView.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2025/2/17.
//

import SwiftUI

// MARK: - RandomUserSwiftUIView

struct RandomUserSwiftUIView: View {
    var popAction: () -> Void
    var loadNextPage: (() -> Void)?

    // 使用 @ObservedObject 接收外部傳遞的 viewModel
    @ObservedObject var viewModel: SwiftUIRandomUserViewModel
    @State private var newTodoTitle: String = ""

    var body: some View {
        CustomNavigationView(title: "RandomUser") {
            popAction()
        } content: {
            VStack {
                ZStack {
                    List {
                        ForEach(viewModel.randomUsers, id: \.itemId) { user in
                            RandomUserSwiftUICellView(user: user)
                            .cellStyle()
                            .onAppear {
                                if user.id == viewModel.randomUsers.last?.id {
                                    loadNextPage?()
                                }
                            }
                            
                        }
                        // 顯示加載指示器
                        if viewModel.isLoading {
                            ProgressView()
                                .background(Color.orange)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .listStyle(.plain) // 讓 `List` 貼齊邊界
                    .background(Color.green)
                    .scrollContentBackground(.hidden)
                }
            }
        }
    }
}

// MARK: - RandomUserSwiftUIView_Previews

struct RandomUserSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        let mockViewModel = SwiftUIRandomUserViewModel()
        RandomUserSwiftUIView(popAction: {}, viewModel: mockViewModel)
    }
}



extension View {
    func cellStyle() -> some View {
        self.modifier(CellModifier())
    }
}




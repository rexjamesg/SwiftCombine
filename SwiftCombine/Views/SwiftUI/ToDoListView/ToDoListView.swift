//
//  ToDoListView.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2025/2/17.
//

import SwiftUI

struct ToDoListView: View {
    var popAction: () -> Void
    @ObservedObject var viewModel: TodoViewModel
    @State private var newTodoTitle: String = ""

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Enter here", text: $newTodoTitle).textFieldStyle(RoundedBorderTextFieldStyle())
                    Button {
                        guard !newTodoTitle.isEmpty else { return }
                        viewModel.addTodo(title: newTodoTitle)
                        newTodoTitle = ""
                    } label: {
                        Image(systemName: "plus")
                            .font(.title)
                    }.padding(.leading, 8)
                }
                .padding()
                .background(Color.green)
                
                ZStack {
                    // 設定整個畫面的背景
                    Color("#0088CC").edgesIgnoringSafeArea(.all)
                    // 列表顯示待辦事項
                    List {
                        ForEach(viewModel.items) { item in
                            HStack {
                                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle").foregroundColor(item.isCompleted ? .green:.gray)
                                    .onTapGesture {
                                        viewModel.toggleCompletion(for: item)
                                    }
                                Text(item.title).strikethrough(item.isCompleted, color: .black)
                            }
                            .padding(.vertical, 4)
                            .listRowBackground(Color.customColor)
                        }
                        .onDelete(perform: viewModel.removeItems)
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationBarTitle("To-Do List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // 將按鈕放在導航列左邊
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: popAction) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("返回")
                        }
                    }
                }
            }
            .toolbarBackground(Color.red, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .background(Color.yellow)
        }
    }
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        let mockViewModel = TodoViewModel()
        ToDoListView(popAction: {}, viewModel: mockViewModel)
    }
}

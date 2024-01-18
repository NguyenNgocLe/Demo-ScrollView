//
//  ContentView.swift
//  Demo ScrollView
//
//  Created by Macbook on 17/01/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var dynamicText: String = "Init text ne"
    @State private var width: CGFloat = 0
    @State private var height: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { scrollView in
                VStack {
                    GeometryReader { geometry in
                        ScrollView(.vertical) {
                            LazyVStack(spacing: 0) {
                                Text(dynamicText)
                                    .id("combinedText")
                            }
                        }
                        .onChange(of: dynamicText, perform: { _ in
                            withAnimation {
                                scrollView.scrollTo("combinedText", anchor: .bottom)
                            }
                        })
                        .onAppear {
                            width = geometry.size.width
                            height = geometry.size.height
                            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                                dynamicText += " New text ne thử xem có bị lỗi ko? nếu lỗi thì sao ne... lỗi khó hiểu quá thử xem có bị lỗi ko? nếu lỗi thì sao ne... lỗi khó hiểu quá thử xem có bị lỗi ko? nếu lỗi thì sao ne... lỗi khó hiểu quá"
                            }
                        }
                    }
                }
            }
        }.frame(height: UIScreen.main.bounds.height).background(.red)
    }
    
    private func scrollToBottom(_ scrollViewProxy: ScrollViewProxy) {
        withAnimation {
            scrollViewProxy.scrollTo("combinedText", anchor: .bottomTrailing)
        }
    }
}

struct MyCustomScrollView<Content: View>: UIViewRepresentable {
    var content: () -> Content

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = true

        let hostView = UIHostingController(rootView: content())
        hostView.view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(hostView.view)

        NSLayoutConstraint.activate([
            hostView.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostView.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hostView.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostView.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hostView.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        let hostView = context.coordinator.hostView
        hostView.rootView = content()
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: MyCustomScrollView
        var hostView: UIHostingController<Content>

        init(_ parent: MyCustomScrollView) {
            self.parent = parent
            self.hostView = UIHostingController(rootView: parent.content())
        }
    }
}

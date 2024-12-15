//
//  SplashView.swift
//  CoordinatorX-Example
//
//  Created by Yevhen Don on 11/12/2024.
//

import SwiftUI

struct SplashView: View {

    @StateObject
    var viewModel: SplashViewModel

    var body: some View {
        Image("Logo")
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                viewModel.startTimer()
            }
            .onChange(of: viewModel.timerFired) { value in
                DispatchQueue.main.async {
                    withAnimation {
                        viewModel.routeToOnboard()
                    }
                }
            }
    }
}

#Preview {
    SplashView(viewModel: .init(router: nil))
}

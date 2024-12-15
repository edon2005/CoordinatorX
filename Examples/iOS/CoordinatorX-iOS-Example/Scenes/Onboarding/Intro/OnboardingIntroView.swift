//
//  OnbosrdingMainView.swift
//  CoordinatorX-iOS-Example
//
//  Created by Yevhen Don on 16/12/2024.
//

import SwiftUI

struct OnboardingIntroView: View {

    var viewModel: OnboardingIntroViewModel

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 150)

            Group {
                Text("Intro")
                    .foregroundStyle(.white)
                    .font(.custom("Baskerville", fixedSize: 46))
                    .fontWeight(.ultraLight)

                Spacer()
                    .frame(height: 20)

                Color(#colorLiteral(red: 0.90773803, green: 0.1652854085, blue: 0.4916426539, alpha: 1))
                    .frame(width: 50, height: 3)

                Spacer()
                    .frame(height: 20)

                Text("Understanding human behavior is a key aspect of modern psychology. Many people use mindfulness techniques to reduce stress and improve mental health.")
                    .foregroundStyle(.gray)
                    .font(.custom("Baskerville", fixedSize: 30))
                    .fontWeight(.ultraLight)
                    .environment(\._lineHeightMultiple, 1.5)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 40)

            Spacer()

            Button {
                withAnimation {
                    viewModel.routeToNextScreen()
                }
            } label: {
                Text("Continue")
                    .font(.custom("GillSans", fixedSize: 20))
                    .tracking(1.5)
                    .frame(height: 70)
                    .frame(maxWidth: .infinity)
            }
            .background {
                RoundedRectangle(cornerSize: .init(width: 20, height: 20), style: .continuous)
                    .fill(.white)
            }
            .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity)
        .background(
            Color.black
                .overlay(
                    Image("Blob")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .offset(x: 250)
                )
                .edgesIgnoringSafeArea(.all)
        )
    }
}

#Preview {
    OnboardingIntroView(viewModel: .init())
}

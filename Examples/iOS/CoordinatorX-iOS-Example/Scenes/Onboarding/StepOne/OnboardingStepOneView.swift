//
//  OnboardingStepOneView.swift
//  CoordinatorX-iOS-Example
//
//  Created by Yevhen Don on 17/12/2024.
//

import SwiftUI

struct OnboardingStepOneView: View {
    var viewModel: OnboardingStepOneViewModel

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 150)

            Group {
                Text("Step One")
                    .foregroundStyle(.white)
                    .font(.custom("Baskerville", fixedSize: 46))
                    .fontWeight(.ultraLight)

                Spacer()
                    .frame(height: 20)

                Color(#colorLiteral(red: 0.90773803, green: 0.1652854085, blue: 0.4916426539, alpha: 1))
                    .frame(width: 50, height: 3)

                Spacer()
                    .frame(height: 20)

                Text("The subconscious mind plays a significant role in shaping our decisions and actions. Cognitive-behavioral therapy helps individuals change negative thought patterns.")
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.trailing)
                    .font(.custom("Baskerville", fixedSize: 30))
                    .fontWeight(.ultraLight)
                    .environment(\._lineHeightMultiple, 1.5)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
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
                        .offset(x: -250)
                )
                .edgesIgnoringSafeArea(.all)
        )
    }
}

#Preview {
    OnboardingStepOneView(viewModel: .init())
}

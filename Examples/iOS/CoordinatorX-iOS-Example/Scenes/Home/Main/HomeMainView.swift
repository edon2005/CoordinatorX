//
//  HomeMainView.swift
//  CoordinatorX-iOS-Example
//
//  Created by Yevhen Don on 17/12/2024.
//

import SwiftUI

struct HomeMainView: View {

    var viewModel: HomeMainViewModel

    var body: some View {
        VStack {
            Spacer()
                .frame(height: 50)

            Group {
                Text("Home")
                    .foregroundStyle(.white)
                    .font(.custom("Baskerville", fixedSize: 36))
                    .fontWeight(.ultraLight)

                Spacer()
                    .frame(height: 20)

                Color(#colorLiteral(red: 0.90773803, green: 0.1652854085, blue: 0.4916426539, alpha: 1))
                    .frame(width: 50, height: 3)


                Text("Try different transitions")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.gray.opacity(0.7))
                    .font(.custom("Baskerville", fixedSize: 80))
                    .fontWeight(.ultraLight)
                    .environment(\._lineHeightMultiple, 1.2)
                    .lineLimit(3)
                    .frame(maxHeight: .infinity)

            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 40)

            Spacer()
            Group {
                button(title: "Full Screen") { viewModel.routeToFullscreen() }
                button(title: "Overlay") { viewModel.routeToOverlay() }
                button(title: "Sheet") { viewModel.routeToSheet() }
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }

    @ViewBuilder
    private func button(title: String, action: @escaping () -> Void) -> some View {
        Button {
            withAnimation {
                action()
            }
        } label: {
            Text(title)
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
}

#Preview {
    HomeMainView(viewModel: .init(router: nil))
}

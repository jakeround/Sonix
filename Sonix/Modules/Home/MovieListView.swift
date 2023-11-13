//
//  MovieListView.swift
//  Sonix
//
//  Created by Jake Round on 07/06/2023.
//

import SwiftUI

struct MovieListView: View {
    let movie: Movies

    var body: some View {
        NavigationLink(destination: MovieDetailsView(movie: movie)) {
            VStack(spacing: 12) {
                movieImage
                movieInfo
            }
        }
    }

    private var movieImage: some View {
        Group {
            if let mediumCoverImage = movie.mediumCoverImage, let url = URL(string: mediumCoverImage) {
                AsyncImage(
                    url: url,
                    content: { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .scaledToFit()
                            .cornerRadius(16)
                    },
                    placeholder: {
                        Image("Placeholder")
                            .aspectRatio(contentMode: .fill)
                            .scaledToFit()
                            .cornerRadius(16)
                    }
                )
            } else {
                Image("Placeholder")
                    .aspectRatio(contentMode: .fill)
                    .scaledToFit()
                    .cornerRadius(16)
            }
        }
    }

    private var movieInfo: some View {
        VStack(spacing: 8) {
            Text(movie.title ?? "Unknown Title")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(Color(AppColor.designSystem.headline))
                .frame(width: 191, alignment: .leading)
                .lineLimit(1)

            HStack(spacing: 12) {
                yearText
                ratingText
                Spacer()
            }
        }
    }

    private var yearText: some View {
        Group {
            if let year = movie.yearText {
                Text("\(year)")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(Color(AppColor.designSystem.subtext))
                    .frame(width: 67, height: 40)
                    .background(Color(AppColor.Figma.Card))
                    .cornerRadius(12)
            }
        }
    }

    private var ratingText: some View {
        Group {
            if let rating = movie.rating {
                let formattedRating = String(format: "%.1f/10", rating)
                Text(formattedRating)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(Color(AppColor.designSystem.white))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 16)
                    .frame(height: 40)
                    .background(Color(AppColor.Figma.Card))
                    .cornerRadius(12)
            }
        }
    }
}

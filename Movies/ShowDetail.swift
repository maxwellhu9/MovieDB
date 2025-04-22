import SwiftUI

struct TVDetailView: View {
    let tvID: Int
    @State private var tvDetail: TVShowDetail?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let detail = tvDetail {
                    if let backdrop = detail.backdrop_path {
                        AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(backdrop)")) { image in
                            image.resizable().aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }
                    }

                    Text(detail.name)
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 5)
                        .foregroundColor(.white)

                    Text("\(String(format: "%.1f", detail.vote_average))")
                        .foregroundColor(.yellow)
                        .padding(.bottom, 5)
                        .bold()

                    Text("\(detail.genres.map { $0.name }.joined(separator: ", "))")
                        .font(.body)
                        .padding(.bottom, 5)
                        .foregroundColor(.white)
                        .bold()

                    Text("First Air: \(detail.first_air_date)")
                        .font(.body)
                        .padding(.bottom, 5)
                        .foregroundColor(.white)
                        .bold()

                    Text(detail.overview)
                        .font(.headline)
                        .padding(.top)
                        .foregroundStyle(.gray)
                } else {
                    ProgressView("Loading...")
                }
            }
            .padding(.top)
            .padding(.horizontal)
        }
        .background(Color.black.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                do {
                    tvDetail = try await fetchTVDetails(for: tvID)
                } catch {
                    print("Error fetching TV details:", error)
                }
            }
        }
    }
}

struct TVShowCard: View {
    let show: TVShow

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w300\(show.poster_path ?? "")")) { image in
                image.resizable()
                    .aspectRatio(2/3, contentMode: .fill)
                    .frame(width: 150, height: 225)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } placeholder: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 150, height: 225)
            }

            Text(show.name)
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(2)
                .frame(width: 150, alignment: .leading)
        }
    }
}

struct TVShowDetail: Codable {
      let id: Int
      let name: String
      let overview: String
      let first_air_date: String
      let vote_average: Double
      let backdrop_path: String?
      let genres: [Genre]
}

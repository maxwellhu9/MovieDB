import SwiftUI

struct MovieDetailView: View {
    let movieID: Int // Passed in front of previous screen
    @State private var movieDetail: MovieDetail? // Holds fetched details

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let detail = movieDetail { // Shows either loaded content or spinner
                    if let backdrop = detail.backdrop_path { // Backdrop if available
                        AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(backdrop)")) { image in
                            image.resizable().aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView() // Shown while loading
                        }
                    }
                    
                    Text(detail.title)
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
                        
                    Text("\(detail.release_date)")
                        .font(.body)
                        .padding(.bottom, 5)
                        .foregroundColor(.white)
                        .bold()
                    
                    Text(detail.overview)
                        .font(.headline)
                        .padding(.top)
                        .foregroundStyle(.gray)
                } else {
                    // Spinner shown until 'movieDetail' is set
                    ProgressView("Loading...")
                }
            }
            .padding(.top)
            .padding(.horizontal)
        }
        .background(Color.black.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        
        // When view appears, fetch details
        .onAppear {
            Task {
                do {
                    movieDetail = try await fetchMovieDetails(for: movieID)
                } catch {
                    print("Error fetching movie details:", error)
                }
            }
        }
    }
}

// Small card for movie poster + title
struct MoviePosterCard: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Poster image
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w300\(movie.poster_path ?? "")")) { image in
                image
                    .resizable()
                    .aspectRatio(2/3, contentMode: .fill)
                    .frame(width: 150, height: 225)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } placeholder: {
                // Placeholder shape while loading
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 150, height: 225)
            }

            Text(movie.title)
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(2)
                .frame(width: 150, alignment: .leading)
        }
    }
}

struct MovieDetail: Codable { // Model matching movie-detail JSON response
    let id: Int
    let title: String
    let overview: String
    let release_date: String
    let vote_average: Double
    let backdrop_path: String?
    let genres: [Genre]
}

struct Genre: Codable { // Decodes genres array
    let id: Int
    let name: String
}

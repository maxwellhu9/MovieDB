import SwiftUI
import Foundation

struct MultiSearchResult: Codable, Identifiable {
    let id: Int
    let media_type: String
    let title: String?
    let name: String?
    let overview: String?
    let backdrop_path: String?
    let poster_path: String?
}

// Wrapper
struct MultiSearchResponse: Codable {
    let results: [MultiSearchResult]
}

func searchMulti(query: String) async throws -> [MultiSearchResult] {
    let url = URL(string: "https://api.themoviedb.org/3/search/multi")!
    var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
    components.queryItems = [
        URLQueryItem(name: "query", value: query),
        URLQueryItem(name: "language", value: "en-US"),
        URLQueryItem(name: "include_adult", value: "false")
    ]

    var request = URLRequest(url: components.url!)
    request.httpMethod = "GET"
    request.timeoutInterval = 10
    request.allHTTPHeaderFields = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2ZTNkYzI4ZDZiNDYwNDQ3YmE0ZDk0NDFmNjNhMzNhOCIsIm5iZiI6MTc0NDMxNDI2OS41Niwic3ViIjoiNjdmODFmOWQzMTc3NTI3NmQ2ZDliNTRkIiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.PCgUikmWIFKI8NqGscO11JdC0U2uSMaiyKphkV9W8wU"
    ]

    let (data, _) = try await URLSession.shared.data(for: request)
    return try JSONDecoder().decode(MultiSearchResponse.self, from: data).results
}

struct SearchResultsView: View {
    let results: [MultiSearchResult]

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(results) { result in
                if result.media_type == "movie" || result.media_type == "tv" {

                    // Wrap each row in NavigationLink to appropriate detail view
                    NavigationLink(
                        destination: destinationView(for: result)
                    ) {
                        HStack { // Poster thumbnail
                            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w185\(result.poster_path ?? "")")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: 60, height: 90)
                            .cornerRadius(8)

                            //Title and type
                            VStack(alignment: .leading) {
                                Text(result.title ?? result.name ?? "")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)

                                Text(result.media_type.capitalized)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.bottom, 8)
                    }
                }
            }
        }
    }

    @ViewBuilder // Helps choose correct detail view
    func destinationView(for result: MultiSearchResult) -> some View {
        if result.media_type == "movie", let id = result.id as Int? {
            MovieDetailView(movieID: id)
        } else if result.media_type == "tv", let id = result.id as Int? {
            TVDetailView(tvID: id)
        } else {
            EmptyView() // Unsupported types
        }
    }
}

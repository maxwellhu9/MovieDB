import Foundation

func fetchTVShows() async throws -> [TVShow] {
    let url = URL(string: "https://api.themoviedb.org/3/trending/tv/day")!
    var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
    components.queryItems = [URLQueryItem(name: "language", value: "en-US")]

    var request = URLRequest(url: components.url!)
    request.httpMethod = "GET"
    request.timeoutInterval = 10
    request.allHTTPHeaderFields = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2ZTNkYzI4ZDZiNDYwNDQ3YmE0ZDk0NDFmNjNhMzNhOCIsIm5iZiI6MTc0NDMxNDI2OS41Niwic3ViIjoiNjdmODFmOWQzMTc3NTI3NmQ2ZDliNTRkIiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.PCgUikmWIFKI8NqGscO11JdC0U2uSMaiyKphkV9W8wU"
    ]

    let (data, _) = try await URLSession.shared.data(for: request)
    let decoded = try JSONDecoder().decode(TVShowResponse.self, from: data)
    return decoded.results
}

func fetchTVDetails(for id: Int) async throws -> TVShowDetail {
    let url = URL(string: "https://api.themoviedb.org/3/tv/\(id)")!
    var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
    components.queryItems = [URLQueryItem(name: "language", value: "en-US")]

    var request = URLRequest(url: components.url!)
    request.httpMethod = "GET"
    request.timeoutInterval = 10
    request.allHTTPHeaderFields = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2ZTNkYzI4ZDZiNDYwNDQ3YmE0ZDk0NDFmNjNhMzNhOCIsIm5iZiI6MTc0NDMxNDI2OS41Niwic3ViIjoiNjdmODFmOWQzMTc3NTI3NmQ2ZDliNTRkIiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.PCgUikmWIFKI8NqGscO11JdC0U2uSMaiyKphkV9W8wU"
    ]

    let (data, _) = try await URLSession.shared.data(for: request)
    return try JSONDecoder().decode(TVShowDetail.self, from: data)
}

struct TVShow: Codable, Identifiable {
    let id: Int
    let name: String
    let overview: String
    let poster_path: String?
    let backdrop_path: String?
    let vote_average: Double
    let first_air_date: String
    let genres: [Genre]?
}

struct TVShowResponse: Codable {
    let results: [TVShow]
}

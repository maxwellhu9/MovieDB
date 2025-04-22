import Foundation

func fetchMovies() async throws -> [Movie] {
    let url = URL(string: "https://api.themoviedb.org/3/trending/movie/day")! // Endpoint
    var components = URLComponents(url: url, resolvingAgainstBaseURL: true)! // URLComponents to append query parameters
    components.queryItems = [URLQueryItem(name: "language", value: "en-US")]

    var request = URLRequest(url: components.url!) //Build URLRequest from URL
    request.httpMethod = "GET" //Reading data
    request.timeoutInterval = 10 //Fail if no response within 10 seconds
    request.allHTTPHeaderFields = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2ZTNkYzI4ZDZiNDYwNDQ3YmE0ZDk0NDFmNjNhMzNhOCIsIm5iZiI6MTc0NDMxNDI2OS41Niwic3ViIjoiNjdmODFmOWQzMTc3NTI3NmQ2ZDliNTRkIiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.PCgUikmWIFKI8NqGscO11JdC0U2uSMaiyKphkV9W8wU"
    ]

    let (data, _) = try await URLSession.shared.data(for: request) //Asynchronous network call
    let decoded = try JSONDecoder().decode(MovieResponse.self, from: data) //Decode top-level JSON into our MovieResponse struct
    return decoded.results // Returns array of Movie
}

func fetchMovieDetails(for id: Int) async throws -> MovieDetail {
    let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)")!
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
    return try JSONDecoder().decode(MovieDetail.self, from: data)
}

// Wrapper around "results" array in trending/movie response
struct MovieResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let poster_path: String?
    let backdrop_path: String?
}

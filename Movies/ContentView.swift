import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @State private var searchResults: [MultiSearchResult] = []
    @State private var trendingBannerItems: [MultiSearchResult] = [] //combined media for banner
    @State private var trendingMovies: [Movie] = []
    @State private var trendingTV: [TVShow] = []

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {

                    TextField("Search for movies or shows", text: $searchText)
                        .padding(12)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .foregroundColor(.white)
                    
                        // 'searchText' changes, kick off an async task
                        .onChange(of: searchText) {
                            Task {
                                if searchText.count > 2 {
                                    do {
                                        searchResults = try await searchMulti(query: searchText)
                                    } catch {
                                        print("Search failed:", error)
                                    }
                                } else {
                                    // Clear results if query is too short
                                    searchResults = []
                                }
                            }
                        }
                    // Show search results
                    if !searchResults.isEmpty {
                        SearchResultsView(results: searchResults)
                            .padding(.horizontal)
                    }
                    // Trending Banner
                    TrendingBannerView(mediaItems: trendingBannerItems)
                    
                    Text("Trending Movies")
                        .font(.title3)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.bottom, -40)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(trendingMovies) { movie in
                                // Tapping poster navigates to detailed view
                                NavigationLink(destination: MovieDetailView(movieID: movie.id)) {
                                    MoviePosterCard(movie: movie)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Text("Trending Shows")
                        .font(.title3)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.bottom, -40)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(trendingTV) { show in
                                NavigationLink(destination: TVDetailView(tvID: show.id)) {
                                    TVShowCard(show: show)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            .background(Color.black.ignoresSafeArea())
            .onAppear {
                // When view appears, fetch trending data
                Task {
                    do {
                        // Fetch both lists concurrently
                        trendingMovies = try await fetchMovies()
                        trendingTV = try await fetchTVShows()

                        // Map Movie → MultiSearchResult
                        let movieResults = trendingMovies.map {
                            MultiSearchResult(
                                id: $0.id,
                                media_type: "movie",
                                title: $0.title,
                                name: nil,
                                overview: nil,
                                backdrop_path: $0.backdrop_path,
                                poster_path: $0.poster_path
                            )
                        }

                        // Map TVShow → MultiSearchResult
                        let tvResults = trendingTV.map {
                            MultiSearchResult(
                                id: $0.id,
                                media_type: "tv",
                                title: nil,
                                name: $0.name,
                                overview: nil,
                                backdrop_path: $0.backdrop_path,
                                poster_path: $0.poster_path
                            )
                        }

                        // Merge, shuffle, and assign
                        trendingBannerItems = (movieResults + tvResults).shuffled()

                    } catch {
                        print("Error fetching trending media:", error)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}

import SwiftUI

struct TrendingBannerView: View {
    let mediaItems: [MultiSearchResult]
    @State private var currentIndex = 0 // Tracks current page
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect() //Timer that fires every 3 seconds

    var body: some View {
        TabView(selection: $currentIndex) {
            // Loop over indices so we can tage each page
            ForEach(mediaItems.indices, id: \.self) { index in
                let item = mediaItems[index]

                ZStack(alignment: .bottomLeading) {
                    // Backdrop image
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w780\(item.backdrop_path ?? "")")) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 280)
                            .clipped()
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 280)
                    }

                    LinearGradient(
                        gradient: Gradient(colors: [.black.opacity(0.8), .clear]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .frame(height: 120)
                    .frame(maxWidth: .infinity, alignment: .bottom)

                    Text(item.title ?? item.name ?? "")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.leading, 65)
                        .padding(.bottom, 24)
                        .multilineTextAlignment(.leading)
                }
                .tag(index) // Tag page so TabView can bind to currentIndex
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Hides dots
        .frame(height: 280)
        .onReceive(timer) { _ in // Advance 'currentIndex' every time timer fires
            withAnimation {
                currentIndex = (currentIndex + 1) % mediaItems.count
            }
        }
    }
}

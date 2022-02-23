//
//  IMDB_SwiftUIApp.swift
//  IMDB-SwiftUI
//
//  Created by Kuldeep Vashisht on 21/02/22.
//

import SwiftUI

struct MoviesListView: View {
    
    // set the pageData by default to empty data
    @State private var pageData = PageData(search: [], totalResults: "", response: "")
    
    // current page index set to 1 when starting
    @State private var currentPage: Int = 1
    
    var body: some View {
        NavigationView{
            ZStack {
                LinearGradient(colors: [.black, Color(#colorLiteral(red: 0.9615057111, green: 0.7718586326, blue: 0.09978007525, alpha: 1))], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack{
                    ScrollViewReader { proxy in
                        ScrollView {
                            // title
                            Text("IMDB SwiftUI")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.white)
                                .id("top")
                                .padding(.vertical, 5)
                            // num of results
                            Text("\(pageData.totalResults) total results")
                                .foregroundColor(.white)
                            
                            // loop all the search results
                            ForEach(pageData.search, id: \.id){ movie in
                                VStack {
                                    // make navigation link for every of the movies with destination of MovieDetailView
                                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                                        // this HStack is the content of each row
                                        HStack{
                                            // loads image asynchroniously since we are loading from a URL
                                            AsyncImage(
                                                url: URL(string: movie.poster),
                                                content: { image in
                                                    image.resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(maxWidth: 80, maxHeight: 200)
                                                        .shadow(color: .black, radius: 5, x: 0, y: 0)
                                                },
                                                placeholder: {
                                                    ProgressView()
                                                }
                                            )
                                            // description of movie
                                            VStack(alignment: .leading, spacing: 4){
                                                Text(movie.title)
                                                    .multilineTextAlignment(.leading)
                                                    .font(.system(size: 20, weight: .bold))
                                                
                                                Text(movie.type)
                                                    .font(.system(size: 16, weight: .bold))
                                                    .foregroundColor(.gray)
                                                
                                                Text(formatYear(year: movie.year))
                                                    .font(.system(size: 16, weight: .bold))
                                                    .foregroundColor(.white)
                                                
                                                
                                            }
                                            .padding(.leading)
                                            
                                            Spacer()
                                            // right arrow to indicate that you can tap the row
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 20, weight: .bold))
                                        }
                                        .foregroundColor(.white)
                                        .padding()
                                        .padding(.horizontal, 5)
                                    }
                                    // black divider after each row
                                    Rectangle()
                                        .fill(Color.black)
                                        .frame(width: UIScreen.main.bounds.width, height: 5)
                                }
                            }
                            
                            // button to change the current page
                            // left arrow -1
                            // right arrow +1
                            HStack(spacing: 50){
                                Button(action: {
                                    if currentPage >= 2{
                                        currentPage -= 1
                                    }
                                }) {
                                    Image(systemName: "chevron.left")
                                }
                                
                                
                                Text("Page \(currentPage)")
                                
                                Button(action: {
                                    currentPage += 1
                                }) {
                                    Image(systemName: "chevron.right")
                                }
                                
                            }
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .bold))
                            .padding(.vertical)
                        }
                        
                        // when the app starts fetch the data with index 1
                        .onAppear{
                            IMDBAPI().getDataForPageNr(page: currentPage) { pageData in
                                self.pageData = pageData
                            }
                        }
                        
                        // everytime when currentPage index changes, get new data from the API with the new index
                        .onChange(of: currentPage) { newPage in
                            IMDBAPI().getDataForPageNr(page: newPage) { pageData in
                                self.pageData = pageData
                                // scroll to the top of the screen when index changes
                                withAnimation {
                                    proxy.scrollTo("top", anchor: .top)
                                }
                                
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    // function to format the year based on the task description
    // movies have just one year - for example "2020" is an easy calculation 2022 - 2020
    // series can have year range - for example "2020-2021" in that case I take the first number - 2020 and do 2022 - 2020
    func formatYear(year: String) -> String{
        
        // get the current year - Int
        let currentYear = Calendar.current.component(.year, from: Date())
        
        // if the year string contains "-", split the string by the "-" separator and take the first element which will always be the first number (year). Then subtract this year from currentYear, convert back to string and add "years back" as it was in the task description
        if year.contains("-"){
            return String(currentYear - (Int(year.components(separatedBy: "-").first!) ?? 2022)) + " years back"
        }
        
        // if it's just one number then just do the last part with the subtraction
        else{
            return String(currentYear - (Int(year) ?? 2022)) + " years back"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesListView()
    }
}

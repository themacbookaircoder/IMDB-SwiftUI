//
//  MovieDetailView.swift
//  IMDB-SwiftUI
//
//  Created by Kuldeep Vashisht on 23/02/22.
//

import SwiftUI

struct MovieDetailView: View {
    
    // you need to pass each DetailView a Movie object - you do that in MovieListView in the ForEach loop
    let movie: Movie
    
    
    // environment variable to hide the detail view in the NavigationView
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [.black, Color(#colorLiteral(red: 0.9615057111, green: 0.7718586326, blue: 0.09978007525, alpha: 1))], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView {
                
                HStack{
                    Button {
                        // hide the current detail view
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }

                    Spacer()
                }
                .padding(.leading, 30)
                .padding(.bottom, 20)
                
                AsyncImage(
                    url: URL(string: movie.poster),
                    content: { image in
                        image.resizable()
                             .aspectRatio(contentMode: .fit)
                             .frame(maxWidth: 250, maxHeight: 300)
                             .shadow(color: .black, radius: 10, x: 0, y: 0)
                             .padding(.bottom)
                    },
                    placeholder: {
                        ProgressView()
                    }
                )
                
                VStack(spacing: 4){
                    Text(movie.title)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text(movie.type)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.black.opacity(0.6))
                    
                    Text(movie.year)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.black.opacity(0.3))
                }
                .frame(width: UIScreen.main.bounds.width * 0.8)
                
                // I have added some dummy text because I did not know what to put in the detail because the API offers the movie title, type and year, you can delete this if you want - could be something like a description
                Text(
                     """
                     Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Duis bibendum, lectus ut viverra rhoncus, dolor nunc faucibus libero, eget facilisis enim ipsum id lacus. Nulla pulvinar eleifend sem. Duis sapien nunc, commodo et, interdum suscipit, sollicitudin et, dolor. In rutrum. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat. Vestibulum fermentum tortor id mi. Aenean vel massa quis mauris vehicula lacinia. Integer pellentesque quam vel velit. Cras elementum.
                     
                     Duis condimentum augue id magna semper rutrum. Phasellus faucibus molestie nisl. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aliquam erat volutpat. Praesent dapibus. Etiam quis quam. Aliquam in lorem sit amet leo accumsan lacinia. Ut tempus purus at lorem. Aenean vel massa quis mauris vehicula lacinia. Maecenas ipsum velit, consectetuer eu lobortis ut, dictum at dui. Suspendisse sagittis ultrices augue.
                    """
                )
                    .padding()
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 3, x: 0, y: 0)
                Spacer()
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarHidden(true)
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movie: Movie(id: "1", title: "Batman", year: "2005", type: "movie", poster: "https://m.media-amazon.com/images/M/MV5BOTY4YjI2N2MtYmFlMC00ZjcyLTg3YjEtMDQyM2ZjYzQ5YWFkXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_SX300.jpg"))
    }
}

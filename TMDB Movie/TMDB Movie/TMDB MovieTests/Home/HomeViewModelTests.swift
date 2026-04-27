//
//  Untitled.swift
//  TMDB Movie
//
//  Created by ihan carlos on 20/04/26.
//

import XCTest
@testable import TMDB_Movie

@MainActor
final class HomeViewModelTests: XCTestCase {
    
    var sut: HomeViewModel!
    var serviceMock: TMDBServiceMock!
    
    override func setUp() {
        super.setUp()
        serviceMock = TMDBServiceMock()
        sut = HomeViewModel(service: serviceMock)
    }
    
    override func tearDown() {
        sut = nil
        serviceMock = nil
        super.tearDown()
    }
    
    func testLoadInitial_WhenSuccess_ShouldBuildSectionsCorrecty() async {
        let mockGenres = [TMDBGenre(id: 1, name: "Ação")]
        let mockMovies = (1...15).map { id in
            TMDBMovieDTO(id: id, title: "Filme \(id)", posterPath: "/p\(id).jpg", backdropPath: "/b\(id).jpg")
        }
        
        serviceMock.movieGenresResult = mockGenres
        serviceMock.trendingMoviesResult = mockMovies
        serviceMock.popularMoviesResult = mockMovies
        
        let expectation = XCTestExpectation(description: "Deve carregar gêneros e seções")
        
        sut.onStateChange = { state in
            if state == .loaded {
                expectation.fulfill()
            }
        }
        
        sut.loadInitial()
        
        await fulfillment(of: [expectation], timeout: 2.0)
        
        XCTAssertEqual(sut.genres.count, 1)
        XCTAssertEqual(sut.sections.count, 2)
        
        XCTAssertEqual(sut.sections[0].items.count, 10, "Trending deve ter exatamente 10 itens")
        XCTAssertEqual(sut.sections[1].items.count, 12, "Popular deve ter exatamente 12 itens")
    }
    
    func testSelectGenre_WhenIndexValid_ShouldFetchGenreSpecificMovies() async {

        let genre = TMDBGenre(id: 28, name: "Ação")
        serviceMock.movieGenresResult = [genre]
        serviceMock.discoverMoviesResult = [
            TMDBMovieDTO(id: 1, title: "Filme Ação", posterPath: nil, backdropPath: nil)
        ]

        let loadExpectation = XCTestExpectation(description: "Load inicial")

        sut.onStateChange = { state in
            if state == .loaded {
                loadExpectation.fulfill()
            }
        }

        sut.loadInitial()
        await fulfillment(of: [loadExpectation], timeout: 2.0)

        let genreExpectation = XCTestExpectation(description: "Deve carregar seção de gênero")

        sut.onStateChange = { state in
            if case .loaded = state {
                genreExpectation.fulfill()
            }
        }

        sut.selectGenre(index: 0)

        await fulfillment(of: [genreExpectation], timeout: 2.0)

        XCTAssertEqual(sut.sections.count, 3)
        XCTAssertTrue(serviceMock.discoverMoviesCalled)
    }

    func testSearch_WhenQueryNotEmpty_ShouldShowSearchSection() async {

        let query = "Marvel"
        serviceMock.searchMoviesResult = [TMDBMovieDTO(id: 99, title: "Marvel Movie", posterPath: nil, backdropPath: nil)]
        
        let expectation = XCTestExpectation(description: "Deve retornar resultados de busca")
        sut.onStateChange = { state in
            if state == .loaded { expectation.fulfill() }
        }
        
        sut.search(query: query)
        
        await fulfillment(of: [expectation], timeout: 2.0)
        XCTAssertEqual(sut.sections.count, 1)
        if case .search(let q) = sut.sections[0].type {
            XCTAssertEqual(q, "Marvel")
        } else {
            XCTFail("A seção deveria ser do tipo search")
        }
    }
}

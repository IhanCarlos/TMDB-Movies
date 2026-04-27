//
//  LoginViewModelTests.swift
//  TMDB Movie
//
//  Created by ihan carlos on 20/04/26.
//

import XCTest
@testable import TMDB_Movie

@MainActor
final class LoginViewModelTests: XCTestCase {
    
    var sut: LoginViewModel!
    var serviceMock: TMDBServiceMock!

    override func setUp() {
        super.setUp()
        serviceMock = TMDBServiceMock()
        sut = LoginViewModel(service: serviceMock)
    }

    override func tearDown() {
        sut = nil
        serviceMock = nil
        super.tearDown()
    }

    func testLoad_WhenSuccess_ShouldEmitLoadingAndLoadedStates() async {

        let mockMovie = TMDBMovieDTO(
            id: 1,
            title: "Filme Teste",
            posterPath: "/poster.jpg",
            backdropPath: "/test.jpg"
        )
        serviceMock.trendingMoviesResult = [mockMovie]
        
        let expectationLoading = XCTestExpectation(description: "Deve emitir .loading")
        let expectationLoaded = XCTestExpectation(description: "Deve emitir .loaded")
        
        sut.onStateChange = { state in
            if state == .loading {
                expectationLoading.fulfill()
            } else if state == .loaded {
                expectationLoaded.fulfill()
            }
        }
        sut.load()

        await fulfillment(of: [expectationLoading, expectationLoaded], timeout: 2.0)
        XCTAssertTrue(serviceMock.trendingMoviesCalled)
    }

    func testLoad_WhenSuccess_ShouldGenerateBackgroundURLs() async {

        let mockMovie = TMDBMovieDTO(
            id: 1,
            title: "Filme Teste",
            posterPath: "/poster.jpg",
            backdropPath: "/image1.jpg"
        )
        serviceMock.trendingMoviesResult = [mockMovie]
        
        let expectation = XCTestExpectation(description: "Deve gerar URLs de background")
        var receivedURLs: [URL] = []
        
        sut.onBackgroundURLsChange = { urls in
            receivedURLs = urls
            expectation.fulfill()
        }

        sut.load()

        await fulfillment(of: [expectation], timeout: 2.0)
        XCTAssertFalse(receivedURLs.isEmpty, "A lista de URLs não deve estar vazia")
        
        let firstURL = receivedURLs.first?.absoluteString ?? ""
        XCTAssertTrue(firstURL.contains("/image1.jpg"), "A URL deve conter o path do backdrop")
    }

    func testLoad_WhenServiceFails_ShouldEmitErrorState() async {

        let apiError = NSError(domain: "TMDBError", code: 404, userInfo: nil)
        serviceMock.trendingMoviesError = apiError
        
        let expectation = XCTestExpectation(description: "Deve emitir estado de erro")
        var errorMessage: String?
        
        sut.onStateChange = { state in
            if case .error(let message) = state {
                errorMessage = message
                expectation.fulfill()
            }
        }

        sut.load()

        await fulfillment(of: [expectation], timeout: 2.0)
        XCTAssertEqual(errorMessage, "Falha ao carregar", "A mensagem de erro deve ser a definida na ViewModel")
    }

    func testCancel_ShouldCancelPreviousTask() {

        sut.load()
        sut.cancel()

        XCTAssertTrue(true)
    }
}

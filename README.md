# TMDB-Movies
This is a native iOS application focused on exploring the catalog of The Movie Database (TMDB). The main technical differentiator of this project is the construction of the user interface 100% via code (View Code), dispensing with the use of Interface Builder (Storyboards/XIBs). This approach was chosen to ensure greater control over the layout, facilitate the reuse of components, and avoid merge conflicts in Git.

# Description
An iOS application developed for movie lovers, allowing the search and discovery of films using data from the TMDB API.

Developed entirely in Swift and View Code, the project serves as a demonstration of creating complex programmatic interfaces, customized navigation, and integration with REST services.

Features:

Listing of trending and new release films.

Search for specific titles.

Details screen with synopsis, rating, and other information such as cast and trailer integrated with YouTube.

Interface built 100% without storyboards.

# Guide
To run the project, simply open it and wait.

The application requires an API key from https://www.themoviedb.org to run. Add your API key to the Constants file under the "apiKey" variable.
<img width="306" height="131" alt="Captura de Tela 2026-04-27 às 16 54 49" src="https://github.com/user-attachments/assets/3763a9ab-a6f5-454b-9656-9de2cc1c20a3" />
<img width="410" height="120" alt="Captura de Tela 2026-04-27 às 16 55 18" src="https://github.com/user-attachments/assets/5602c81e-0695-41e9-9840-ad01b0b98d81" />

# App overview

<img width="441" height="936" alt="Captura de Tela 2026-04-27 às 17 00 38" src="https://github.com/user-attachments/assets/7ed2315e-e39e-4009-98e2-fe02d6c941d1" />

<img width="449" height="941" alt="Captura de Tela 2026-04-27 às 17 01 09" src="https://github.com/user-attachments/assets/a9e2b85b-f0ad-4480-adb4-412bc992dc03" />

<img width="458" height="940" alt="Captura de Tela 2026-04-27 às 17 02 01" src="https://github.com/user-attachments/assets/17504a0d-e7ab-4f8b-b370-60d3a7ca3004" />

# Technology stack
Swift and UIKit for interface design (100% View Code, no Storyboards).

MVVM-C user interface architecture pattern used.

# Main features
Listing of trending movies and new releases so users can explore the catalog.

Customizable and reusable views for common use throughout the app.

Customized listing cell to display the main poster and summary data of the movie.

Detailed view for users to access synopsis, ratings, and complete information about the desired movie.

Architecture [MVVM / MVVM-C] with well-defined Clean Code principles and single responsibility.

Network error handling and screen state management (Loading, Error, Success).

# Bonus Features:
Fully programmatic interface construction, ensuring greater layout control and avoiding merge conflicts.

Application created using POP (Protocol-Oriented Programming) concepts.

Unit testing of the main business logic (ViewModels) and the network layer using Mocks.

Clear separation of the Network layer (consumption of the TMDB REST API).


# asar

## Project Structure

This project is structured as follows:

* `lib` - contains the main application source code
	+ `core` - contains the core application code
		- `common` - contains common widgets and utilities
		- `error` - contains error handling code
		- `usecase` - contains interfaces for use cases
	+ `features` - contains feature-specific code
		- `auth` - contains authentication code
		- `events` - contains event-related code
	+ `routes` - contains code for handling routes
* `test` - contains unit tests

## Features

This project currently has the following features:

* Authentication with a Mobile Number. The user is redirected to a login page if they are not logged in.
* Once logged in, the user is redirected to the home page which displays a list of events.
* The user can then select an event and place an order.
* The order is stored on the server and can be retrieved later.
* Live order book is displayed of the current event.


## Architecture

This project follows the principles of Clean Architecture. The code is structured in the following way:

* `domain` - contains the business logic of the application
	+ `entities` - contains the business entities of the application
	+ `usecases` - contains the interfaces for the use cases of the application
	+ `repositories` - contains the interfaces for the data access of the application
* `data` - contains the data access layer of the application
	+ `datasources` - contains the data sources of the application
	+ `models` - contains the data models of the application
	+ `repositories` - contains the implementations of the repository interfaces
* `presentation` - contains the presentation layer of the application
	+ `blocs` - contains the business logic components of the application
	+ `widgets` - contains the widgets of the application

## Dependencies

This project uses the following dependencies:

* Flutter - the UI framework
* Cupertino Icons - the icons used in the app
* Flutter Bloc - the state management library
* fpdart - the functional programming library
* GetIt - the dependency injection library
* Flutter Native Splash - the library for creating native splash screens
* Equatable - the library for value equality
* Flutter Spinkit - the library for creating loading animations
* Shimmer - the library for creating shimmer effects
* Google Fonts - the library for using Google Fonts
* Flutter Dotenv - the library for using environment variables
* HTTP - the library for making HTTP requests
* WebSocket Channel - the library for creating websockets
* Go Router - the library for client side routing
* Flutter Secure Storage - the library for storing sensitive data
* Dart JSON Web Token - the library for creating JSON Web Tokens
* Pinput - the library for creating pin input fields
* 

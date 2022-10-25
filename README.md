# GitRepoSearch
This project is used to search the GitHub repository by searching keywords. 

As per the API response structure, it's returning 15 records for each call. Once you start scrolling and reach the last row, it's called API again to get more records. 
It will stop the API call once the app gets all repositories for a specific search keyword.

Each row displays the repository name, description, repository URL, Owner name, Owner image, and Owner git profile URL. Once you click the link, it will open in the Safari browser.

## Features
* Incremental search 
* API throttling using Combine Framework
* An asynchronous image downloader
* An asynchronous memory + disk image caching
* MVVM architecture 
* SOLID Principal
* Protocol oriented programming
* Generic code pattern
* Unit test case coverage for business logic

## Frameworks

[Foundation](https://developer.apple.com/documentation/foundation)

[UIKit](https://developer.apple.com/documentation/uikit/)

[Combine](https://developer.apple.com/documentation/combine/)

[XCTest](https://developer.apple.com/documentation/xctest/)

## API
[GitHub Search Repositories](https://docs.github.com/en/rest/search#search-repositories)

## Note
This project doesn't have used any third-party library or cocoa pods.

##
![GitRepoSearch copy](https://user-images.githubusercontent.com/7112264/197776530-12f0f5c7-6795-4f61-9bef-fbd9cc22d8ea.png)



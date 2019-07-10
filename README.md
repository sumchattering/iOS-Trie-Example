#  Backbase Assignment

###  Hey guys! So this turned out to be a bit more difficult than the few hours that I had assigned for it (Was fun though!) Now to finish the readme quickly lets go through your requirements and how they have been tackled in the project. 

Please note. Since I have paid a lot of attention on the performance I havent focused a lot on app architecture or localizations or other stuff. If you would like me to refactor this using VIPER or MVP please let me know and I will have it ready before our next round of interview. Usually I use VIPER in my projects.

>>>> Download the list of cities 

Done and included in the project

>>>> Be able to filter the results by a given prefix string, following these requirements

CityRepository deals with it and its runtime implementation is in CityRepositoryImplementation. It uses a trie to store the list of all countries for fast prefix search (The basic code for the trie is from [github] (https://github.com/raywenderlich/swift-algorithm-club/blob/master/Trie/Trie/Trie/Trie.swift) but I have substantially modified to fit our use case of storing not just words but the city struct for which we use a lookup table / hashmap from city name to cities

>>>> Optimise for fast searches. Loading time of the app is not so important.

The trie prefix search is quite quick indeed. I have added some tests to benchmark it (on my simulator 0.017 seconds)

>>>> Search is case insensitive.

Yes we convert the query to lowercase and trie is case insensitive by default

>>>> Display these cities in a scrollable list, in alphabetical order (city first, country after). Hence, "Denver, US" should appear before "Sydney, Australia".



>>>> The UI should be as responsive as possible while typing in a filter.

The trie makes it quite snappy indeed. I have also added some throttling of the search bar with a nice trick of NSObject.cancelPreviousPerformRequests

>>>> The list should be updated with every character added/removed to/from the filter.

It is updated immediately after a delay of about 0.3 seconds for the throttling

>>>> Each city's cell should: Show the city and country code as title. Show the coordinates as subtitle.

We do have that. Didnt spend too much time on this but usually I dont use storyboards unless I want to finish things really fast :)

>>>> When tapped, navigate the map to the coordinates of the city.

This is done using a split view controller and a simple map view with one annotation.

>>>> Contain a button that, when tapped, opens an information screen about the selected city. opens an information screen about the selected city. The code of this screen is available [here](https://TODO).

Looks like you guys forgot to add a link to the information screen. I guess I will skip this for now :)

>>>> Create a dynamic UI that follows the [wireframe](wireframes). Hence, when in [portrait](wireframes/portrait.png) different screens should be used for the list and map but when in [landscape](wireframes/landscape.png), a single screen should be used.

I have tested on the iPhoneXR simulator and the split view controller does indeed have that behaviour as in the wireframes. (This might not be true for all screen sizes) 

>>>> Provide unit tests showing that your search algorithm is displaying the correct results giving different inputs, including invalid inputs.

These tests can be found in CityRepositoryTests, CityTests and CityTrieTests.

>>>> Provide UI/unit tests for the information screen code we provided you. You are allowed to refactor if needed.

Since the code for the information screen hasnt been linked I couldnt complete this either. Please send me the code for the information screen if you want me to prepare this step before our next interview :)


## Additional requirements/restrictions:

>>>> Database implementations are forbidden.

No databases have been used. The trie can be archived to optimize the load time in subsequent launches but that was not in the requirements so I havent optimized the load time.

>>>> Provide a README.md explaining your approach to solve the search problem and any other important decision you took or assumptions you made during the implementation.

You are reading it :)

>>>> You can preprocess the list into any other representation that you consider more efficient for searches and display. Provide information of why that representation is more efficient in the comments of the code.

The trie is more efficient because it uses a tree with upto 26 children so it finished in logarithmic time. See https://www.raywenderlich.com/892-swift-algorithm-club-swift-trie-data-structure for more details

>>>> Pre-release (e.g. beta) versions of IDEs, SDKs, etc. are forbidden.

None have been used.

>>>> The code of the assignment has to be delivered along with the git repository (.git folder). We want to see the progress evolution. If using a cloud hosted repository, it *must* be a private repository.

The git history is included in the zip file.

>>>> Language can be ObjC or Swift (3 or 4).

It is swift 5 now :)

>>>> Compatible with iOS 10+.

Deployment target has been set to iOS 10

>>>> 3rd party libraries are forbidden.

None have been used. I initially did not read this and then had to remake the project :D

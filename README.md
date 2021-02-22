# SmithsonianDemo
This is my Smithsonian Visualization App. Using the Smithsonian API. This is the public repo, while the development version is held in private. Messages welcome for collaboration or edits :grinning: .

## Usage
As it stands now there is a backend server that handles the rest request from the app to Smithsonians API. This is just to add a level of obfsucation to the request so that I did not post creds. The only thing is there is an IP and port which is hard coded. 

The backend server is a simple python flask server running on a small digital ocean droplet. I only turn it on when I am testing or demoing.

Usage of the app is strait forward, search for a keyword or artist, pick from the list of images. You will be brought to an ARView where you tap the screen for where you want to image to show up. 

The UI needs improvement, it is my first major venture into the realm of UI/UX design. 

## Screenshots

### Search Screen
#### Searching for "Monet"
<img src="https://github.com/DackJempsey/SmithsonianDemo/blob/master/SmithsonianDemoImages/IMG_4263.PNG" height="300">

### ARView

There are a few debug statements and user feedbacks that I need to change. I would like it to be more natural, and have a loading visual so there are not words across the screen

#### Monet image in the wild
<img src="https://github.com/DackJempsey/SmithsonianDemo/blob/master/SmithsonianDemoImages/IMG_4260.PNG" height="300">

#### Getting a little closer 
<img src="https://github.com/DackJempsey/SmithsonianDemo/blob/master/SmithsonianDemoImages/IMG_4262.PNG" height="300">





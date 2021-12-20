# SubitoTest

Architecture:

The architecture is simple. There are three classes (or more if needed) per module. 
ViewController: This class should only manage UILogic. Also, it should be the delegate for all the UI components.

ViewModel: This class should only manage presentation logic.

Service: This class is responsible for business logic. Should contain the proper repository to fetch the data

Connection. The View Controller should bind the ViewModel. 
The ViewModel should have a reference to the Service.

Additional classes: 
Repository: This class should fetch or post the data related to a model.

Coordinator: This class only handles the presentation or navigations between ViewControllers.


Code Requisites
Accessibility: All screens should have minimum accessibility. 
a)The font should be able to scale without breaking constraints.
b)Voice Over should Read all the components or describe the screen correctly

UnitTest: All the classes with any logic should be unit tested. 
(View Controller and Coordinators should not be unit tested)

UITest: With MockResponsesServer, the app is ready to test all the flows. There are no UITest (For time reasons, I did not add the UItest. I made more focus on UnitTest)


How to test the app
Download the repo, go to the root folder. Run "pod install." Run app on Xcode. 
To test accessibility, use the "accessibility inspector."
All fonts should scale properly, and "voice-over" should read all the screens correctly

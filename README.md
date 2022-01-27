# RxNormKit

RxNormKit is a library for embedding RxNorm codes as a Realm database. The example
application included with the library can be run on a Mac OS desktop to read RxNorm
code files and generate a compacted Realm database that can be bundled into an iOS app.

## Generate a database file

1. Download RxNorm files from NIH/NLM:

  https://www.nlm.nih.gov/research/umls/rxnorm/docs/rxnormfiles.html

  For example, the full Current Prescribable list:

  https://download.nlm.nih.gov/rxnorm/RxNorm_full_prescribe_01032022.zip

2. To run the example project, clone the repo, and run `pod install` from the Example directory first.

3. Then, open the `Example/RxNormKit.xcworkspace` in Xcode. Change the build target to `My Mac` and run.

4. Click on `Import` in the toolbar. Find the `RXNCONSO.RRF` in the file browser and click on Open. Currently,
the Example app imports only a subset of records from the file- those with BN (Brand Name), IN (Ingredient Name), and
PSN (Prescribable Name) term types.

5. Wait as the file is parsed and imported into a Realm database, until the spinner disappears and the Export
option is enabled in the toolbar.

6. Click on Export, and select a destination for the Realm database file.

## Installation

1. Include RxNormKit in your iOS app project using [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

  ```ruby
  pod 'RxNormKit'
  ```

2. Add the exported Realm database file generated previously to your iOS app project.

3. Initialize the library with the Realm file, for example in your AppDelegate didFinishLaunchingWithOptions function.

  ```
  import RxNormKit
  ...
  class AppDelegate: UIResponder, UIApplicationDelegate {
      ...
      func application(_ application: UIApplication,
                       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
          ...
          RxNRealm.configure(url: Bundle.main.url(forResource: "RxNorm", withExtension: "realm"), isReadOnly: true)
      }
      ...
  }
  ```

4. Use as with any Realm database model. For example, in a table view controller (see https://docs.mongodb.com/realm/sdk/swift/examples/react-to-changes/#register-a-collection-change-listener):

  ```
  class CodesViewController: UITableViewController {    
      var results: Results<RxNConcept>?
      ...
      func viewDidLoad() {
        ...
        results = RxNRealm.open().objects(RxNConcept.self).sorted(byKeyPath: "name", ascending: true)
      }
      ...      
  }
  ```

## Author

Francis Li, francis@peakresponse.net

## License

RxNormKit  
Copyright (C) 2022 Peak Response Inc.

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA


## Installation

Project use Cocoapods, before open `.xcworkspace` should install Cocoapods

```bash
  pod install
```

## Features

+ The screen `Files in Data` show list file from `Data` folder is `ListFileViewController` 

    + Show list file in OfficialData via `OfficialData` button
    + Select files for import via `Select`, after selection tap to `Import` for prepare data by read content foreach xml file.

+ The screen `Review` for show list instanceID correspond with a xml file, this is `ReviewDataViewController`
    + user perform import file by tap on `Import` button in this screen.
    + step 1: import file from `Data` to `OfficialData` first.
    + step 2: save record to sqlite
    + step 3: close this screen

+ The screen `Files in OfficialData` just show list file is loaded from `OfficialData` folder

## Tech
+ Use PKHUD for show loading/progress
+ Use sqlite library
+ Use OperationQueue for work with background thread


## Need to improve

This demo have many points need to improve:
+ Apply RxSwift
+ Apply MVVM
+ This demo only get a InstanceID for each xml file -> need to load multiple InstanceID from xml file
+ Need to show alert if import a file is existing or other way to handle if have many existing files
+ Need to show content XML file with raw value like `<tag>text</tag>`, currently this app just use webview to show content.

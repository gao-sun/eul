# Issue \#81 show top ram programs design doc #

Created by Jevon Mao on 2020/1/18.

## TL;DR ##

This is a design doc that outlines my plan, tracks my progress, and document any related information to implementing [#81](https://github.com/gao-sun/eul/issues/81) that is a section showing top ram processes similar to the existing top CPU processes.

## Resource References ##

1. https://ss64.com/osx/top.html (Mac terminal command to get top ram processes)

## Implementation Steps ##

1. Test out UI design by creating a SwiftUI view with mock information
2. Use a terminal command to get top ram processes, and parse the command within project
3. Create data model and related functions to store top ram processes
4. Connect view model to SwiftUI view
5. Pull request, improve code if requested by reviewer

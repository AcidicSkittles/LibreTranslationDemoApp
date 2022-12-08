# yikyak-translate-ios - iOS Take Home Project

## Before you start

- Make sure you have the latest stable version of Xcode and have a way to connect to a GitHub repository. You should be ready to run code from a repo on a physical device or simulator.

## Overview

You have been asked to create a translation app! You’ve been given a version that is already partially implemented, but you must finish it off. Currently, the app has a placeholder UI. There is also a button that says “Translate” and a text view that should display the translated result, but both currently do nothing. We would like you to use LibreTranslate API to implement the translation functionality. The documentation for the API is here: [https://libretranslate.com/docs/](https://libretranslate.com/docs/)

![yikyak translate ios start.png](https://github.com/Yik-Yak/yikyak-translate-ios/blob/main/yikyak%20translate%20ios%20start.png)

Your tasks are as follows:

- Fetch the list of languages supported by the LibreTranslate API (use `https://libretranslate.de/` as API Root, this version does not require an auth token). The UI is already set up to allow the user to pick from a list of languages provided by the view model.
- Implement the translation functionality and hook it up to the UI.
- Leave the code better than you found it - if there are places within the code that you feel could be improved, whether it’s a performance issue, architecture issue, or something else entirely, feel free to change it.

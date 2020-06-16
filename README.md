# UnityTravisCI
 Tools and scripts for getting steup with CI using Travis CI
 If package.json is found in the project folder this tool will create a test project and import the package with tests and run the tests.
 

[![Build Status](https://travis-ci.org/coryleach/UnityTravisCI.svg?branch=master)](https://travis-ci.org/coryleach/UnityTravisCI)

| Key                     | Description                                                                                                                                               | Required |
| ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| UNITY_PROJECT_FOLDER    | Directory where project is located. Leave blank if project is at the root.   | No       |
| UNITY_VERSION    | Unity version that will be used to run and build. Uses latest if not specified.   | No       |
| UNITY_SERIAL            | The serial key found at <https://id.unity.com/en/subscriptions>. Keys are only avalible with a Plus or Pro Subscription                                   | Yes      |
| UNITY_USERNAME          | Your email address used to log into <https://unity.com/>.                                                                                                 | Yes      |
| UNITY_PASSWORD          | Your password used to log into <https://unity.com/>.                                                                                                      | Yes  

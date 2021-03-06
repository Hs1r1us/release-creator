# release-creator :pushpin:
<img src="https://github.com/alice-biometrics/custom-emojis/blob/master/images/alice_header.png" width=auto>

This action allows you to create a Github release dynamically. 

## Table of Contents
- [Usage :chart_with_upwards_trend:](#usage-chart_with_upwards_trend)
- [Parameters :gear:](#parameters-gear)
- [Use Cases :eyes:](#use-cases-eyes)
  * [Duplicate Release Notes](#duplicate-release-notes)
- [License :page_facing_up:](#license-page_facing_up)
- [Contact :mailbox_with_mail:](#contact-mailbox_with_mail)

## Usage :chart_with_upwards_trend:

```yml
name: Release Creator

on:
  push:
    branches:
      - master

jobs:
  update:
    runs-on: ubuntu-latest
    name: Create a release
    steps:
      - uses: alice-biometrics/release-creator/@v1.0.4
        with:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          version: 'v2.0.0'
          description: 'This is an awesome version :ok_hand:'
```


## Parameters :gear:

You can configure additional info with the following parameters:


| Param.          | Required | Definition                                                    | 
| -------------   | -------- |:--------------------------------------------------------------| 
| `GITHUB_TOKEN`  | true     | GitHub token                                                  | 
| `version`       | true     | New release version. If your action was generated by a release you can use `inherit` this will get version automatically |  
| `description`   | true     | New release description. If your action was generated by a release you can use `inherit` this will get version automatically                                        |   
| `repo`   | optional     | Destination repo. Default value (`this`) will use current repository  | 
| `branch` | optional     | Destination branch repo. Default value (`master`)| 
| `draft`  | optional     | Define if is a draft or not. Use `"true"` or `"false"` | 
| `prerelease` | optional     | Define if is a prerelease or not. Use `"true"` or `"false"`  | 


example:

```yml
name: Release Creator

on:
  push:
    branches:
      - master

jobs:
  update:
    runs-on: ubuntu-latest
    name: Create a release
    steps:
      - uses: alice-biometrics/release-creator/@v1.0.4
        with:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          version: 'v1.0.0'
          description: 'This is an awesome version :ok_hand:'
          repo: 'alice-biometrics/github-releaser'
          branch: 'master'
          draft: 'false'
          prerelease: 'false'
```

or if you execute the action on `release`:


## Use Cases :eyes:

#### Duplicate Release Notes 

Image you have a private repo where you develop your SDK. Additionally, you've made publicly available a Repo with some documentation about your SDK module.

* private repo: [release-creator-example](https://github.com/alice-biometrics/release-creator-example)
* public repo: [release-creator-example-lib](https://github.com/alice-biometrics/release-creator-example-lib)

Use `release-creator` if you want to copy releases notes from one repo to another with:


From [release-creator-example-lib](https://github.com/alice-biometrics/release-creator-example-lib) :arrow_right: [release-creator-example](https://github.com/alice-biometrics/release-creator-example)

```yml
name: Release Creator

on:
  release:
    types: [published]

jobs:
  update:
    runs-on: ubuntu-latest
    name: Create a release
    steps:
      - uses: alice-biometrics/release-creator/@v1.0.4
        with:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          version: 'inherit'
          description: 'inherit'
          repo: 'alice-biometrics/release-creator-example'
```


## License :page_facing_up:

[MIT](LICENSE)

## Contact :mailbox_with_mail:

support@alicebiometrics.com


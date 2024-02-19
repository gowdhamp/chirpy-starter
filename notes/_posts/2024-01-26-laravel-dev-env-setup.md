---
title: Laravel Development Environment Setup
date: 2023-08-02 11:40 +0530
categories: [Development, Laravel]
tags: [coding, php, laravel, env]
---
# Laravel Development Environment Setup

## Overview

This is a hybrid environment with the web browser and VS Code IDE installed in Win11 and all other dev tools installed in WSL2.

***Win11:***  VS Code IDE with recommended extensions  
***WSL2:***  PHP, MariaDB/Postgres, Laravel, VS Code remote development extensions

This environment does _not_ use docker inside WSL as VS Code extensions cannot work inside docker. Hence all the dev tools are installed natively in WSL and VS Code will automatically detect/install required extensions to work with WSL.

## Software Used

1. Windows 11
2. Ubuntu 22.04 in WSL
3. VS Code
4. Laravel 10.x

## Installation Steps

1. Install Ubuntu 22.04 LTS in WSL
2. Install required packages `apt install php-cli php-common php-curl php-mbstring php-mysql php-xml php-zip php-pgsql`
3. Development packages `apt install git`
4. Database `apt intall mariadb-server` or `apt install postgresql`
5. Download the latest `composer` package to `/usr/local/bin`
6. Use composer to install laravel.

## Installing Language Support for VS Code

1. Install [Laravel IDE Helper](https://github.com/barryvdh/laravel-ide-helper) for full VS Code intellisense support
2. `composer require --dev barryvdh/laravel-ide-helper`
3. Add `/_ide_helper*` to `.gitignore` to ensure ide-helper files are not committed into the Git repo
4. Run `php artisan clear-compiled`
5. Run `php artisan ide-helper:generate` to create Facades
6. Run `php artisan ide-helper:models` to create Models
7. Use the default "no" when prompted.
8. In `composer.json` add the below to ensure IDE helper PHP files are recreated whenever composer updates dependencies.

```json
"scripts": {
	"post-update-cmd": [
		"@ide-helper"
	],
	"ide-helper": [
		"@php artisan ide-helper:generate",
		"@php artisan ide-helper:models -N"
	]
}
```

9. You can now `composer run ide-helper` anytime to recreate the ide-helper files.

## PHP Code Formatting Using Pint

1. Laravel Pint is automatically installed in Laravel v10
2. Install the [Run on Save](https://marketplace.visualstudio.com/items?itemName=emeraldwalk.RunOnSave) VS Code extension
3. In VS Code `settings.json`, add the following code to run pint whenever any `.php` file is saved.

```json
"emeraldwalk.runonsave": {
  "commands": [
    {
      "match": "\\.php$",
      "cmd": "${workspaceFolder}/vendor/bin/pint ${file}"
    }
  ]
}
```

## Rejecting non-Pint Compliant Code in Git

A `git pre-commit` hook can be used to reject any PHP code is not compliant with Pint.

Note that Pint does not support blade templates at this time.

Setting up the git hooks directory in the project root directory is useful as it makes it available for every member of the project team. This provides a consistent environment and behavior for everyone which is great.

1. Setup a new `.githooks` folder and copy the `pre-commit` bash script for customization.

```bash
mkdir .githooks
cp .git/hooks/pre-commit.sample .githooks/pre-commit
```

2. Add the below lines to the top of the `.githooks/pre-commit` bash script.

```bash
# Ensure the committed files are Pint compliant.
echo "Running Laravel Pint..."
if ! ./vendor/bin/pint --dirty --test
then
    echo "Pint errors detected, git commit aborted."
    exit 1
fi
```

3. Change the git hooks directory from the default `.git/hooks` to `.githooks` by running `git config core.hooksPath .githooks`. To automate this for other developers, add the below JSON snippet to the `composer.json` / `scripts` / `post-autoload-dump` section. The`post-autoload-dump` scripts are executed whenever composer `install` or `udpate` commands is invoked. See [Composer Scripts](https://getcomposer.org/doc/articles/scripts.md).

```json
"scripts": {
        "post-autoload-dump": [
            "Illuminate\\Foundation\\ComposerScripts::postAutoloadDump",
            "@php artisan package:discover --ansi",
            "git config core.hooksPath .githooks"
        ],
}
```


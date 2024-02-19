# My Self-Hosted Documentation Site TEMPLATE

This repository contains the source code for my self-hosted documentation site, which is built using Jekyll with a base template from the Chirpy Jekyll theme.

## Setup Instructions

1. **Update Site Details**: Update the site details in the `notes/_config.yml` file to personalize it according to the preferences. This includes things like site title, description, author information, etc.

2. **Replace Favicons and Android Icons**: Replace the default favicons and Android icons in the `notes/assets/images/favicons` directory to customize the appearance of the site.

3. **Store Markdown Files**: Markdown files for the documentation should be stored in the `notes/_posts` directory. Ensure each markdown file follows the naming convention: `YYYY-MM-DD-TITLE.md`.

4. **Add Front Matter**: At the top of each markdown file (`*.md`), include front matter to provide metadata about the markdown. Here's an example of what the front matter should look like:

```
---
title: TITLE
date: YYYY-MM-DD HH:MM:SS +/-TTTT
categories: [TOP_CATEGORIE, SUB_CATEGORIE]
tags: [TAG]     # TAG names should always be lowercase
---
```

## Serving the Site

Once completed the necessary changes, Build and Deploy the docker container by running `docker-compose up -d -build`.

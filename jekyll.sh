#!/bin/bash

export JEKYLL_VERSION=3.8.6

new() {

    mkdir -p _bundle
    mkdir -p _layouts
    mkdir -p _site

    cat >_layouts/default.html <<EOF
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{{ page.title }}</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.1/font/bootstrap-icons.css">
</head>
<body>
    <main class="container">
        {{ content }}
    </main>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p"
        crossorigin="anonymous"></script>
</body>
</html>
EOF

    cat >_config.yml <<EOF
markdown_ext: "md,html"
exclude: 
  - Gemfile
  - Gemfile.lock
  - jekyll.sh
  - README.md
EOF

    cat >Gemfile <<EOF
source "https://rubygems.org"

gem "minima", "~> 2.5"
gem "github-pages", group: :jekyll_plugins

group :jekyll_plugins do
end
EOF

    cat >index.html <<EOF
---
---
<p>Hello from Jekyll!</p>
EOF

    cat >.gitignore <<EOF
_bundle/
_site/
EOF

}

run() {

    docker run --rm \
        --env JEKYLL_UID=$UID \
        --env JEKYLL_GID=$UID \
        --volume="$PWD:/srv/jekyll" \
        --volume="$PWD/_site:/srv/jekyll/_site" \
        --volume="$PWD/_bundle:/usr/local/bundle" \
        --publish 4000:4000 \
        --publish 35729:35729 \
        jekyll/jekyll:$JEKYLL_VERSION \
        jekyll serve --livereload --incremental
}

update() {

    docker run --rm \
        --env JEKYLL_UID=$UID \
        --env JEKYLL_GID=$UID \
        --volume="$PWD:/srv/jekyll" \
        --volume="$PWD/_site:/srv/jekyll/_site" \
        --volume="$PWD/_bundle:/usr/local/bundle" \
        jekyll/jekyll:$JEKYLL_VERSION \
        bundle update
}

case $1 in
new)
    new
    ;;
run)
    run
    ;;
update)
    update
    ;;
*)
    echo "Usage: $0 run | update | new"
    ;;
esac

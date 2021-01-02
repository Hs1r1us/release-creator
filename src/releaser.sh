#!/usr/bin/env bash

releaser::create() {
  local version="$1"
  local description="$2"
  local -r repo="$3"
  local -r branch="$4"
  local -r draft="$5"
  local -r prerelease="$6"

  if [ "$repo" == "this" ]; then
    repo=$GITHUB_REPOSITORY
  fi

  if [ "$version" == "inherit" ]; then
    version=$(github::get_latest_release_version "$GITHUB_REPOSITORY")
  fi
  
  if [ "$description" == "inherit" ]; then
    description=$(github::get_latest_release_body "$GITHUB_REPOSITORY")
  fi

  release_data=$(printf '{"tag_name": "%s","target_commitish": "%s","name": "%s","body": "%s","draft": %s,"prerelease": %s}' "$version" "$branch" "$version" "$description" "$draft" "$prerelease" )

  echo "$release_data"

  response=$(github::create_release "$release_data" "$repo") || (echo "::error::$response" && return -1)
  
  if [ "$repo" != "$GITHUB_REPOSITORY"  ];then
    github::get_latest_release_assets "$GITHUB_REPOSITORY"

    upload_url=$(echo $response | jq '.upload_url' | sed 's/"//g')
  
    github::upload_release_assets "$upload_url" "$repo" || (echo "::error::" && echo "upload error" && return -1)
  fi
}
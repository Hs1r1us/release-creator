github::create_release() {
  local -r release_data=$1
  local -r repo=$2

  response=$(curl -sSL \
  -X POST \
  -w  %{http_code} \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "$GITHUB_API_HEADER" \
  --data "$release_data" \
   "$GITHUB_API_URI/repos/$repo/releases")

  http_code=${response##*\}}
  
  echo ${response%$http_code*}

  if [ "$http_code" -ne 201 ];then
    return -1
  fi
}

github::get_latest_release_version() {
  local -r repo=$1

  latest_release=$(curl -sSL \
  -X GET \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "$GITHUB_API_HEADER" \
   "$GITHUB_API_URI/repos/$repo/releases/latest")

  echo $(echo $latest_release | jq '.tag_name') | sed 's/"//g'
}

github::get_latest_release_body() {
  local -r repo=$1

  latest_release=$(curl -sSL \
  -X GET \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "$GITHUB_API_HEADER" \
   "$GITHUB_API_URI/repos/$repo/releases/latest")

  echo $(echo $latest_release | jq '.body') | sed 's/"//g'
}

github::get_latest_release_assets(){
  local -r repo=$1

  GITHUB_API_ASSETS_HEADER="Accept: application/octet-stream"
  
  latest_release=$(curl -sSL \
  -X GET \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "$GITHUB_API_HEADER" \
   "$GITHUB_API_URI/repos/$repo/releases/latest")
   
  asset_num=$(echo $latest_release | jq '.assets | length')
  
  if [ "$asset_num" -gt 0 ];then
    mkdir ./asset_files
    cd ./asset_files
    for i in $(seq 0 $((asset_num-1)));
    do
      file_name=$(echo $latest_release | jq '.assets['$i'].name' | sed 's/"//g')
      file_url=$(echo $latest_release | jq '.assets['$i'].url' | sed 's/"//g')

      echo "download $file_name"

      curl -sSL \
      -X GET \
      -H "Authorization: token $GITHUB_TOKEN" \
      -H "$GITHUB_API_ASSETS_HEADER" \
      -o "$file_name" \
       "$file_url"
    done
    cd ..
  fi
}

github::upload_release_assets(){
  local -r url=${1%\{*} 
  local -r reop=$2

  if [ -d "./asset_files" ];then
    cd ./asset_files
    for asset_name in * ;
    do
      if [ -f $asset_name ];then
        echo "::group::upload $asset_name"

        response=$(curl -sSL \
        -X POST \
        -w  %{http_code} \
        -H "Authorization: token $GITHUB_TOKEN" \
        -H "Content-Type: $(file -b --mime-type $asset_name)" \
        --data-binary @$asset_name \
         "$url?name=$asset_name")

        http_code=${response##*\}}

        echo ${response%$http_code*}

        if [ "$http_code" -ne 201 ];then
          return -1
        fi

        echo "::endgroup::"
      fi
    done
    cd ..
  fi
}
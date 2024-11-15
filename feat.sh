#!/bin/sh
set -e
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -e|--extension)
      EXTENSION="$2"
      shift # past argument
      shift # past value
      ;;
    -s|--searchpath)
      SEARCHPATH="$2"
      shift # past argument
      shift # past value
      ;;
    --delete)
      DELETE=YES
      shift # past argument
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
    POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

CURRENT_BRANCH=`git rev-parse --abbrev-ref HEAD`
if { [ "$CURRENT_BRANCH" != "main" ] && [ "$CURRENT_BRANCH" != "master" ]; } && [ "$DELETE" != "YES" ]
then
        echo "You must be on the main branch to create a feature branch"
        exit 1
fi

# echo "extension: $EXTENSION"
# echo "searchpath: $SEARCHPATH"
# echo "default: $DEFAULT"
# echo "positional args: $@"
# echo "positional args: $POSITIONAL_ARGS"

if [ "$DELETE" == "YES" ] && { [ "$@" = "master" ] || [ "$@" = "develop" ] || [ "$@" = "main" ]; }
then
        echo "Deleting master/main and develop branches not alloed"
        exit 1
fi

if [ -z "$@" ]
then
        echo "eksempel på kall: feat.sh <feature branch> (e.g 1234-feat-my-feature)"
        exit 1
else
        BRANCH=$@
        echo "branch: "$BRANCH
fi

if [ "$DELETE" == "YES" ]
then
        echo "Deleting branch: "$BRANCH
        git branch -d $BRANCH
        git push origin --delete "feature/$BRANCH"
else
        echo "Creating branch: "$BRANCH
        git checkout main
        git pull
        git checkout -b "feature/$1" main
        git push -u origin "feature/$1"
fi

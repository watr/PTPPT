cd "`dirname "$0"`"
carthage build --no-skip-current
carthage archive PTPPT

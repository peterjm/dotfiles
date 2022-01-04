# return false; if git freeze is available the function will be overwritten by include
function git-frozen () {
  return 1
}
source_if_exists "$HOME/lib/git-freeze.sh"

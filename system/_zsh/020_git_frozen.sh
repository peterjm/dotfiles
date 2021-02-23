# return false; if git freeze is available the function will be overwritten by include
function git-frozen () {
  return 1
}
[ ! -f "$HOME/lib/git-freeze.sh" ] || source "$HOME/lib/git-freeze.sh"

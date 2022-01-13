VSCODE_APP="/Applications/Visual Studio Code.app"
if [ -s $VSCODE_APP ]; then
  export PATH="$PATH:$VSCODE_APP/Contents/Resources/app/bin"
fi

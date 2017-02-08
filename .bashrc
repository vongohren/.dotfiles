export PATH="$PATH:/Applications/Postgres.app/Contents/Versions/9.3/bin"
export ANDROID_HOME='/Users/snorreedwin/Library/Android/sdk'
export PATH=${PATH}:${ANDROID_HOME}/tools
export PATH=${PATH}:${ANDROID_HOME}/platform-tools
export PATH="$PATH:/Users/snorreedwin/.npm/bin"
export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
export PATH="/usr/local/bin:$PATH"
setjdk() {
  export JAVA_HOME=$(/usr/libexec/java_home -v $1)
}
export HOME='/Users/snorreedwin'
export PATH="$PATH:$HOME/Code/Gocode/bin"
export PATH="/opt/local/bin:$PATH"
export GOPATH="$HOME/Code/Gocode"
export GOBIN="$GOPATH/bin"

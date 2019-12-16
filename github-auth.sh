#usr/bin/expect -f

github_token=`cat /mnt/c/Users/zzand/Google\ Drive/github-cli-token.txt`

expect <<- DONE
  set timeout -1
  spawn git push origin HEAD

  expect "Username for 'https://github.com':"
  send -- "zzandland\r"

  expect "Password for 'https://zzandland@github.com':"
  send -- "$github_token\n"

  expect eof
DONE

# Useful git command

## Add an alias to push a new branch to origin
```
git config --global alias.newpush '!git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)'
```



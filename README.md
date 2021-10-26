### `git`

```sh
echo '$Format:Last commit: %h by %aN at %cd%n%+w(76,6,9)%B$' > LAST_COMMIT
echo 'Last commit date: $Format:%cd by %aN$' > LAST_COMMIT
echo '$Id$' > security.txt

git archive HEAD  --format tgz --worktree-attributes -o HEAD.tgz
```

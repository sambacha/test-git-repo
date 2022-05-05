[![codenotify](https://github.com/sambacha/test-git-repo/actions/workflows/codenotify.yml/badge.svg)](https://github.com/sambacha/test-git-repo/actions/workflows/codenotify.yml)

### `git repo utils`

#### Motivation

- Automate admin. tasks  
- Reduce surface area of potential attacks  
- Reduce surface area of trusted workflows (see, `git is apart of the trusted computing base`)  
- Tooling to check configuration weaknesses   
- Tooling to automate analysis (static, etc)  

### Overview

- perl script for extracting chomod permissions
- codenotification for changes to certain files
- automate meaningful hash for end user verification of deployed artifacts, etc


### Misc Scripts

```sh
echo '$Format:Last commit: %h by %aN at %cd%n%+w(76,6,9)%B$' > LAST_COMMIT
echo 'Last commit date: $Format:%cd by %aN$' > LAST_COMMIT
echo '$Id$' > security.txt

git archive HEAD  --format tgz --worktree-attributes -o HEAD.tgz

TZ=UTC git show --quiet --date="format-local:%Y.%-m.%-d" --format="nightly-%cd" >nightly-release.txt
```


echo '$Format:Last commit: %h by %aN at %cd%n%+w(76,6,9)%B$' > LAST_COMMIT
echo 'Last commit date: $Format:%cd by %aN$' > LAST_COMMIT
echo '$Id$' > security.txt

git archive HEAD  --format tgz --worktree-attributes -o HEAD.tgz


`git rev-list ^#{sha}^@ refs/remotes/#{remote_ref}`

### server side

```sh
files_modified = `git log -1 --name-only --pretty=format:'' #{ref}`
```

you have to use:
#### client side 
```sh
files_modified = `git diff-index --cached --name-only HEAD`
```

```ruby
#!/usr/bin/env ruby

base_branch = ARGV[0]
if ARGV[1]
  topic_branch = ARGV[1]
else
  topic_branch = "HEAD"
end

target_shas = `git rev-list #{base_branch}..#{topic_branch}`.split("\n")
remote_refs = `git branch -r`.split("\n").map { |r| r.strip }

target_shas.each do |sha|
  remote_refs.each do |remote_ref|
    shas_pushed = `git rev-list ^#{sha}^@ refs/remotes/#{remote_ref}`
    if shas_pushed.split("\n").include?(sha)
      puts "[POLICY] Commit #{sha} has already been pushed to #{remote_ref}"
      exit 1
    end
  end
end
```

### check_directory_perms

```ruby
#!/usr/bin/env ruby

$user    = ENV['USER']

# [ insert acl_access_data method from above ]

# only allows certain users to modify certain subdirectories in a project
def check_directory_perms
  access = get_acl_access_data('.git/acl')

  files_modified = `git diff-index --cached --name-only HEAD`.split("\n")
  files_modified.each do |path|
    next if path.size == 0
    has_file_access = false
    access[$user].each do |access_path|
    if !access_path || (path.index(access_path) == 0)
      has_file_access = true
    end
    if !has_file_access
      puts "[POLICY] You do not have access to push to #{path}"
      exit 1
    end
  end
end

check_directory_perms
```

```ruby
# only allows certain users to modify certain subdirectories in a project
def check_directory_perms
  access = get_acl_access_data('acl')

  # see if anyone is trying to push something they can't
  new_commits = `git rev-list #{$oldrev}..#{$newrev}`.split("\n")
  new_commits.each do |rev|
    files_modified = `git log -1 --name-only --pretty=format:'' #{rev}`.split("\n")
    files_modified.each do |path|
      next if path.size == 0
      has_file_access = false
      access[$user].each do |access_path|
        if !access_path  # user has access to everything
           || (path.start_with? access_path) # access to this path
          has_file_access = true
        end
      end
      if !has_file_access
        puts "[POLICY] You do not have access to push to #{path}"
        exit 1
      end
    end
  end
end

check_directory_perms
```

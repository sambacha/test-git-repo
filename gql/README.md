## pullrequest-by-org

```gql
{
  organization(login: "PUT_YOUR_ORG_HERE") {
    id
    name
    teams(first: 1) {
      edges {
        node {
          id
          organization {
            id
          }
          name
          members(first: 1) {
            nodes {
              id
              name
              login
              createdAt
              pullRequests(first: 10) {
                edges {
                  node {
                    id
                    number
                    title
                    state
                    mergedAt
                    createdAt
                    additions
                    deletions
                    commits(first: 1) {
                      edges {
                        node {
                          commit {
                            sha: oid
                            committedDate
                          }
                        }
                      }
                      # Use this value to paginate the commit result set
                      # by applying it to the 'after:' filter in the commit query                      
                      pageInfo {
                        endCursor
                      }
                    }
                    comments(last: 1) {
                      nodes {
                        lastCommentDate: createdAt
                      }
                    }
                  }
                }
                # Use this value to paginate the pull request result set
                # by applying it to the 'after:' filter in the commit query
                pageInfo {
                  endCursor
                }
              }
            }
            # Use this value to paginate the member result set
            # by applying it to the 'after:' filter in the commit query
            pageInfo {
              endCursor
            }
          }
        }
      }
      # Use this value to paginate the team result set
      # by applying it to the 'after:' filter in the commit query
      pageInfo{
        endCursor
      }
    }
  }
}
```

## branches-by-repository

```gql
query {
  organization (login: "PUT_YOUR_ORG_HERE") {
    repository (name: "PUT_YOUR_REPO_NAME_HERE") {
      id
      name
      refs (refPrefix: "refs/heads/", first: 10) {
        edges {
          node {
            id
            name
          }
        }
        pageInfo {
          endCursor
        }
      }
    }
  }
}
```

## commits-by-branch-and-repository

```gql
{
  organization(login:"PUT_YOUR_ORG_HERE"){
    teams(first: 10){
      nodes {
        name
        repositories(first:10){
          nodes{
            name
            # To get a list of valid qualifiedNames, run branches-by-repository query
            ref(qualifiedName:"master"){
              target{
                 ... on Commit{
                  history(first:100){
                    nodes{
                      messageHeadline
                      committedDate
                      author{
                        name
                        email
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
```



## pullrequest-by-branch

```gql
{
  organization (login: "PUT_YOUR_ORG_HERE") {
    # Replace 'name' with the repository you want a list of branches for.
    repository (name: "PUT_YOUR_REPO_NAME_HERE") {
      id
      name
      refs (refPrefix: "refs/heads/", first: 25) {
        edges {
          node {
            id
            name
            associatedPullRequests(first:100){
              edges{
                node{
                  id
                  number
                  title
                }
              }
              pageInfo {
                endCursor
              }
            }
          }
        }
        pageInfo {
          endCursor
        }
      }
    }
  }
}
```

## stale-pull-requests

After speaking about a valuable team level metric with Leonid, this call could be used to determine if a pull request has been open for longer than an agreed upon time span.
1. Calculate the average age of closed PRs
2. Then use this data to determine which PRs are older than the average age of closed requests to identify potential stale pull requests. Team leads can then take action on these particular requests.

```gql
{	
  search(first: 25, type: ISSUE, query: "org:PUT_YOUR_ORG_HERE type:pr state:open created:>2017-09-01 sort:created-asc") {	
    nodes {	
      ... on PullRequest {	
        id	
        number	
        title	
        state	
        createdAt	
        commits(last: 1) {	
          nodes {	
            commit {	
              lastCommittedDate: committedDate	
            }	
          }	
        }	
        comments(last: 1) {	
          nodes {	
            lastCommentDate: createdAt	
          }	
        }	
      }	
    }	
    pageInfo {	
      endCursor	
    }	
  }	
}	
```

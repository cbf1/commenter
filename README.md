# Commenter

**`commenter` is a tool to create and update comments on GitHub issues and pull requests.**

## Installation

### Via Homebrew

```
$ brew install chrisfuller/homebrew-tap/commenter
```

### From Source

```
$ git clone https://github.com/chrisfuller/commenter.git
$ cd commenter
$ make install
```

## Usage

Create comment on issue or pull request:

```
$ commenter --owner "owner" --repo "repo" --token "${GITHUB_API_TOKEN}" --issue 1 --id $(uuidgen) --comment "Hello World"
```

Create or update comment matching identifier:

```
$ commenter --owner "owner" --repo "repo" --token "${GITHUB_API_TOKEN}" --issue 1 --id "identifier" --comment "Hello World"
```

Create or update comment matching default identifier:

```
$ commenter --owner "owner" --repo "repo" --token "${GITHUB_API_TOKEN}" --issue 1 --comment "Hello World"
```

Read comment from standard input:

```
$ echo "Hello World" | commenter --owner "owner" --repo "repo" --token "${GITHUB_API_TOKEN}" --issue 1
```

# Release sandbox B

A dummy app for testing a release control service with GitHub Actions. It holds nothing real: a static page
showing the commit and environment it was deployed as.

Every pull request title needs a ticket key, for example `AIT-1 Change the greeting`: `main` only accepts commits
with one. Merging to `main` builds the page, then deploys it to `stg` (http://localhost:8091) and `prod`
(http://localhost:8092) on the sandbox PC, each after the release control GitHub App approves.

Set-up instructions live with the release control service, not here.

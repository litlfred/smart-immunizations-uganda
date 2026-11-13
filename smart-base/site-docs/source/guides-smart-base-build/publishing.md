**A merged pull request publishes the site.** A push to `main` that changes
`input/`, `sushi-config.yaml` or `ig.ini` refreshes the AST, and every push to
`main` republishes the site. The publish waits for that commit's AST refresh
(`"publishAfter": ["ig-ast-refresh.yml"]` in `index.config.json`). Previews of
other branches, and every other workflow here, are started by hand from the
Actions tab.

| Workflow | What it does |
|---|---|
| [`ig-ast-refresh.yml`](https://github.com/litlfred/smart-base/blob/main/.github/workflows/ig-ast-refresh.yml) | on a push to `main` that changes the IG's inputs, and by hand. Calls the FHIR IG layer's reusable refresh, with `pre-export: bash smart-base/scripts/dak-pre-export.sh` and the WHO template. Seeds the AST cache from `main` |
| [`site-publish.yml`](https://github.com/litlfred/smart-base/blob/main/.github/workflows/site-publish.yml) | on every push to `main`, and by hand. Calls cat-harness-tools' reusable `folio-site-publish.yml`, which mounts the layers and runs `stage-local.ts --repo .`. On `main` it publishes the `gh-pages` root; on another branch, `branches/<branch>/` |
| [`standing-repin.yml`](https://github.com/litlfred/smart-base/blob/main/.github/workflows/standing-repin.yml) | when an upstream layer merges, and by hand: opens one PR that moves the pins a standing consent covers |
| [`pr-preview.yml`](https://github.com/litlfred/smart-base/blob/main/.github/workflows/pr-preview.yml) | a pull request preview, deployed after a collaborator approves it in the `pr-preview` environment |
| [`ghbuild.yml`](https://github.com/litlfred/smart-base/blob/main/.github/workflows/ghbuild.yml) | the plain WHO build (above) |
| [`release.yml`](https://github.com/litlfred/smart-base/blob/main/.github/workflows/release.yml) | checks `publication-request.json` for a release |

The `gh-pages` root publish also keeps `v0/`, `ns/`, `0.1.0/` and
`sitepreview/` (`site.build.keep` in `index.config.json`): the JSON-LD
vocabulary and context that `publish-context.yml` writes. A root publish that
would drop one of them is refused.

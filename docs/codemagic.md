# Codemagic automation

The repository uses `codemagic.yaml` as the source of truth for CI/CD. The
Codemagic Workflow Editor configuration is not used after the YAML file is
detected from the selected branch.

## Workflows

- `continuous-integration` runs formatting, analysis, tests, an Android debug
  build, and an unsigned iOS build on pushes and pull requests involving
  `develop` or `main`.
- `android-internal-release` builds a signed Android App Bundle and uploads it
  to the Google Play internal track for semantic version tags such as `v1.0.0`.
- `ios-testflight-release` builds a signed IPA and uploads it to TestFlight for
  the same semantic version tags.

Release workflows use Codemagic's `PROJECT_BUILD_NUMBER` as the platform build
number. The public version continues to come from `pubspec.yaml`.

## Codemagic configuration

Create the following resources in Codemagic before running a release workflow.
Never store their contents in this repository.

### Android

1. Under **Team settings > codemagic.yaml settings > Code signing identities >
   Android keystores**, upload the Google Play upload keystore with reference
   name `oculos_lay_upload`.
2. Create an environment variable group named `google_play`.
3. Add the secret variable `GOOGLE_PLAY_SERVICE_ACCOUNT_CREDENTIALS` to that
   group, containing the complete Google Play service-account JSON document.
4. Give the service account permission to publish the application
   `br.com.oculoslay.oculos_lay` in Google Play Console.

Keep an independent, encrypted backup of the upload keystore and its passwords.
Codemagic does not provide a way to download an uploaded keystore.

### iOS

1. Create the application with bundle identifier
   `br.com.oculoslay.oculosLay` in Apple Developer and App Store Connect.
2. Under **Team integrations > Developer Portal**, add an App Store Connect API
   key with reference name `oculos_lay_app_store`.
3. Allow Codemagic to fetch or create the matching Apple Distribution
   certificate and App Store provisioning profile.
4. Complete the TestFlight application metadata and compliance information
   required by Apple.

## Releasing

Update the version in `pubspec.yaml`, merge the tested change, and create a
semantic version tag:

```shell
git tag v1.0.0
git push origin v1.0.0
```

The tag starts the Android and iOS release workflows in parallel. Each workflow
first verifies that the tagged commit belongs to the remote `main` branch and
stops before signing or publishing if it does not. Android is submitted as a
draft to the internal testing track. iOS is uploaded and submitted to
TestFlight, but is not submitted to App Store review.

Production rollout remains a deliberate action in the store consoles until a
separate production-release policy is approved.

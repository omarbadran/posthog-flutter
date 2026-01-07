[![Package on pub.dev][pubdev_badge]][pubdev_link]

# PostHog Flutter

Please see the main [PostHog docs](https://posthog.com/docs).

Specifically, the [Flutter docs](https://posthog.com/docs/libraries/flutter) details.

## Install from Git (forks)

If you need to use a fork (e.g. to pick up unreleased changes), you can depend on this package via Git:

```yaml
dependencies:
	posthog_flutter:
		git:
			url: https://github.com/omarbadran/posthog-flutter
			# ref: <COMMIT_SHA> # recommended for reproducible builds
```

## Event-level groups

This fork includes support for attaching groups to a single event using `Posthog().capture(groups: ...)` (non-persistent).

See [docs/event-level-groups.md](docs/event-level-groups.md) for details and examples.

## Questions?

### [Check out our community page.](https://posthog.com/posts)

[pubdev_badge]: https://img.shields.io/pub/v/posthog_flutter
[pubdev_link]: https://pub.dev/packages/posthog_flutter

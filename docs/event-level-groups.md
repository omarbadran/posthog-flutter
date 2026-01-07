# Event-level groups (`capture(groups: ...)`)

PostHog group analytics supports associating events with groups in two ways:

- **Persistent** groups via `Posthog().group(...)` (recommended by PostHog, but it affects all subsequent events until changed)
- **Event-level** groups via the event property `$groups` (associates only a single event)

This repo adds a missing capability: attaching groups to a single `capture()` call without persisting them.

## Why this exists

If you have multiple “global” groups you can set at login (e.g. `company`, `team`), but also have a third group that only applies to some events (e.g. `project`, `workspace`, `campaign`), then using `group()` for the third group is problematic because it will stick for future events.

With this change, you can do:

- `group()` for the login-time groups
- `capture(groups: ...)` for event-only groups

## Install from Git

In your app’s `pubspec.yaml`:

```yaml
dependencies:
  posthog_flutter:
    git:
      url: https://github.com/omarbadran/posthog-flutter
      # Prefer pinning to a commit SHA for reproducible builds:
      # ref: <COMMIT_SHA>
      # Or use a branch name:
      # ref: feat/event-level-groups
```

Then run:

```bash
flutter pub get
```

## Usage

### Persistent groups (login-time)

```dart
await Posthog().group(groupType: 'company', groupKey: companyId);
await Posthog().group(groupType: 'team', groupKey: teamId);
```

### Event-level groups (non-persistent)

Attach one or more groups to a single event:

```dart
await Posthog().capture(
  eventName: 'task created',
  properties: {
    'task_id': taskId,
  },
  groups: {
    'project': projectId,
  },
);
```

Attach multiple groups to the same event:

```dart
await Posthog().capture(
  eventName: 'file uploaded',
  groups: {
    'project': projectId,
    'workspace': workspaceId,
  },
);
```

### Merging behavior

- The SDK injects `groups:` into the event as the `$groups` property.
- If you already set `'$groups'` inside `properties`, the SDK merges the two maps.
- If the same group type exists in both, values from `groups:` win.

## Notes

- This does **not** change `Posthog().group(...)` behavior.
- This is intentionally not “sticky”: it affects only the single `capture()` call.

# Dialog Invariants

These invariants are guaranteed by `CDKDialogsManager` and covered by widget tests.

- `Escape` closes only the top-most dialog that is configured as `dismissOnEscape: true`.
- Outside-click closes only the top-most dialog configured as `dismissOnOutsideTap: true`.
- Popovers (`showPopover`, `showPopoverArrowed`) default to outside-click dismissal.
- Modal dialogs (`showModal`) default to no outside-click dismissal.
- Focus is moved to the active dialog host on open and restored to the previous focus node on close.
- If an anchor widget is removed before post-frame positioning, the dialog auto-closes without throwing.
- `CDKDialogConfirm` maps `Enter` to confirm and `Escape` to cancel.
- `CDKDialogPrompt` autofocuses the input, validates before submit, and maps `Escape` to cancel.
- Popovers (`showPopover`, `showPopoverArrowed`) default to `showBackgroundShade: false`.
- Modal and draggable dialogs default to `showBackgroundShade: false`.
- Confirm and prompt helpers default to `showBackgroundShade: true`, drawing a gray barrier behind the active dialog and blocking background interaction.

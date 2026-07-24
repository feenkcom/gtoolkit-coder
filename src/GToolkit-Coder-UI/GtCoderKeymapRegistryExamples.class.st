"
I contain examples for GtCoderKeymapRegistry verifying that all coder-specific keyboard shortcuts are properly registered.
"
Class {
	#name : #GtCoderKeymapRegistryExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-UI-Examples'
}

{ #category : #examples }
GtCoderKeymapRegistryExamples >> allEntriesHaveShortcutId [
	<gtExample>
	<return: #GtCoderKeymapRegistry>
	"Verifies that every entry in the coder registry has its shortcutId set"
	| registry |
	registry := self coderKeymapRegistry.
	registry keymapsById keysAndValuesDo: [ :shortcutId :entry |
		self assert: entry shortcutId notNil.
		self assert: entry shortcutId equals: shortcutId ].
	^ registry
]

{ #category : #examples }
GtCoderKeymapRegistryExamples >> browseImplementorsShortcutPresent [
	<gtExample>
	<return: #GtCoderKeymapRegistry>
	"Verifies that the BrowseImplementors shortcut is registered"
	| registry shortcutId |
	registry := self coderKeymapRegistry.
	shortcutId := GtCoderShortcutIds default browseImplementorsShortcutId.
	self assert: (registry hasCombinationFor: shortcutId).
	self assert: (registry combinationFor: shortcutId) notNil.
	^ registry
]

{ #category : #examples }
GtCoderKeymapRegistryExamples >> coderKeymapRegistry [
	<gtExample>
	<return: #GtCoderKeymapRegistry>
	| registry |
	registry := GtCoderKeymapRegistry new.
	self assert: registry numberOfKeymaps >= 23.
	^ registry
]

{ #category : #examples }
GtCoderKeymapRegistryExamples >> extensionShortcutsPresent [
	<gtExample>
	<return: #GtCoderKeymapRegistry>
	"Verifies that extension shortcuts from other packages are registered via pluggable mechanism"
	| registry |
	registry := self coderKeymapRegistry.
	self assert: (registry hasCombinationFor: GtCoderShortcutIds default inlineRenameShortcutId).
	self assert: (registry hasCombinationFor: GtCoderShortcutIds default fixItShortcutId).
	self assert: (registry hasCombinationFor: GtCoderShortcutIds default addBreakpointShortcutId).
	^ registry
]

{ #category : #examples }
GtCoderKeymapRegistryExamples >> registryDiscoveredByGlobalRegistry [
	<gtExample>
	<return: #GtCoderKeymapRegistry>
	"Verifies that the coder registry is discovered by the global BlShortcutKeymapRegistry"
	| globalRegistry coderRegistry |
	globalRegistry := BlShortcutKeymapRegistry default.
	coderRegistry := globalRegistry coder.
	self assert: coderRegistry notNil.
	self assert: coderRegistry class equals: GtCoderKeymapRegistry.
	^ coderRegistry
]

{ #category : #examples }
GtCoderKeymapRegistryExamples >> shortcutResolvesFromCoderRegistry [
	<gtExample>
	<return: #GtSourceCoderBrowseImplementorsShortcut>
	"Verifies that a coder shortcut resolves its combination from the registry"
	| shortcut |
	shortcut := GtSourceCoderBrowseImplementorsShortcut new.
	self assert: shortcut shortcutId notNil.
	self assert: shortcut combination notNil.
	^ shortcut
]

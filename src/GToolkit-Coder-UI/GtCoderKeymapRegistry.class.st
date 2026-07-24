"
I am the keymap registry category for coder shortcuts. I hold the default key combinations for all GtSourceCoderShortcut subclasses.

Core shortcuts (in GToolkit-Coder-UI) are registered in initializeBasicCombinations. Shortcuts from other packages are added via extension methods with the <gtKeymapRegistration> pragma, which are discovered automatically by initializePluggableCombinations.
"
Class {
	#name : #GtCoderKeymapRegistry,
	#superclass : #BlShortcutKeymapRegistryCategory,
	#category : #'GToolkit-Coder-UI-Shortcuts'
}

{ #category : #accessing }
GtCoderKeymapRegistry class >> registryLabel [
	^ 'Coder'
]

{ #category : #defaults }
GtCoderKeymapRegistry >> defaultBrowseBehaviorShortcutCombination [
	^ BlKeyCombination primaryB
]

{ #category : #defaults }
GtCoderKeymapRegistry >> defaultBrowseImplementorsShortcutCombination [
	^ BlKeyCombination primaryM
]

{ #category : #defaults }
GtCoderKeymapRegistry >> defaultBrowseReferencesShortcutCombination [
	^ BlKeyCombination primaryN
]

{ #category : #defaults }
GtCoderKeymapRegistry >> defaultCompileItShortcutCombination [
	^ BlKeyCombination primaryS
]

{ #category : #defaults }
GtCoderKeymapRegistry >> defaultDebugShortcutCombination [
	^ BlKeyCombinationBuilder new primary shift d build
]

{ #category : #defaults }
GtCoderKeymapRegistry >> defaultDiscardChangesShortcutCombination [
	^ BlKeyCombination primaryL
]

{ #category : #defaults }
GtCoderKeymapRegistry >> defaultDoItAndInspectAsynchronousShortcutCombination [
	^ BlKeyCombination primaryG
]

{ #category : #defaults }
GtCoderKeymapRegistry >> defaultDoItAndInspectSerializedShortcutCombination [
	^ BlKeyCombination primaryShiftG
]

{ #category : #defaults }
GtCoderKeymapRegistry >> defaultDoItAndInspectShortcutCombination [
	^ BlKeyCombination primaryG
]

{ #category : #defaults }
GtCoderKeymapRegistry >> defaultDoItAsynchronousShortcutCombination [
	^ BlKeyCombination primaryD
]

{ #category : #defaults }
GtCoderKeymapRegistry >> defaultDoItShortcutCombination [
	^ BlKeyCombination primaryD
]

{ #category : #defaults }
GtCoderKeymapRegistry >> defaultExtractMethodShortcutCombination [
	^ BlKeyCombination primaryE
]

{ #category : #defaults }
GtCoderKeymapRegistry >> defaultFoldNoiseShortcutCombination [
	^ BlKeyCombination primaryShiftN
]

{ #category : #defaults }
GtCoderKeymapRegistry >> defaultFormatShortcutCombination [
	^ BlKeyCombination primaryShiftF
]

{ #category : #defaults }
GtCoderKeymapRegistry >> defaultMoveStatementDownShortcutCombination [
	^ BlKeyCombination builder primary arrowDown build
]

{ #category : #defaults }
GtCoderKeymapRegistry >> defaultMoveStatementUpShortcutCombination [
	^ BlKeyCombination builder primary arrowUp build
]

{ #category : #defaults }
GtCoderKeymapRegistry >> defaultPlayAndInspectShortcutCombination [
	^ BlKeyCombination primaryG
]

{ #category : #defaults }
GtCoderKeymapRegistry >> defaultPlayShortcutCombination [
	^ BlKeyCombination primaryD
]

{ #category : #defaults }
GtCoderKeymapRegistry >> defaultPrintItShortcutCombination [
	^ BlKeyCombination primaryP
]

{ #category : #defaults }
GtCoderKeymapRegistry >> defaultSaveShortcutCombination [
	^ BlKeyCombination primaryS
]

{ #category : #defaults }
GtCoderKeymapRegistry >> defaultSearchTextShortcutCombination [
	^ BlKeyCombination primaryF
]

{ #category : #defaults }
GtCoderKeymapRegistry >> defaultSelectStatementDownShortcutCombination [
	^ BlKeyCombination builder shift primary arrowDown build
]

{ #category : #defaults }
GtCoderKeymapRegistry >> defaultSelectStatementUpShortcutCombination [
	^ BlKeyCombination builder shift primary arrowUp build
]

{ #category : #initialization }
GtCoderKeymapRegistry >> initializeBasicCombinations [
	super initializeBasicCombinations.
	
	self 
		initializeShortcut: GtCoderShortcutIds default browseBehaviorShortcutId 
		with: self defaultBrowseBehaviorShortcutCombination.
	self 
		initializeShortcut: GtCoderShortcutIds default browseImplementorsShortcutId 
		with: self defaultBrowseImplementorsShortcutCombination.
	self 
		initializeShortcut: GtCoderShortcutIds default browseReferencesShortcutId 
		with: self defaultBrowseReferencesShortcutCombination.
	self 
		initializeShortcut: GtCoderShortcutIds default compileItShortcutId 
		with: self defaultCompileItShortcutCombination.
	self 
		initializeShortcut: GtCoderShortcutIds default debugShortcutId 
		with: self defaultDebugShortcutCombination.
	self 
		initializeShortcut: GtCoderShortcutIds default discardChangesShortcutId 
		with: self defaultDiscardChangesShortcutCombination.
	self 
		initializeShortcut: GtCoderShortcutIds default doItAndInspectAsynchronousShortcutId 
		with: self defaultDoItAndInspectAsynchronousShortcutCombination.
	self 
		initializeShortcut: GtCoderShortcutIds default doItAndInspectSerializedShortcutId 
		with: self defaultDoItAndInspectSerializedShortcutCombination.
	self 
		initializeShortcut: GtCoderShortcutIds default doItAndInspectShortcutId 
		with: self defaultDoItAndInspectShortcutCombination.
	self 
		initializeShortcut: GtCoderShortcutIds default doItAsynchronousShortcutId 
		with: self defaultDoItAsynchronousShortcutCombination.
	self 
		initializeShortcut: GtCoderShortcutIds default doItShortcutId 
		with: self defaultDoItShortcutCombination.
	self 
		initializeShortcut: GtCoderShortcutIds default extractMethodShortcutId 
		with: self defaultExtractMethodShortcutCombination.
	self 
		initializeShortcut: GtCoderShortcutIds default foldNoiseShortcutId 
		with: self defaultFoldNoiseShortcutCombination.
	self 
		initializeShortcut: GtCoderShortcutIds default formatShortcutId 
		with: self defaultFormatShortcutCombination.
	self 
		initializeShortcut: GtCoderShortcutIds default moveStatementDownShortcutId 
		with: self defaultMoveStatementDownShortcutCombination.
	self 
		initializeShortcut: GtCoderShortcutIds default moveStatementUpShortcutId 
		with: self defaultMoveStatementUpShortcutCombination.
	self 
		initializeShortcut: GtCoderShortcutIds default playAndInspectShortcutId 
		with: self defaultPlayAndInspectShortcutCombination.
	self 
		initializeShortcut: GtCoderShortcutIds default playShortcutId 
		with: self defaultPlayShortcutCombination.
	self 
		initializeShortcut: GtCoderShortcutIds default printItShortcutId 
		with: self defaultPrintItShortcutCombination.
	self 
		initializeShortcut: GtCoderShortcutIds default saveShortcutId 
		with: self defaultSaveShortcutCombination.
	self 
		initializeShortcut: GtCoderShortcutIds default searchTextShortcutId 
		with: self defaultSearchTextShortcutCombination.
	self 
		initializeShortcut: GtCoderShortcutIds default selectStatementDownShortcutId 
		with: self defaultSelectStatementDownShortcutCombination.
	self 
		initializeShortcut: GtCoderShortcutIds default selectStatementUpShortcutId 
		with: self defaultSelectStatementUpShortcutCombination.
]

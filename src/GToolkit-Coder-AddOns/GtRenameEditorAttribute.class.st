Class {
	#name : #GtRenameEditorAttribute,
	#superclass : #GtRenamePreviewAttribute,
	#instVars : [
		'cursorLocation',
		'selectAll',
		'filter',
		'editorShortcuts'
	],
	#category : #'GToolkit-Coder-AddOns-Inline rename'
}

{ #category : #accessing }
GtRenameEditorAttribute >> additionalAttributes [
	^ #()
]

{ #category : #accessing }
GtRenameEditorAttribute >> cursorLocation: anInteger [
	cursorLocation := anInteger
]

{ #category : #accessing }
GtRenameEditorAttribute >> doAffect: aTBrTextEditorTextualPiece in: anEditorElement [
	renameEditor := GtRenameEditor new
		fitContent;
		look: (BrGlamorousEditableLabelLook new defaultBackground: Color transparent; minWidth: 0);
		padding: (BlInsets left: 2 right: 2);
		margin: (BlInsets top: 0 left: -2 bottom: 0 right: -2);
		inputFilter: filter;
		switchToEditor;
		text: text;
		requestFocus.

	renameEditor editor
		when: BrTextEditorModifiedEvent
		do: [ :event | renameAction updateName: renameEditor editor text ].
	renameEditor
		when: BlFocusOutEvent
		do: [ :event | self updateFocus: event ].

	renameEditor editor moveCursorTo: (cursorLocation min: renameEditor editor text size).

	selectAll
		ifTrue: [ renameEditor editor selecter all select ].

	renameEditor editor addEditorShortcuts: self editorShortcuts.
	
	^ renameEditor
]

{ #category : #accessing }
GtRenameEditorAttribute >> editorCursorLocation [
	renameEditor notNil
		ifTrue: [ renameEditor editor cursors do: [ :cursor | ^ cursor position ] ].
	^ text size
]

{ #category : #private }
GtRenameEditorAttribute >> editorShortcuts [
	^ editorShortcuts
		ifNil: [ editorShortcuts := {
			(BlShortcutWithAction new
				combination: BlKeyCombination escape;
				action: [ :aShortcutEvent | self renameAction cancel ]).
			(BlShortcutWithAction new
				combination: BlKeyCombination builder shift tab build;
				action: [ :aShortcutEvent | self renameAction tabAccept: false ]).
			(BlShortcutWithAction new
				combination: BlKeyCombination tab;
				action: [ :aShortcutEvent | self renameAction tabAccept: true ]).
			(BlShortcutWithAction new
				combination: BlKeyCombination return;
				action: [ :aShortcutEvent | self renameAction accept ])} ]
]

{ #category : #accessing }
GtRenameEditorAttribute >> filter: aTextEditorInputFilter [
	filter := aTextEditorInputFilter.
	renameEditor notNil
		ifTrue: [ renameEditor inputFilter: aTextEditorInputFilter ]
]

{ #category : #initialization }
GtRenameEditorAttribute >> initialize [
	super initialize.
	
	filter := BrTextEditorNoInputFilter new.
	selectAll := false.
	
	self shouldReplace
]

{ #category : #testing }
GtRenameEditorAttribute >> isEditorAttribute [
	^ true
]

{ #category : #testing }
GtRenameEditorAttribute >> isFocusable [
	^ true
]

{ #category : #accessing }
GtRenameEditorAttribute >> renameAction [
	^ renameAction
]

{ #category : #accessing }
GtRenameEditorAttribute >> selectAll [
	^ selectAll
]

{ #category : #accessing }
GtRenameEditorAttribute >> selectAll: aBoolean [
	selectAll := aBoolean
]

{ #category : #accessing }
GtRenameEditorAttribute >> uninstallEventHandlers [
	renameEditor notNil
		ifTrue: [ renameEditor editor removeEditorShortcuts: self editorShortcuts ]
]

{ #category : #accessing }
GtRenameEditorAttribute >> updateFocus: event [
	renameAction isInstalled
		ifTrue: [ renameAction lostFocus ]
]

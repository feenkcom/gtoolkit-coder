Class {
	#name : #GtRenameEditorAttribute,
	#superclass : #GtRenamePreviewAttribute,
	#instVars : [
		'cursorLocation',
		'selectAll',
		'filter',
		'editorShortcuts',
		'requestInitialFocus',
		'isForSelector'
	],
	#category : #'GToolkit-Coder-AddOns-Inline rename'
}

{ #category : #accessing }
GtRenameEditorAttribute >> additionalAttributes [
	^ {BlFontFamilyAttribute named: 'Source Code Pro'}
]

{ #category : #accessing }
GtRenameEditorAttribute >> cursorLocation: anInteger [
	cursorLocation := anInteger
]

{ #category : #accessing }
GtRenameEditorAttribute >> doAffect: aTBrTextEditorTextualPiece in: anEditorElement [
	renameEditor := GtRenameEditor new
			fitContent;
			aptitude: (BrGlamorousEditableLabelAptitude new
					defaultBackground: Color transparent;
					defaultBorder: (BlBorder paint: BrGlamorousColors editorBorderColor);
					minWidth: 0);
			padding: (BlInsets left: 2 right: 2);
			margin: (BlInsets
					top: 0
					left: -2
					bottom: 0
					right: -2);
			inputFilter: filter;
			text: text.
	requestInitialFocus
		ifTrue: [ renameEditor
				switchToEditor;
				requestFocus ]
		ifFalse: [ renameEditor switchToLabel ].

	isForSelector ifTrue: [ self setupArrowKeysOn: anEditorElement ].

	renameEditor
		whenKey: BlKeyCombination escape
			editorDo: [ :aShortcutEvent | self renameAction cancel ];
		whenKey: BlKeyCombination builder shift tab build
			editorDo: [ :aShortcutEvent | 
				(self focusNext: false in: anEditorElement)
					ifFalse: [ self renameAction tabAccept: false ] ];
		whenKey: BlKeyCombination tab
			editorDo: [ :aShortcutEvent | 
				(self focusNext: true in: anEditorElement)
					ifFalse: [ self renameAction tabAccept: true ] ];
		whenKey: BlKeyCombination enter
			editorDo: [ :aShortcutEvent | (self focusNext: true in: anEditorElement) ifFalse: [ self renameAction accept ] ].

	renameEditor when: BrEditorCancelWish do: [ :event | self renameAction cancel ].

	renameEditor editor
		when: BrTextEditorModifiedEvent
		do: [ :event | renameAction updateName: renameEditor editor text ].
	renameEditor when: BlFocusOutEvent do: [ :event | self updateFocus: event ].

	requestInitialFocus
		ifTrue: [ renameEditor editor
				moveCursorTo: ((cursorLocation ifNil: [ SmallInteger maxVal ])
						min: renameEditor editor text size) ].

	selectAll ifTrue: [ renameEditor editor selecter all select ].

	^ renameEditor
]

{ #category : #accessing }
GtRenameEditorAttribute >> editorCursorLocation [
	renameEditor notNil
		ifTrue: [ renameEditor editor cursors do: [ :cursor | ^ cursor position ] ].
	^ text size
]

{ #category : #accessing }
GtRenameEditorAttribute >> filter: aTextEditorInputFilter [
	filter := aTextEditorInputFilter.
	renameEditor notNil
		ifTrue: [ renameEditor inputFilter: aTextEditorInputFilter ]
]

{ #category : #accessing }
GtRenameEditorAttribute >> focusNext: aBoolean in: anEditorElement [
	| first last previous |
	isForSelector ifFalse: [ ^ false ].
	anEditorElement
		allChildrenBreadthFirstDo: [ :each | 
			(each isKindOf: GtRenameEditor)
				ifTrue: [ first ifNil: [ first := each ].
					last := each.
					(aBoolean not and: [ each == renameEditor and: [ previous notNil ] ])
						ifTrue: [ previous requestFocus.
							^ true ].
					(aBoolean and: [ previous == renameEditor ])
						ifTrue: [ each requestFocus.
							^ true ].
					previous := each ] ].
	aBoolean
		ifTrue: [ first
				ifNotNil: [ first requestFocus.
					^ true ] ]
		ifFalse: [ last
				ifNotNil: [ last requestFocus.
					^ true ] ].
	^ false
]

{ #category : #initialization }
GtRenameEditorAttribute >> initialize [
	super initialize.
	
	filter := BrTextEditorNoInputFilter new.
	selectAll := false.
	self cache: self newPooledCache.
	requestInitialFocus  := true.
	isForSelector  := false
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
GtRenameEditorAttribute >> isForSelector [
	^ isForSelector
]

{ #category : #accessing }
GtRenameEditorAttribute >> isForSelector: aBoolean [
	isForSelector := aBoolean
]

{ #category : #accessing }
GtRenameEditorAttribute >> renameAction [
	^ renameAction
]

{ #category : #accessing }
GtRenameEditorAttribute >> requestInitialFocus [
	^ requestInitialFocus
]

{ #category : #accessing }
GtRenameEditorAttribute >> requestInitialFocus: aBoolean [
	requestInitialFocus := aBoolean
]

{ #category : #accessing }
GtRenameEditorAttribute >> selectAll [
	^ selectAll
]

{ #category : #accessing }
GtRenameEditorAttribute >> selectAll: aBoolean [
	selectAll := aBoolean
]

{ #category : #private }
GtRenameEditorAttribute >> setupArrowKeysOn: anEditorElement [
	renameEditor
		whenKey: BlKeyCombination arrowRight
		editorDo: [ :aShortcutEvent | 
			| cursors editor |
			editor := aShortcutEvent source editor.
			cursors := editor cursors positions.
			(cursors includes: editor text size)
				ifTrue: [ aShortcutEvent consumed: (self focusNext: true in: anEditorElement) ]
				ifFalse: [ cursors notEmpty
						ifTrue: [ editor selectNone.
							editor moveCursorTo: cursors first + 1 ] ] ].
	renameEditor
		whenKey: BlKeyCombination arrowLeft
		editorDo: [ :aShortcutEvent | 
			| cursors editor |
			editor := aShortcutEvent source editor.
			cursors := editor cursors positions.
			(cursors includes: 0)
				ifTrue: [ aShortcutEvent consumed: (self focusNext: false in: anEditorElement) ]
				ifFalse: [ cursors notEmpty
						ifTrue: [ editor selectNone.
							editor moveCursorTo: cursors first - 1 ] ] ].
	renameEditor
		whenKey: BlKeyCombination arrowDown
		editorDo: [ :aShortcutEvent | aShortcutEvent consumed: (self focusNext: true in: anEditorElement) ].
	renameEditor
		whenKey: BlKeyCombination arrowUp
		editorDo: [ :aShortcutEvent | aShortcutEvent consumed: (self focusNext: false in: anEditorElement) ]
]

{ #category : #accessing }
GtRenameEditorAttribute >> updateFocus: event [
	renameAction isInstalled
		ifTrue: [ renameAction lostFocus ]
]

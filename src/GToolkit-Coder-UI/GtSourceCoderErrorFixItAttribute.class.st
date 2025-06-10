Class {
	#name : #GtSourceCoderErrorFixItAttribute,
	#superclass : #GtSourceCoderErrorAttribute,
	#instVars : [
		'fixItAttribute'
	],
	#category : #'GToolkit-Coder-UI-FixIt'
}

{ #category : #'as yet unclassified' }
GtSourceCoderErrorFixItAttribute >> buildPopupIn: anEditorElement aptitude: aptitude [
	| element |
	element := fixItAttribute dropDownElementFor: anEditorElement.
	element id: #'error-fix-it'.
	element beFocusable.
	{BlKeyCombination escape.
		BlKeyCombination enter.
		BlKeyCombination backspace}
		do: [ :key | 
			element
				addShortcut: (BlShortcutWithAction new
						combination: key;
						repeatable: false;
						action: [ :aShortcutEvent :aShortcutAction | 
							aShortcutEvent currentTarget fireEvent: BrDropdownHideWish new.
							anEditorElement requestFocus ]) ].
	element
		enqueueTask: [ element dispatchEvent: BrPopoverGainFocusWish new ] asBlTask.
	^ element
]

{ #category : #accessing }
GtSourceCoderErrorFixItAttribute >> fixItAttribute [
	^ fixItAttribute
]

{ #category : #accessing }
GtSourceCoderErrorFixItAttribute >> fixItAttribute: anObject [
	fixItAttribute := anObject
]

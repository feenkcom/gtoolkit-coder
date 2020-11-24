Class {
	#name : #GtSourceCoderShortcut,
	#superclass : #BrEditorShortcut,
	#category : #'GToolkit-Coder-UI-Shortcuts'
}

{ #category : #private }
GtSourceCoderShortcut >> forEditor: aBrTextEditor selectedStringDo: aSelectedTextBlock orCursorStringPositionDo: aCursorTextPositionBlock [
	aBrTextEditor selectedText
		ifEmpty: [ aBrTextEditor hasCursors 
			ifTrue: [
				| aCursorPosition aTextPosition |
				
				aCursorPosition := aBrTextEditor cursors first position.
				aTextPosition := (aCursorPosition + 1) min: aBrTextEditor text size.

				aCursorTextPositionBlock value: aTextPosition ] ]
		ifNotEmpty: [ :aSelectedText | aSelectedTextBlock value: aSelectedText asString ]
]

{ #category : #private }
GtSourceCoderShortcut >> forEditor: aBrTextEditor selectionIntervalDo: aSelectionIntervalBlock orCursorStringPositionDo: aCursorTextPositionBlock [
	aBrTextEditor hasSelection
		ifTrue: [
			| aFromIndex aToIndex |
			aFromIndex := (aBrTextEditor selection from + 1) min: aBrTextEditor text size max: 1.
			aToIndex := ((aBrTextEditor selection to) max: 1) min: aBrTextEditor text size.
			aSelectionIntervalBlock value: (aFromIndex to: aToIndex) ]
		ifFalse: [ aBrTextEditor hasCursors 
			ifTrue: [
				| aCursorPosition aTextPosition |
				
				aCursorPosition := aBrTextEditor cursors first position.
				aTextPosition := (aCursorPosition + 1) min: aBrTextEditor text size.

				aCursorTextPositionBlock value: aTextPosition ] ]
]

{ #category : #evaluation }
GtSourceCoderShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coder: aGtSourceCoder dueTo: aShortcutEvent [
	self subclassResponsibility
]

{ #category : #evaluation }
GtSourceCoderShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement dueTo: aShortcutEvent [
	aBrTextEditor model ifNotNil: [ :aSourceCoder |
		self performOnEditor: aBrTextEditor element: aBrEditorElement coder: aSourceCoder dueTo: aShortcutEvent ]
]

{ #category : #private }
GtSourceCoderShortcut >> selectionIntervalIn: aBrTextEditor [
	aBrTextEditor selection
		do: [ :eachMonotoneSelection | ^ eachMonotoneSelection from + 1 to: eachMonotoneSelection to ].
	
	"this is an empty interval
	https://github.com/feenkcom/gtoolkit/issues/1352"
	^ 1 to: 0
]

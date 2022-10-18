Class {
	#name : #GtRenameAction,
	#superclass : #GtAbstractRenameAction,
	#instVars : [
		'textElement',
		'originalCursorPosition'
	],
	#category : #'GToolkit-Coder-AddOns-Inline rename'
}

{ #category : #'instance creation' }
GtRenameAction class >> locations: aCollectionOfIntervals element: aTextEditorElement [
	^ self new
		textElement: aTextEditorElement;
		locations: aCollectionOfIntervals;
		yourself
]

{ #category : #private }
GtRenameAction >> addRenameAttributes [
	| text cursorInLocation |
	text := self text.
	cursorInLocation := originalLocations
		anySatisfy:
			[ :each | originalCursorPosition between: each first - 1 and: each last ].
	renameAttributes := originalLocations
		collect: [ :each | 
			| attribute |
			attribute := (cursorInLocation not
				or: [ originalCursorPosition between: each first - 1 and: each last ])
				ifTrue: [ GtRenameEditorAttribute new
						action: self;
						selectAll: selectAll;
						filter: filter;
						cursorLocation: originalCursorPosition - each first + 1;
						text: (text from: each first to: each last) ]
				ifFalse: [ GtRenamePreviewAttribute new
						action: self;
						text: (text from: each first to: each last) ].
			cursorInLocation := true.
			(text from: each first to: each last) attributes: {attribute}.
			attribute ]
]

{ #category : #'private - actions' }
GtRenameAction >> allowSave [
	(textElement respondsTo: #textualCoderViewModel)
		ifTrue: [ textElement textualCoderViewModel allowSaveDueTo: self ]
]

{ #category : #'private - actions' }
GtRenameAction >> preventSave [
	(textElement respondsTo: #textualCoderViewModel)
		ifTrue: [ textElement textualCoderViewModel preventSaveDueTo: self ]
]

{ #category : #private }
GtRenameAction >> removeAttributes [
	self text clearAttributes: [ :each | self isRenameAttribute: each ]
]

{ #category : #private }
GtRenameAction >> saveOriginalState [
	| text |
	text := self text.
	originalText := text copy.
	originalCursorPosition := self textEditor cursors first position
]

{ #category : #accessing }
GtRenameAction >> text [
	^ self textEditor text
]

{ #category : #accessing }
GtRenameAction >> textEditor [
	^ self textElement editor
]

{ #category : #accessing }
GtRenameAction >> textElement [
	^ textElement
]

{ #category : #accessing }
GtRenameAction >> textElement: aTextEditorElement [
	textElement := aTextEditorElement
]

{ #category : #private }
GtRenameAction >> undoChanges [
	textElement text: originalText.
	(textElement respondsTo: #onTextModified)
		ifTrue: [ textElement onTextModified ].

	self textEditor moveCursorTo: originalCursorPosition
]

{ #category : #installation }
GtRenameAction >> uninstall [
	super uninstall.
	textElement
		enqueueTask: (BlTaskAction new action: [ textElement requestFocus ])
]

{ #category : #private }
GtRenameAction >> updateCursorLocation [
	| sizeDifference offset |
	sizeDifference := self newName size - self originalName size.
	offset := 0.
	originalLocations
		with: renameAttributes
		do: [ :interval :attr | 
			attr isEditorAttribute
				ifTrue: [ textElement editor
						moveCursorTo:
							(interval first + offset + attr editorCursorLocation - 1
								min: textElement editor text size).
					^ self ].
			offset := offset + sizeDifference ]
]

{ #category : #private }
GtRenameAction >> updateSource [
	self newName = self originalName
		ifTrue: [ ^ self removeAttributes ].
	self
		updateSourceIn: self textEditor
		at: originalLocations
		attributes: renameAttributes.
	self updateCursorLocation
]

{ #category : #private }
GtRenameAction >> updateSourceIn: editor at: intervals attributes: attributeCollection [
	self
		updateText: editor text
		at: intervals
		attributes: attributeCollection
]

{ #category : #private }
GtRenameAction >> updateText: text at: intervals attributes: attributeCollection [
	| newText index |
	newText := '' asRopedText.
	index := 1.
	intervals
		with: attributeCollection
		do: [ :each :attr | 
			each first = 1
				ifTrue: [ newText := newText , attr text ]
				ifFalse: [ newText := newText , (text copyFrom: index to: each first - 1) , attr text ].
			index := each last + 1 ].
	index > text size
		ifFalse: [ newText := newText , (text copyFrom: index to: text size) ].

	textElement text: newText.
	(textElement respondsTo: #onTextModified)
		ifTrue: [ textElement onTextModified ]
]

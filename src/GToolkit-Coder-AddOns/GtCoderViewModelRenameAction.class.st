Class {
	#name : #GtCoderViewModelRenameAction,
	#superclass : #GtAbstractRenameAction,
	#instVars : [
		'pharoSourceCoderViewModel',
		'originalCursors',
		'coderAttributes',
		'hasRefactoringPreview'
	],
	#category : #'GToolkit-Coder-AddOns-Inline rename'
}

{ #category : #'instance creation' }
GtCoderViewModelRenameAction class >> locations: aCollectionOfIntervals textualCoderViewModel: aTextualCoderViewModel [
	^ self new
		locations: aCollectionOfIntervals;
		pharoSourceCoderViewModel: aTextualCoderViewModel;
		yourself
]

{ #category : #'private - attributes' }
GtCoderViewModelRenameAction >> addRenameAttributes [
	| text cursorInLocation |

	text := self pharoSourceCoderViewModel styledText ifNil: [ self pharoSourceCoderViewModel sourceText ].

	cursorInLocation := originalLocations
		anySatisfy: [ :each | originalCursors anySatisfy: [ :eachCursor | eachCursor position between: each first - 1 and: each last ] ].

	coderAttributes := originalLocations
		collect: [ :each | 
			| attribute |
			attribute := (cursorInLocation not
				or: [ originalCursors anySatisfy: [ :eachCursor | eachCursor position between: each first - 1 and: each last ] ])
				ifTrue: [
					GtRenameEditorAttribute new
						action: self;
						selectAll: selectAll;
						filter: filter;
						coordinateFocus: hasRefactoringPreview;
						text: (text from: each first to: each last) ]
				ifFalse: [
					GtRenamePreviewAttribute new
						action: self;
						text: (text from: each first to: each last) ].
			cursorInLocation := true.
			
			self pharoSourceCoderViewModel
				addTextAttribute: attribute
				from: each first
				to: each last ].
			
	renameAttributes := coderAttributes flatCollect: [ :eachCoderAttribute | eachCoderAttribute textAttributes ].

	self
		assert: [ (renameAttributes select: [ :each | each isKindOf: GtRenameEditorAttribute ]) size <= 1 ]
		description: [ 'There must not be more than one editor attribute' ]
]

{ #category : #'private - actions' }
GtCoderViewModelRenameAction >> allowSave [
	pharoSourceCoderViewModel allowSaveDueTo: self
]

{ #category : #accessing }
GtCoderViewModelRenameAction >> hasRefactoringPreview [
	^ hasRefactoringPreview
]

{ #category : #accessing }
GtCoderViewModelRenameAction >> hasRefactoringPreview: aBoolean [
	hasRefactoringPreview := aBoolean
]

{ #category : #'initialize-release' }
GtCoderViewModelRenameAction >> initialize [
	super initialize.
	coderAttributes := #().
	hasRefactoringPreview := false
]

{ #category : #accessing }
GtCoderViewModelRenameAction >> lostFocus [
	hasRefactoringPreview ifTrue: [ ^ self ].
	^ super lostFocus
]

{ #category : #accessing }
GtCoderViewModelRenameAction >> pharoSourceCoderViewModel [
	^ pharoSourceCoderViewModel
]

{ #category : #accessing }
GtCoderViewModelRenameAction >> pharoSourceCoderViewModel: anObject [
	pharoSourceCoderViewModel := anObject
]

{ #category : #'private - actions' }
GtCoderViewModelRenameAction >> preventSave [
	pharoSourceCoderViewModel preventSaveDueTo: self
]

{ #category : #'private - attributes' }
GtCoderViewModelRenameAction >> removeAttributes [	
	self pharoSourceCoderViewModel removeAllCoderTextAttributes: coderAttributes
]

{ #category : #private }
GtCoderViewModelRenameAction >> saveOriginalState [
	originalText := self pharoSourceCoderViewModel sourceText copy.
	originalCursors := self pharoSourceCoderViewModel cursors copy
]

{ #category : #private }
GtCoderViewModelRenameAction >> undoChanges [
	self pharoSourceCoderViewModel cursors: originalCursors
]

{ #category : #installation }
GtCoderViewModelRenameAction >> uninstall [
	super uninstall.
	pharoSourceCoderViewModel focused: true
]

{ #category : #private }
GtCoderViewModelRenameAction >> updateCursorLocation [
	| sizeDifference offset |
	sizeDifference := self newName size - self originalName size.
	offset := 0.
	originalLocations
		with: renameAttributes
		do: [ :interval :attr | 
			attr isEditorAttribute
				ifTrue: [
					| aNewCursorPosition |
					
					aNewCursorPosition := (interval first + offset + attr editorCursorLocation - 1 min: pharoSourceCoderViewModel sourceText size).
					pharoSourceCoderViewModel moveCursorTo: aNewCursorPosition.
					^ self ].

			offset := offset + sizeDifference ]
]

{ #category : #private }
GtCoderViewModelRenameAction >> updateSource [
	self newName = self originalName
		ifTrue: [ ^ self removeAttributes ].

	self
		updateSourceIn: self pharoSourceCoderViewModel
		at: originalLocations
		attributes: renameAttributes.

	self updateCursorLocation
]

{ #category : #private }
GtCoderViewModelRenameAction >> updateSourceIn: aTextualSourceCoderViewModel at: intervals attributes: attributeCollection [
	self
		updateText: aTextualSourceCoderViewModel sourceText
		at: intervals
		attributes: attributeCollection
]

{ #category : #private }
GtCoderViewModelRenameAction >> updateText: text at: intervals attributes: attributeCollection [
	| newText index |
	newText := '' asRopedText.
	index := 1.
	intervals
		with: attributeCollection
		do: [ :each :attr |
			each first = 1
				ifTrue: [ newText := newText , attr text ]
				ifFalse: [ newText := newText , (text copyFrom: index to: each first - 1)
						, attr text ].
			index := each last + 1 ].
	index > text size
		ifFalse: [ newText := newText , (text copyFrom: index to: text size) ].

	self pharoSourceCoderViewModel
		sourceText: newText
		from: self
		synchronously: false
]

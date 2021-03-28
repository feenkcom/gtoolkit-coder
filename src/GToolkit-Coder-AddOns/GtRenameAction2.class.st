Class {
	#name : #GtRenameAction2,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'announcer',
		'pharoSourceCoderViewModel',
		'originalLocations',
		'originalText',
		'isInstalled',
		'renameAttributes',
		'selectAll',
		'validationBlock',
		'filter',
		'originalCursors',
		'coderAttributes'
	],
	#category : #'GToolkit-Coder-AddOns-Inline rename'
}

{ #category : #'instance creation' }
GtRenameAction2 class >> locations: aCollectionOfIntervals textualCoderViewModel: aTextualCoderViewModel [
	^ self new
		locations: aCollectionOfIntervals;
		pharoSourceCoderViewModel: aTextualCoderViewModel;
		yourself
]

{ #category : #'api - factory' }
GtRenameAction2 class >> pharoRenameLocalVariableAt: aTextIndex textualCoderViewModel: aTextualCoderViewModel [
	^ [
		| ast items action |
	
		ast := aTextualCoderViewModel astAwait.
		items := OrderedCollection new.

		(ast findVariableNodeAt: aTextIndex)
			ifNotNil: [ :node | 
				node whoDefines
					ifNotNil: [ :definer | 
						definer
							withAllNodesDo: [ :each | 
								each = node
									ifTrue: [ items add: (each startPosition to: each stopPosition) ] ]
							andTokensDo: nil
							includesErrors: true ] ].
		action := self locations: items textualCoderViewModel: aTextualCoderViewModel.
		action forVariableOrUnaryMessage.
		action install ]
			on: Error
			do: [ :ex |
				NonInteractiveTranscript stdout
					nextPutAll: ('[{1}] {2}' format: { self name . ex asString });
					cr.
				ex return: nil ]
]

{ #category : #'api - factory' }
GtRenameAction2 class >> pharoRenameSnippetLocalsOn: aTextEditorElement [
	^ [ | editor text ast items action |
	editor := aTextEditorElement editor.
	editor cursors cursorsCount = 1
		ifFalse: [ ^ nil ].
	text := editor text.
	ast := GtPharoParser
		parseWithErrors: text asString
		startingAt: GtPharoParser startingStateForMethodSequence.
	items := OrderedCollection new.
	(ast findVariableNodeAt: editor cursors first position)
		ifNotNil: [ :node | 
			| definer |
			definer := node whoDefines ifNil: [ ast ].
			definer
				withAllNodesDo: [ :each | 
					each = node
						ifTrue: [ items add: (each startPosition to: each stopPosition) ] ]
				andTokensDo: nil
				includesErrors: true ].
	action := self locations: items element: aTextEditorElement.
	action forVariableOrUnaryMessage.
	action install ]
		on: Error
		do: [ :ex | ex return: nil ]
]

{ #category : #'api - factory' }
GtRenameAction2 class >> pharoRenameTemporaryVariable: aVariableName textualCoderViewModel: aTextualCoderViewModel [
	^ [
		| ast items action |
	
		ast := aTextualCoderViewModel astAwait.
		items := OrderedCollection new.
		
		ast
			withAllNodesDo: [ :eachNode |
				(eachNode isVariable
					and: [ eachNode variableName = aVariableName
						and: [ eachNode whoDefines isSequence ] ])
					ifTrue: [ items add: (eachNode startPosition to: eachNode stopPosition) ] ]
			andTokensDo: nil
			includesErrors: true.

		action := self locations: items textualCoderViewModel: aTextualCoderViewModel.
		action forVariableOrUnaryMessage.
		action install ]
			on: Error
			do: [ :ex |
				NonInteractiveTranscript stdout
					nextPutAll: ('[{1}] {2}' format: { self name . ex asString });
					cr.
				ex return: nil ]
]

{ #category : #actions }
GtRenameAction2 >> accept [
	self updateSource.
	self uninstall.
	self allowSave.
	self announceEvent: #accept
]

{ #category : #'private - attributes' }
GtRenameAction2 >> addRenameAttributes [
	| text cursorInLocation |

	text := self pharoSourceCoderViewModel sourceText.

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
GtRenameAction2 >> allowSave [
	pharoSourceCoderViewModel allowSaveDueTo: self
]

{ #category : #private }
GtRenameAction2 >> announceEvent: aSymbol [
	^ self announce: (GtRenameActionAnnouncement for: self type: aSymbol)
]

{ #category : #announcer }
GtRenameAction2 >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #actions }
GtRenameAction2 >> cancel [
	self uninstall.
	self undoChanges.
	self allowSave.
	self announceEvent: #cancel
]

{ #category : #accessing }
GtRenameAction2 >> editor [
	^ self editorAttribute editor
]

{ #category : #accessing }
GtRenameAction2 >> editorAttribute [
	^ renameAttributes notNil
		ifTrue: [ renameAttributes
				detect: [ :attr | attr isKindOf: GtRenameEditorAttribute ]
				ifNone: [  ] ]
]

{ #category : #private }
GtRenameAction2 >> filter: aTextEditorInputFilter [
	filter := aTextEditorInputFilter.
	self primaryRenameAttribute
		ifNotNil: [ :attr | attr filter: aTextEditorInputFilter ]
]

{ #category : #'initialize-release' }
GtRenameAction2 >> forBinaryOrKeyword [
	validationBlock := [ :str | (self validateKeyword: str) or: [ self validateBinary: str ] ]
]

{ #category : #'initialize-release' }
GtRenameAction2 >> forKeyword [
	validationBlock := [ :str | self validateKeyword: str ]
]

{ #category : #'initialize-release' }
GtRenameAction2 >> forVariableOrUnaryMessage [
	validationBlock := [ :str | self validateVariable: str ].
	self filter: BrTextEditorAlphaNumericInputFilter new
]

{ #category : #'initialize-release' }
GtRenameAction2 >> initialize [
	super initialize.
	originalLocations := #().
	isInstalled := false.
	selectAll := false.
	filter := BrTextEditorNoInputFilter new.

	coderAttributes := #().
]

{ #category : #installation }
GtRenameAction2 >> install [
	originalLocations isEmpty
		ifTrue: [ ^ self ].

	self preventSave.
	self saveOriginalState.

	self addRenameAttributes.
	isInstalled := true.

	self announceEvent: #install
]

{ #category : #testing }
GtRenameAction2 >> isInstalled [
	^ isInstalled
]

{ #category : #testing }
GtRenameAction2 >> isRenameAttribute: anAttribute [
	^ anAttribute isKindOf: GtRenamePreviewAttribute
]

{ #category : #'private-validation' }
GtRenameAction2 >> isValid [
	validationBlock isNil
		ifTrue: [ ^ true ].
	^ validationBlock value: self newName
]

{ #category : #accessing }
GtRenameAction2 >> locations: aCollectionOfIntervals [
	originalLocations := aCollectionOfIntervals asSortedCollection: [ :a :b | a first < b first ].
	self validateLocations
]

{ #category : #actions }
GtRenameAction2 >> lostFocus [
	self isValid
		ifTrue: [ self accept ]
		ifFalse: [ self cancel ]
]

{ #category : #accessing }
GtRenameAction2 >> newName [
	^ renameAttributes first text asString
]

{ #category : #accessing }
GtRenameAction2 >> originalName [
	^ (originalText
		copyFrom: originalLocations first first
		to: originalLocations first last) asString
]

{ #category : #accessing }
GtRenameAction2 >> pharoSourceCoderViewModel [
	^ pharoSourceCoderViewModel
]

{ #category : #accessing }
GtRenameAction2 >> pharoSourceCoderViewModel: anObject [
	pharoSourceCoderViewModel := anObject
]

{ #category : #'private - actions' }
GtRenameAction2 >> preventSave [
	pharoSourceCoderViewModel preventSaveDueTo: self
]

{ #category : #'private - attributes' }
GtRenameAction2 >> primaryRenameAttribute [
	renameAttributes isNil
		ifTrue: [ ^ nil ].
	^ renameAttributes
		detect: [ :each | each isEditorAttribute ]
		ifNone: [ nil ]
]

{ #category : #'private - attributes' }
GtRenameAction2 >> removeAttributeHandlers [
	renameAttributes do: [ :each | each uninstallEventHandlers ]
]

{ #category : #'private - attributes' }
GtRenameAction2 >> removeAttributes [	
	self pharoSourceCoderViewModel removeAllCoderTextAttributes: coderAttributes.
	self removeAttributeHandlers
]

{ #category : #actions }
GtRenameAction2 >> returnAccept [
	self isValid
		ifFalse: [ ^ self ].
	self accept
]

{ #category : #private }
GtRenameAction2 >> saveOriginalState [
	originalText := self pharoSourceCoderViewModel sourceText copy.
	originalCursors := self pharoSourceCoderViewModel cursors copy
]

{ #category : #accessing }
GtRenameAction2 >> selectAll [
	^ selectAll
]

{ #category : #accessing }
GtRenameAction2 >> selectAll: anObject [
	selectAll := anObject
]

{ #category : #actions }
GtRenameAction2 >> tabAccept: forward [
	self isValid
		ifFalse: [ ^ self ].
	self accept.
	self
		announceEvent:
			(forward
				ifTrue: [ #tab ]
				ifFalse: [ #shiftTab ])
]

{ #category : #private }
GtRenameAction2 >> undoChanges [
	self pharoSourceCoderViewModel cursors: originalCursors
]

{ #category : #installation }
GtRenameAction2 >> uninstall [
	self removeAttributes.
	isInstalled := false.
	self allowSave.
	self announceEvent: #uninstall.
	
	pharoSourceCoderViewModel focused: true
]

{ #category : #private }
GtRenameAction2 >> updateCursorLocation [
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

{ #category : #actions }
GtRenameAction2 >> updateName: blText [	
	renameAttributes do: [ :each | each updateText: blText ].
	self announceEvent: #textUpdated
]

{ #category : #private }
GtRenameAction2 >> updateSource [
	self newName = self originalName
		ifTrue: [ ^ self removeAttributes ].

	self
		updateSourceIn: self pharoSourceCoderViewModel
		at: originalLocations
		attributes: renameAttributes.

	self updateCursorLocation
]

{ #category : #private }
GtRenameAction2 >> updateSourceIn: aTextualSourceCoderViewModel at: intervals attributes: attributeCollection [
	self
		updateText: aTextualSourceCoderViewModel sourceText
		at: intervals
		attributes: attributeCollection
]

{ #category : #private }
GtRenameAction2 >> updateText: text at: intervals attributes: attributeCollection [
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
		synchronously: true
]

{ #category : #'private-validation' }
GtRenameAction2 >> validateBinary: aString [
	aString isEmpty
		ifTrue: [ ^ false ].
	^ (RBScanner isSelector: aString) and: [ aString asSymbol isBinary ]
]

{ #category : #'private-validation' }
GtRenameAction2 >> validateKeyword: aString [
	aString isEmpty
		ifTrue: [ ^ false ].
	aString last = $:
		ifFalse: [ ^ false ].
	^ (RBScanner isSelector: aString)
		and: [ aString asSymbol numArgs = 1 ]
]

{ #category : #private }
GtRenameAction2 >> validateLocations [
	| lastLocation size |
	originalLocations isEmpty
		ifTrue: [ ^ self ].
	lastLocation := 0.
	size := originalLocations first size.
	originalLocations
		do: [ :each | 
			each first <= lastLocation
				ifTrue: [ self error: 'Cannot rename overlapping locations' ].
			lastLocation := each last.
			each size ~= size
				ifTrue: [ self error: 'Cannot rename items of different sizes' ] ]
]

{ #category : #'private-validation' }
GtRenameAction2 >> validateVariable: aString [
	^ RBScanner isVariable: aString
]

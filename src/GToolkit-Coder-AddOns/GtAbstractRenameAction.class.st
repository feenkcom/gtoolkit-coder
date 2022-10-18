Class {
	#name : #GtAbstractRenameAction,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'announcer',
		'validationBlock',
		'filter',
		'selectAll',
		'renameAttributes',
		'isInstalled',
		'originalLocations',
		'originalText'
	],
	#category : #'GToolkit-Coder-AddOns-Inline rename'
}

{ #category : #actions }
GtAbstractRenameAction >> accept [
	self updateSource.
	self uninstall.
	self allowSave.
	self announceEvent: #accept
]

{ #category : #private }
GtAbstractRenameAction >> addRenameAttributes [
	self subclassResponsibility
]

{ #category : #private }
GtAbstractRenameAction >> allowSave [
]

{ #category : #private }
GtAbstractRenameAction >> announceEvent: aSymbol [
	^ self announce: (GtRenameActionAnnouncement for: self type: aSymbol)
]

{ #category : #announcer }
GtAbstractRenameAction >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #actions }
GtAbstractRenameAction >> cancel [
	self uninstall.
	self undoChanges.
	self allowSave.
	self announceEvent: #cancel
]

{ #category : #accessing }
GtAbstractRenameAction >> editor [
	^ self editorAttribute editor
]

{ #category : #accessing }
GtAbstractRenameAction >> editorAttribute [
	^ renameAttributes notNil
		ifTrue: [ renameAttributes
				detect: [ :attr | attr isKindOf: GtRenameEditorAttribute ]
				ifNone: [  ] ]
]

{ #category : #private }
GtAbstractRenameAction >> filter: aTextEditorInputFilter [
	filter := aTextEditorInputFilter.
	self primaryRenameAttribute
		ifNotNil: [ :attr | attr filter: aTextEditorInputFilter ]
]

{ #category : #'initialize-release' }
GtAbstractRenameAction >> forBinaryOrKeyword [
	validationBlock := [ :str | (self validateKeyword: str) or: [ self validateBinary: str ] ]
]

{ #category : #'initialize-release' }
GtAbstractRenameAction >> forKeyword [
	validationBlock := [ :str | self validateKeyword: str ]
]

{ #category : #'initialize-release' }
GtAbstractRenameAction >> forText [
	validationBlock := [ :str | true ].
	self filter: BrTextEditorNoInputFilter new
]

{ #category : #'initialize-release' }
GtAbstractRenameAction >> forVariableOrUnaryMessage [
	validationBlock := [ :str | self validateVariable: str ].
	self filter: BrTextEditorAlphaNumericInputFilter new
]

{ #category : #initialization }
GtAbstractRenameAction >> initialize [
	super initialize.
	originalLocations := #().
	isInstalled := false.
	selectAll := false.
	filter := BrTextEditorNoInputFilter new
]

{ #category : #installation }
GtAbstractRenameAction >> install [
	originalLocations isEmpty
		ifTrue: [ ^ self ].
	self preventSave.
	self saveOriginalState.
	self addRenameAttributes.
	isInstalled := true.
	self announceEvent: #install
]

{ #category : #testing }
GtAbstractRenameAction >> isInstalled [
	^ isInstalled
]

{ #category : #testing }
GtAbstractRenameAction >> isRenameAttribute: anAttribute [
	^ anAttribute isKindOf: GtRenamePreviewAttribute
]

{ #category : #'private-validation' }
GtAbstractRenameAction >> isValid [
	validationBlock isNil
		ifTrue: [ ^ true ].
	^ validationBlock value: self newName
]

{ #category : #accessing }
GtAbstractRenameAction >> locations: aCollectionOfIntervals [
	originalLocations := aCollectionOfIntervals asSortedCollection: [ :a :b | a first < b first ].
	self validateLocations
]

{ #category : #actions }
GtAbstractRenameAction >> lostFocus [
	self isValid
		ifTrue: [ self accept ]
		ifFalse: [ self cancel ]
]

{ #category : #accessing }
GtAbstractRenameAction >> newName [
	^ renameAttributes first text asString
]

{ #category : #accessing }
GtAbstractRenameAction >> originalName [
	^ (originalText
		copyFrom: originalLocations first first
		to: originalLocations first last) asString
]

{ #category : #installation }
GtAbstractRenameAction >> preventSave [
]

{ #category : #private }
GtAbstractRenameAction >> primaryRenameAttribute [
	renameAttributes isNil
		ifTrue: [ ^ nil ].
	^ renameAttributes
		detect: [ :each | each isEditorAttribute ]
		ifNone: [ nil ]
]

{ #category : #private }
GtAbstractRenameAction >> removeAttributes [
	self subclassResponsibility
]

{ #category : #actions }
GtAbstractRenameAction >> returnAccept [
	self isValid
		ifFalse: [ ^ self ].
	self accept
]

{ #category : #private }
GtAbstractRenameAction >> saveOriginalState [
	self subclassResponsibility
]

{ #category : #accessing }
GtAbstractRenameAction >> selectAll [
	^ selectAll
]

{ #category : #accessing }
GtAbstractRenameAction >> selectAll: aBoolean [
	selectAll := aBoolean
]

{ #category : #actions }
GtAbstractRenameAction >> tabAccept: forward [
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
GtAbstractRenameAction >> undoChanges [
	self subclassResponsibility
]

{ #category : #installation }
GtAbstractRenameAction >> uninstall [
	self removeAttributes.
	isInstalled := false.
	self allowSave.
	self announceEvent: #uninstall
]

{ #category : #actions }
GtAbstractRenameAction >> updateName: blText [	
	renameAttributes do: [ :each | each updateText: blText ].
	self announceEvent: #textUpdated
]

{ #category : #private }
GtAbstractRenameAction >> updateSource [
	self subclassResponsibility
]

{ #category : #'private-validation' }
GtAbstractRenameAction >> validateBinary: aString [
	aString isEmpty
		ifTrue: [ ^ false ].
	^ (RBScanner isSelector: aString) and: [ aString asSymbol isBinary ]
]

{ #category : #'private-validation' }
GtAbstractRenameAction >> validateKeyword: aString [
	aString isEmpty
		ifTrue: [ ^ false ].
	aString last = $:
		ifFalse: [ ^ false ].
	^ (RBScanner isSelector: aString)
		and: [ aString asSymbol numArgs = 1 ]
]

{ #category : #private }
GtAbstractRenameAction >> validateLocations [
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
GtAbstractRenameAction >> validateVariable: aString [
	^ RBScanner isVariable: aString
]

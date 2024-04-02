Class {
	#name : #GtRefactoryChangeManager,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'undo',
		'redo',
		'isPerformingChanges',
		'announcer'
	],
	#classVars : [
		'Instance',
		'UndoSize'
	],
	#category : #'GToolkit-Coder-Refactoring'
}

{ #category : #'class initialization' }
GtRefactoryChangeManager class >> initialize [
	self nuke.
	UndoSize := 200
]

{ #category : #accessing }
GtRefactoryChangeManager class >> instance [
	^ Instance ifNil: [ Instance := self new ]
]

{ #category : #'class initialization' }
GtRefactoryChangeManager class >> nuke [
	Instance notNil ifTrue: [ Instance release ].
	Instance := nil
]

{ #category : #accessing }
GtRefactoryChangeManager class >> undoSize [
	^ UndoSize
]

{ #category : #accessing }
GtRefactoryChangeManager class >> undoSize: anInteger [
	UndoSize := anInteger max: 0.
	Instance
		ifNotNil: [ Instance checkUndoStackLimit ifTrue: [ Instance announceUndoChanged ] ]
]

{ #category : #accessing }
GtRefactoryChangeManager class >> unload [
	self nuke
]

{ #category : #'undo/redo' }
GtRefactoryChangeManager >> addUndo: aChange [
	undo addLast: (GtPerformedChange onChange: aChange).
	self checkUndoStackLimit.
	redo removeAll.
	self announceUndoChanged
]

{ #category : #executing }
GtRefactoryChangeManager >> announceUndoChanged [
	self
		announce: (GtRefactoryChangeManagerUndoChangedEvent new
				changeManager: self;
				yourself)
]

{ #category : #announcer }
GtRefactoryChangeManager >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
GtRefactoryChangeManager >> changeFactory [
	^ RBRefactoryChangeFactory new
]

{ #category : #'undo/redo' }
GtRefactoryChangeManager >> checkUndoStackLimit [
	| previousSize |
	previousSize := undo size.
	[ undo size > UndoSize ] whileTrue: [ undo removeFirst ].
	^ previousSize ~= undo size
]

{ #category : #private }
GtRefactoryChangeManager >> clearUndoRedoList [
	(undo isEmpty and: [ redo isEmpty ]) ifTrue: [ ^ self ].
	undo removeAll.
	redo removeAll.
	self announceUndoChanged
]

{ #category : #private }
GtRefactoryChangeManager >> connectToChanges [
	SystemAnnouncer uniqueInstance weak
		when: ClassAdded , ClassModifiedClassDefinition , ClassRemoved , ClassRenamed
				, MethodAdded , MethodModified , MethodRemoved
		send: #update:
		to: self
]

{ #category : #private }
GtRefactoryChangeManager >> disconnectFromChanges [
	SystemAnnouncer uniqueInstance unsubscribe: self
]

{ #category : #accessing }
GtRefactoryChangeManager >> gtUndoFor: aView [
	<gtView>
	| update |
	update := [ :element | 
		element
			allParentsDetect: [ :each | each phlow isViewContent ]
			ifFound: [ :each | each phlow syncUpdate ]
			ifNone: [  ] ].
	^ aView columnedList
		title: 'Undo';
		priority: 10;
		items: [ redo , undo reversed ];
		column: 'Timestamp'
			text: [ :each | 
				| text |
				text := each timestamp printToSeconds asRopedText.
				(redo identityIncludes: each)
					ifTrue: [ text foreground: BrGlamorousColors disabledHeaderTextColor ].
				text ]
			width: 130;
		column: 'Change'
			text: [ :each | 
				| text |
				text := each change gtDescription asRopedText.
				(redo identityIncludes: each)
					ifTrue: [ text foreground: BrGlamorousColors disabledHeaderTextColor ].
				text ];
		contextItemLabel: 'Undo'
			action: [ :element :each | 
				self undoChange.
				update value: element ]
			if: [ :each | (undo at: undo size ifAbsent: [  ]) == each ];
		contextItemLabel: 'Undo up to here'
			action: [ :element :each | 
				| found |
				found := false.
				[ self hasUndoableOperations and: [ found not ] ]
					whileTrue: [ found := undo last == each.
						self undoChange ].
				update value: element ]
			if: [ :each | (undo at: undo size ifAbsent: [  ]) ~~ each and: [ undo identityIncludes: each ] ];
		contextItemLabel: 'Redo'
			action: [ :element :each | 
				self redoChange.
				update value: element ]
			if: [ :each | (redo at: redo size ifAbsent: [  ]) == each ];
		contextItemLabel: 'Redo back to here'
			action: [ :element :each | 
				| found |
				found := false.
				[ self hasRedoableOperations and: [ found not ] ]
					whileTrue: [ found := redo last == each.
						self redoChange ].
				update value: element ]
			if: [ :each | (redo at: redo size ifAbsent: [  ]) ~~ each and: [ redo identityIncludes: each ] ];
		actionButtonIcon: BrGlamorousVectorIcons refresh
			tooltip: 'Update undo/redo stacks'
			action: [ :aButton :aTab | 
				aButton disable.
				[ aTab viewContentElement phlow syncUpdate ] asAsyncPromise
					then: [ :aResult | aButton enable ]
					otherwise: [ :anError | aButton enable ] ]
]

{ #category : #testing }
GtRefactoryChangeManager >> hasRedoableOperations [
	^ redo notEmpty
]

{ #category : #testing }
GtRefactoryChangeManager >> hasUndoableOperations [
	^ undo notEmpty
]

{ #category : #executing }
GtRefactoryChangeManager >> ignoreChangesWhile: aBlock [
	isPerformingChanges ifTrue: [ ^ aBlock value ].
	isPerformingChanges := true.
	aBlock ensure: [ isPerformingChanges := false ]
]

{ #category : #initialization }
GtRefactoryChangeManager >> initialize [
	super initialize.
	undo := OrderedCollection new.
	redo := OrderedCollection new.
	isPerformingChanges := false.
	self connectToChanges
]

{ #category : #executing }
GtRefactoryChangeManager >> performChange: aRefactoringChange [
	self ignoreChangesWhile: [ self addUndo: aRefactoringChange execute ]
]

{ #category : #executing }
GtRefactoryChangeManager >> redoChange [
	redo isEmpty ifTrue: [ ^ self ].
	self
		ignoreChangesWhile: [ undo add: (GtPerformedChange onChange: redo removeLast change execute) ].
	self announceUndoChanged
]

{ #category : #initialization }
GtRefactoryChangeManager >> release [
	self disconnectFromChanges.
	super release
]

{ #category : #executing }
GtRefactoryChangeManager >> undoChange [
	undo isEmpty ifTrue: [ ^ self ].
	self
		ignoreChangesWhile: [ redo add: (GtPerformedChange onChange: undo removeLast change execute) ].
	self announceUndoChanged
]

{ #category : #private }
GtRefactoryChangeManager >> update: anEvent [
	isPerformingChanges ifFalse: [ self clearUndoRedoList ]
]

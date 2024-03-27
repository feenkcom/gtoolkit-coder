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
	undo addLast: aChange.
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
GtRefactoryChangeManager >> gtRedoFor: aView [
	<gtView>
	redo isEmpty ifTrue: [ ^ aView empty ].
	^ aView list
		title: 'Redo';
		priority: 15;
		items: [ redo reversed ];
		itemText: #gtDescription
]

{ #category : #accessing }
GtRefactoryChangeManager >> gtUndoFor: aView [
	<gtView>
	^ aView list
		title: 'Undo';
		priority: 10;
		items: [ undo reversed ];
		itemText: #gtDescription
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
	isPerformingChanges := false
]

{ #category : #executing }
GtRefactoryChangeManager >> performChange: aRefactoringChange [
	self ignoreChangesWhile: [ self addUndo: aRefactoringChange execute ]
]

{ #category : #executing }
GtRefactoryChangeManager >> redoChange [
	redo isEmpty ifTrue: [ ^ self ].
	self ignoreChangesWhile: [ undo add: redo removeLast execute ].
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
	self ignoreChangesWhile: [ redo add: undo removeLast execute ].
	self announceUndoChanged
]

{ #category : #private }
GtRefactoryChangeManager >> update: anEvent [
	isPerformingChanges ifFalse: [ self clearUndoRedoList ]
]

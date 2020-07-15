Class {
	#name : #GtFixItStyler,
	#superclass : #GtASTStyler,
	#instVars : [
		'methodCoder',
		'editorElement'
	],
	#category : #'GToolkit-Coder-FixIt'
}

{ #category : #accessing }
GtFixItStyler >> canAddInstanceVariable: aString to: aClass [
	(Object includesBehavior: aClass)
		ifTrue: [ ^ false ].
	^ [ (RBAddInstanceVariableRefactoring variable: aString class: aClass)
		checkPreconditions.
	true ]
		on: RBRefactoringError
		do: [ :ex | ex return: false ]
]

{ #category : #'private - accessing editor' }
GtFixItStyler >> cursorPositionDo: aBlock [
	self editorElement editor cursors do: [ :eachCursor | ^ aBlock value: eachCursor position ]
]

{ #category : #accessing }
GtFixItStyler >> editorElement [
	<return: #BlEditorElement>
	^ editorElement
]

{ #category : #accessing }
GtFixItStyler >> editorElement: anEditorElement [
	editorElement := anEditorElement
]

{ #category : #accessing }
GtFixItStyler >> fixItActionsForVariable: aVariableNode [
	^ aVariableNode name first isUppercase
		ifTrue: [ self globalFixItActionsFor: aVariableNode ]
		ifFalse: [ self localFixItActionsFor: aVariableNode ]
]

{ #category : #accessing }
GtFixItStyler >> globalFixItActionsFor: aVariableNode [
	| actions possibleNames results |
	actions := OrderedCollection new.
	actions
		add:
			(GtDefineClassVariableFixItAction
				forCoder: methodCoder
				node: aVariableNode).
	possibleNames := aVariableNode temporaryVariables
		, methodCoder classOrMetaClass allInstVarNames.
	results := aVariableNode name
		correctAgainst: aVariableNode temporaryVariables
		continuedFrom: nil.
	results := methodCoder classOrMetaClass
		possibleVariablesFor: aVariableNode name
		continuedFrom: results.
	(aVariableNode name correctAgainst: nil continuedFrom: results)
		do: [ :each | 
			actions
				add:
					((GtRenameVariableFixItAction
						forCoder: methodCoder
						node: aVariableNode) newName: each) ].
	^ actions
]

{ #category : #accessing }
GtFixItStyler >> localFixItActionsFor: aVariableNode [
	| actions possibleNames |
	actions := OrderedCollection new.
	actions
		add:
			(GtDefineTemporaryFixItAction
				forCoder: methodCoder
				node: aVariableNode).
	(self
		canAddInstanceVariable: aVariableNode name
		to: methodCoder classOrMetaClass)
		ifTrue: [ actions
				add:
					(GtDefineInstanceVariableFixItAction
						forCoder: methodCoder
						node: aVariableNode) ].
	possibleNames := aVariableNode temporaryVariables
		, methodCoder classOrMetaClass allInstVarNames.
	(aVariableNode name correctAgainst: possibleNames)
		do: [ :each | 
			actions
				add:
					((GtRenameVariableFixItAction
						forCoder: methodCoder
						node: aVariableNode) newName: each) ].
	^ actions
]

{ #category : #accessing }
GtFixItStyler >> methodCoder: aCoder [
	methodCoder := aCoder
]

{ #category : #accessing }
GtFixItStyler >> visitMethodNode: aMethodNode [
	aMethodNode selector isDoIt
		ifTrue: [ ^ self ].
	^ super visitMethodNode: aMethodNode
]

{ #category : #visiting }
GtFixItStyler >> visitVariableNode: aVariableNode [
	aVariableNode isUndeclared
		ifTrue: [ | cursor |
			cursor := -1.
			self cursorPositionDo: [ :pos | cursor := pos ].
			(cursor between: aVariableNode start and: aVariableNode stop)
				ifFalse: [ | attribute |
					attribute := GtFixItAttribute new.
					attribute
						fixItActions: [ self fixItActionsForVariable: aVariableNode ].
					self
						styleFrom: aVariableNode stop
						to: aVariableNode stop
						with: {attribute} ] ].
	super visitVariableNode: aVariableNode
]

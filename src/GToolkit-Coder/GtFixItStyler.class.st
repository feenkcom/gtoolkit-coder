Class {
	#name : #GtFixItStyler,
	#superclass : #GtASTStyler,
	#instVars : [
		'methodCoder',
		'editorElement'
	],
	#category : #'GToolkit-Coder-FixIt'
}

{ #category : #'private-variables' }
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
	<return: #BrEditorElement>
	^ editorElement
]

{ #category : #accessing }
GtFixItStyler >> editorElement: anEditorElement [
	editorElement := anEditorElement
]

{ #category : #'private-variables' }
GtFixItStyler >> fixItActionsForVariable: aVariableNode [
	^ aVariableNode name first isUppercase
		ifTrue: [ self globalFixItActionsFor: aVariableNode ]
		ifFalse: [ self localFixItActionsFor: aVariableNode ]
]

{ #category : #'private-variables' }
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

{ #category : #'private-variables' }
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

{ #category : #'private-messages' }
GtFixItStyler >> typeOf: aNode [
	aNode isSelf
		ifTrue: [ ^ methodCoder classOrMetaClass ].
	aNode isSuper
		ifTrue: [ ^ methodCoder classOrMetaClass
				ifNotNil: [ :class | class superclass ] ].
	aNode isLiteralNode
		ifTrue: [ ^ aNode value class ].
	aNode isDynamicArray
		ifTrue: [ ^ {} class ].
	aNode isMessage
		ifTrue: [ aNode selector = #class
				ifTrue: [ ^ (self typeOf: aNode receiver) ifNotNil: [ :class | class class ] ].
			(#(new new:) includes: aNode selector)
				ifTrue: [ ^ (self typeOf: aNode receiver)
						ifNotNil: [ :class | class instanceSide ] ] ].
	aNode isVariable
		ifTrue: [ aNode binding
				ifNotNil: [ :binding | 
					binding isLiteralVariable
						ifTrue: [ binding value ifNotNil: [ :object | ^ object class ] ].
					binding isThisContext
						ifTrue: [ ^ Context ] ] ].
	^ nil
]

{ #category : #visiting }
GtFixItStyler >> visitMessageNode: aNode [
	| cursor intervals |
	cursor := -1.
	self cursorPositionDo: [ :pos | cursor := pos ].
	intervals := aNode keywordsIntervals.
	(intervals
		anySatisfy: [ :each | cursor between: each first and: each last ])
		ifFalse: [ (self typeOf: aNode receiver)
				ifNotNil: [ :class | 
					(class whichClassIncludesSelector: aNode selector)
						ifNil: [ | attribute |
							attribute := GtFixItAttribute new.
							attribute
								fixItActions: [ {((GtDefineMethodFixItAction forCoder: methodCoder node: aNode)
										classOrMetaClass: class)} ].
							self
								styleFrom: intervals last last
								to: intervals last last
								with: {attribute} ] ] ].
	super visitMessageNode: aNode
]

{ #category : #visiting }
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

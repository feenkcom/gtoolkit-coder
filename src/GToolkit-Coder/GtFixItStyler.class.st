Class {
	#name : #GtFixItStyler,
	#superclass : #GtASTStyler,
	#instVars : [
		'methodCoder'
	],
	#category : #'GToolkit-Coder-FixIt'
}

{ #category : #accessing }
GtFixItStyler >> canAddInstanceVariable: aString to: aClass [
	^ [ (RBAddInstanceVariableRefactoring variable: aString class: aClass)
		checkPreconditions.
	true ]
		on: RBRefactoringError
		do: [ :ex | ex return: false ]
]

{ #category : #accessing }
GtFixItStyler >> fixItActionsForVariable: aVariableNode [
	^ aVariableNode name first isUppercase
		ifTrue: [ self globalFixItActionsFor: aVariableNode ]
		ifFalse: [ self localFixItActionsFor: aVariableNode ]
]

{ #category : #accessing }
GtFixItStyler >> globalFixItActionsFor: aVariableNode [
	^ #()
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

{ #category : #visiting }
GtFixItStyler >> visitVariableNode: aVariableNode [
	aVariableNode isUndeclared
		ifTrue: [ | cursor |
			cursor := -1.
			methodCoder cursorPositionDo: [ :pos | cursor := pos ].
			(cursor between: aVariableNode start and: aVariableNode stop)
				ifFalse: [ (self fixItActionsForVariable: aVariableNode)
						ifNotEmpty: [ :actions | 
							| attribute |
							attribute := GtFixItAttribute new.
							attribute fixItActions: actions.
							self
								styleFrom: aVariableNode stop
								to: aVariableNode stop
								with: {attribute} ] ] ].
	super visitVariableNode: aVariableNode
]

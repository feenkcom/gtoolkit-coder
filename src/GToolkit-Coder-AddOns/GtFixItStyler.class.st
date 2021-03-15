Class {
	#name : #GtFixItStyler,
	#superclass : #GtAstStyler,
	#instVars : [
		'isForWorkspace'
	],
	#category : #'GToolkit-Coder-AddOns-FixIt'
}

{ #category : #'private - variables' }
GtFixItStyler >> canAddInstanceVariable: aString to: aClass [
	(Object includesBehavior: aClass)
		ifTrue: [ ^ false ].
	^ [ (RBAddInstanceVariableRefactoring variable: aString class: aClass)
		checkPreconditions.
	true ]
		on: RBRefactoringError
		do: [ :ex | ex return: false ]
]

{ #category : #'private - variables' }
GtFixItStyler >> fixItActionsForVariable: aVariableNode [
	^ aVariableNode name first isUppercase
		ifTrue: [ self globalFixItActionsFor: aVariableNode ]
		ifFalse: [ self localFixItActionsFor: aVariableNode ]
]

{ #category : #'private - variables' }
GtFixItStyler >> globalFixItActionsFor: aVariableNode [
	| actions possibleNames results |
	actions := OrderedCollection new.
	actions
		add: (GtDefineClassFixItAction forCoder: self sourceCoder node: aVariableNode).
	isForWorkspace
		ifFalse: [ actions
				add:
					(GtDefineClassVariableFixItAction
						forCoder: self sourceCoder
						node: aVariableNode) ].
	possibleNames := aVariableNode temporaryVariables
		, self sourceCoder behavior allInstVarNames.
	results := aVariableNode name
		correctAgainst: aVariableNode temporaryVariables
		continuedFrom: nil.
	results := self sourceCoder behavior
		possibleVariablesFor: aVariableNode name
		continuedFrom: results.
	(aVariableNode name correctAgainst: nil continuedFrom: results)
		do: [ :each | 
			actions
				add:
					((GtRenameVariableFixItAction
						forCoder: self sourceCoder
						node: aVariableNode) newName: each) ].
	^ actions
]

{ #category : #testing }
GtFixItStyler >> hasRefactoring [
	^ text hasAttributeSuchThat: [ :eachAttribute | eachAttribute isKindOf: GtRefactoringChangesAttribute ]
]

{ #category : #accessing }
GtFixItStyler >> initialize [
	super initialize.
	isForWorkspace := false
]

{ #category : #accessing }
GtFixItStyler >> isForWorkspace: aBoolean [
	isForWorkspace := aBoolean
]

{ #category : #'private - variables' }
GtFixItStyler >> localFixItActionsFor: aVariableNode [
	| actions possibleNames |
	actions := OrderedCollection new.
	actions
		add:
			(GtDefineTemporaryFixItAction
				forCoder: self sourceCoder
				node: aVariableNode).
	(self
		canAddInstanceVariable: aVariableNode name
		to: self sourceCoder behavior)
		ifTrue: [ actions
				add:
					(GtDefineInstanceVariableFixItAction
						forCoder: self sourceCoder
						node: aVariableNode) ].
	possibleNames := aVariableNode temporaryVariables
		, self sourceCoder behavior allInstVarNames.
	(aVariableNode name correctAgainst: possibleNames)
		do: [ :each | 
			actions
				add:
					((GtRenameVariableFixItAction
						forCoder: self sourceCoder
						node: aVariableNode) newName: each) ].
	^ actions
]

{ #category : #accessing }
GtFixItStyler >> sourceCoder [
	^ self coderViewModel coderModel
]

{ #category : #'private - messages' }
GtFixItStyler >> typeOf: aNode [
	isForWorkspace
		ifFalse: [ aNode isSelf
				ifTrue: [ ^ self sourceCoder classOrMetaClass ].
			aNode isSuper
				ifTrue: [ ^ self sourceCoder classOrMetaClass
						ifNotNil: [ :class | class superclass ] ] ].
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
					(binding isSpecialVariable and: [ binding isThisContext ])
						ifTrue: [ ^ Context ] ] ].
	^ nil
]

{ #category : #visiting }
GtFixItStyler >> visitMessageNode: aNode [
	| intervals |

	intervals := aNode keywordsIntervals.
	(self
		typeOf: aNode receiver
		in: (isForWorkspace ifFalse: [ self sourceCoder behavior ]))
		ifNotNil: [ :class | 
			(class whichClassIncludesSelector: aNode selector)
				ifNil: [
					(((class isTrait
						and: [ (Object whichClassIncludesSelector: aNode selector) notNil ]) ) or: [ self hasRefactoring ])
							ifFalse: [ | attribute |
								attribute := GtFixItAttribute new.
								attribute
									fixItActions: [ {((GtDefineMethodFixItAction forCoder: self sourceCoder node: aNode)
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
	(aVariableNode isUndeclared
		and: [ isForWorkspace not or: [ aVariableNode name first isUppercase ] ])
		ifTrue: [
			 | attribute |
			attribute := GtFixItAttribute new.
			attribute
				fixItActions: [ self fixItActionsForVariable: aVariableNode ].
			self
				styleFrom: aVariableNode stop
				to: aVariableNode stop
				with: {attribute} ].

	super visitVariableNode: aVariableNode
]

Class {
	#name : #GtFixItStyler,
	#superclass : #GtGenericPharoStyler,
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
	^ aVariableNode variableName first isUppercase
		ifTrue: [ self globalFixItActionsFor: aVariableNode ]
		ifFalse: [ self localFixItActionsFor: aVariableNode ]
]

{ #category : #'private - variables' }
GtFixItStyler >> globalFixItActionsFor: aVariableNode [
	| theFixitActions results |

	theFixitActions := OrderedCollection new.
	theFixitActions add: (GtDefineClassFixItAction forCoder: self sourceCoder node: aVariableNode).

	isForWorkspace
		ifFalse: [
			| aDefineClassAction |
			aDefineClassAction := GtDefineClassVariableFixItAction
				forCoder: self sourceCoder
				node: aVariableNode.
			theFixitActions add: aDefineClassAction ].

	results := aVariableNode variableName
		correctAgainst: aVariableNode localVariables
		continuedFrom: nil.

	results := self sourceCoder behavior
		possibleVariablesFor: aVariableNode variableName
		continuedFrom: results.

	theFixitActions addAll: ((aVariableNode variableName correctAgainst: nil continuedFrom: results)
		collect: [ :each | 
			(GtRenameVariableFixItAction
				forCoder: self sourceCoder
				node: aVariableNode)
					newName: each ]).

	^ theFixitActions
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
	| theFixitActions possibleNames |

	theFixitActions := OrderedCollection new.
	theFixitActions add:
		(GtDefineTemporaryFixItAction
			forCoder: self sourceCoder
			node: aVariableNode).
	
	(self
		canAddInstanceVariable: aVariableNode variableName
		to: self sourceCoder behavior)
		ifTrue: [
			theFixitActions add:
				(GtDefineInstanceVariableFixItAction
					forCoder: self sourceCoder
					node: aVariableNode) ].
	possibleNames := aVariableNode localVariables, self sourceCoder behavior allInstVarNames.

	theFixitActions addAll: ((aVariableNode variableName correctAgainst: possibleNames)
		collect: [ :each | 
			(GtRenameVariableFixItAction
				forCoder: self sourceCoder
				node: aVariableNode) newName: each ]).

	^ theFixitActions
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
GtFixItStyler >> visitMessageSend: aNode [
	| theNodeType theClassForSelector attribute |
	super visitMessageSend: aNode.

	self hasRefactoring
		ifTrue: [ ^ self ].

	theNodeType := GtPharoProgramNode
		typeOf: aNode receiver
		in: (isForWorkspace ifFalse: [ self sourceCoder behavior ]).	
	theNodeType
		ifNil: [ ^ self ].
		
	theClassForSelector := theNodeType whichClassIncludesSelector: aNode selector.
	theClassForSelector
		ifNotNil: [ ^ self ].
	
	(theNodeType isTrait
		and: [ (Object whichClassIncludesSelector: aNode selector) notNil ])
			ifTrue: [ ^ self ].

	attribute := GtFixItAttribute new.
	attribute fixItActions: [ {
		(GtDefineMethodFixItAction forCoder: self sourceCoder node: aNode)
			classOrMetaClass: theNodeType
		} ].
	
	text
		attribute: attribute
		from: aNode selectorParts last stopPosition
		to: aNode selectorParts last stopPosition
]

{ #category : #visiting }
GtFixItStyler >> visitMethod: aMethodNode [
	aMethodNode selector isDoIt
		ifTrue: [ ^ self ].

	^ super visitMethod: aMethodNode
]

{ #category : #visiting }
GtFixItStyler >> visitVariable: aVariableNode [
	(aVariableNode isUndeclared
		and: [ isForWorkspace not or: [ aVariableNode variableName first isUppercase ] ])
		ifTrue: [
			 | attribute |
			attribute := GtFixItAttribute new.
			attribute fixItActions: [ self fixItActionsForVariable: aVariableNode ].
			text
				attribute: attribute
				from: aVariableNode name stopPosition
				to: aVariableNode name stopPosition ].

	super visitVariable: aVariableNode
]

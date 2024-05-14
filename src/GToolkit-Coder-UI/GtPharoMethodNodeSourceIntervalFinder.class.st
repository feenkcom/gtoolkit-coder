Class {
	#name : #GtPharoMethodNodeSourceIntervalFinder,
	#superclass : #Object,
	#instVars : [
		'methodNode',
		'sourceString',
		'sourceAst',
		'sourceNode',
		'sourceInterval'
	],
	#category : #'GToolkit-Coder-UI-Context'
}

{ #category : #finding }
GtPharoMethodNodeSourceIntervalFinder >> equivalentNodeTo: aNode in: otherTree [
	| equivParent nodeIndex equivNode |
	aNode isMethod ifTrue: [ ^ otherTree ].
	(aNode parent isReturn and: [ aNode parent parent parent isMethod ])
		ifTrue: [ equivNode := otherTree isSequence
					ifTrue: [ otherTree statements last ]
					ifFalse: [ otherTree ].
			^ equivNode isReturn ifTrue: [ equivNode value ] ifFalse: [ equivNode ] ].
	aNode parent isMethod
		ifTrue: [ otherTree isSequence ifTrue: [ ^ otherTree ] ifFalse: [ ^ otherTree parent ] ].
	equivParent := self equivalentNodeTo: aNode parent in: otherTree.
	equivParent ifNil: [ ^ nil ].
	nodeIndex := aNode parent children identityIndexOf: aNode.
	^ equivParent children at: nodeIndex ifAbsent: [ nil ]
]

{ #category : #finding }
GtPharoMethodNodeSourceIntervalFinder >> find [
	"Copy of SmaCCMethodNodeSourceIntervalFinder"

	<return: #Interval>
	sourceAst := RBParser
			parseExpression: sourceString
			onError: [ :msg :pos | ^ sourceInterval := 1 to: 0 ].
	sourceNode := self equivalentNodeTo: methodNode in: sourceAst.
	sourceNode ifNil: [ ^ sourceInterval := 1 to: 0 ].
	^ sourceInterval := sourceNode start to: sourceNode stop
]

{ #category : #accessing }
GtPharoMethodNodeSourceIntervalFinder >> methodNode [
	^ methodNode
]

{ #category : #accessing }
GtPharoMethodNodeSourceIntervalFinder >> methodNode: anObject [
	methodNode := anObject
]

{ #category : #'accessing - computed' }
GtPharoMethodNodeSourceIntervalFinder >> sourceAst [
	^ sourceAst
]

{ #category : #'accessing - computed' }
GtPharoMethodNodeSourceIntervalFinder >> sourceInterval [
	^ sourceInterval
]

{ #category : #'accessing - computed' }
GtPharoMethodNodeSourceIntervalFinder >> sourceNode [
	^ sourceNode
]

{ #category : #accessing }
GtPharoMethodNodeSourceIntervalFinder >> sourceString [
	^ sourceString
]

{ #category : #accessing }
GtPharoMethodNodeSourceIntervalFinder >> sourceString: anObject [
	sourceString := anObject
]

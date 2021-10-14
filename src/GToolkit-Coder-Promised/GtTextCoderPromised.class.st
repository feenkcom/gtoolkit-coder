Class {
	#name : #GtTextCoderPromised,
	#superclass : #GtTextualCoderPromised,
	#instVars : [
		'parser',
		'parserStartingState'
	],
	#category : #'GToolkit-Coder-Promised'
}

{ #category : #'as yet unclassified' }
GtTextCoderPromised >> asCoderUIModel [
	^ GtTextualCoderViewModel new coder: self
]

{ #category : #'api - ast' }
GtTextCoderPromised >> computeAst: theSourceString [
	^ parser
		ifNil: [ theSourceString ]
		ifNotNil: [
			parserStartingState
				ifNil: [ parser parseWithErrors: theSourceString ]
				ifNotNil: [ parser parseWithErrors: theSourceString startingAt: parserStartingState ] ]
]

{ #category : #initialization }
GtTextCoderPromised >> forString: aString [
	self sourceCode: (GtCoderExplicitSourceCode new source: aString)
]

{ #category : #initialization }
GtTextCoderPromised >> forText: aText [
	self sourceCode: (GtCoderExplicitTextSource new text: aText)
]

{ #category : #'instance creation' }
GtTextCoderPromised >> newCompletionStrategy [
	^ GtCompletionStrategy new
]

{ #category : #accessing }
GtTextCoderPromised >> parser [
	^ parser
]

{ #category : #accessing }
GtTextCoderPromised >> parser: anObject [
	parser := anObject
]

{ #category : #accessing }
GtTextCoderPromised >> parserStartingState [
	^ parserStartingState
]

{ #category : #accessing }
GtTextCoderPromised >> parserStartingState: anObject [
	parserStartingState := anObject
]

{ #category : #'api - ast' }
GtTextCoderPromised >> supportsAstCache [
	^ false
]

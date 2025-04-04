Class {
	#name : #GtTextCoder,
	#superclass : #GtTextualCoder,
	#instVars : [
		'parser',
		'parserStartingState'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'api - ast' }
GtTextCoder >> computeAst: theSourceString [
	^ parser
		ifNil: [ theSourceString ]
		ifNotNil: [
			parserStartingState
				ifNil: [ parser parseWithErrors: theSourceString ]
				ifNotNil: [ parser parseWithErrors: theSourceString startingAt: parserStartingState ] ]
]

{ #category : #initialization }
GtTextCoder >> forString: aString [
	self sourceCode: (GtCoderExplicitStringSource new source: aString)
]

{ #category : #accessing }
GtTextCoder >> parser [
	^ parser
]

{ #category : #accessing }
GtTextCoder >> parser: anObject [
	parser := anObject
]

{ #category : #accessing }
GtTextCoder >> parserStartingState [
	^ parserStartingState
]

{ #category : #accessing }
GtTextCoder >> parserStartingState: anObject [
	parserStartingState := anObject
]

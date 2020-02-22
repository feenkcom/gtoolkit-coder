Class {
	#name : #GtLiteralExplanationLinkStyler,
	#superclass : #GtSourceExplanationLinkStyler,
	#instVars : [
		'literalsDictionary'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #adding }
GtLiteralExplanationLinkStyler >> addLiteral: aSymbol [	
	self addLiteral: aSymbol withIdentifier: aSymbol.
]

{ #category : #adding }
GtLiteralExplanationLinkStyler >> addLiteral: aSymbol withIdentifier: anIdentifier [
	literalsDictionary at: aSymbol put: anIdentifier.
]

{ #category : #adding }
GtLiteralExplanationLinkStyler >> addLiterals: aCollection [
	aCollection do: [ :literal | self addLiteral: literal ].
]

{ #category : #initialization }
GtLiteralExplanationLinkStyler >> initialize [
	super initialize.
	literalsDictionary := IdentityDictionary new.
]

{ #category : #accessing }
GtLiteralExplanationLinkStyler >> literalsAssociations [
	^ literalsDictionary associations.
]

{ #category : #visiting }
GtLiteralExplanationLinkStyler >> visitLiteralArrayNode: aNode [
	super visitLiteralArrayNode: aNode.
	self literalsAssociations do: [:association |
		(aNode value = association key) ifTrue:
			[ self styleFrom: (aNode start - 1) to: (aNode start - 1) with: 
				{ GtYellowCircleExplanationTextAdornment forIdentifier: (association value) } ]]
]

{ #category : #visiting }
GtLiteralExplanationLinkStyler >> visitLiteralValueNode: aNode [
	super visitLiteralValueNode: aNode.
	self literalsAssociations do: [:association |
		(aNode value = association key) ifTrue:
			[ self styleFrom: (aNode start - 1) to: (aNode start - 1) with: 
				{ GtYellowCircleExplanationTextAdornment forIdentifier: (association value) } ]]
]

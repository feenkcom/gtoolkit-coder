"
I style literal nodes in a text with yellow circle adornments.
"
Class {
	#name : #GtLiteralExplanationLinkStyler,
	#superclass : #GtSourceExplanationLinkStyler,
	#instVars : [
		'literalsDictionary',
		'coder'
	],
	#category : #'GToolkit-Coder-AddOns-Explainer'
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

{ #category : #accessing }
GtLiteralExplanationLinkStyler >> coder: aMethodCoder [
	coder := aMethodCoder.
]

{ #category : #initialization }
GtLiteralExplanationLinkStyler >> initialize [
	super initialize.
	literalsDictionary := IdentityDictionary new.
	coder := GtPharoMethodCoder new.
]

{ #category : #accessing }
GtLiteralExplanationLinkStyler >> literalsAssociations [
	^ literalsDictionary associations.
]

{ #category : #asserting }
GtLiteralExplanationLinkStyler >> shouldAddUnderline [
	^ coder compiledMethod isNotNil.
]

{ #category : #visiting }
GtLiteralExplanationLinkStyler >> visitLiteralArrayNode: aNode [
	super visitLiteralArrayNode: aNode.
	self literalsAssociations do: [:association |
		(aNode value = association key) ifTrue: [ 
			self 
				styleFrom: (aNode start - 1) 
				to: (aNode start - 1) 
				with: ((self shouldAddUnderline)
					ifTrue: [ {GtTargetCircleWithUnderlineAdornment new
						identifier: (association value);
						coder: coder;
						node: aNode;
						start: aNode start;
						stop: aNode stop} ]
					ifFalse: [ {GtYellowCircleExplanationTextAdornment 
						forIdentifier: (association value)} ]) ]].
]

{ #category : #visiting }
GtLiteralExplanationLinkStyler >> visitLiteralValueNode: aNode [
	super visitLiteralValueNode: aNode.
	self literalsAssociations do: [:association |
		(aNode value = association key) ifTrue: [ 
			self 
				styleFrom: (aNode start - 1) 
				to: (aNode start - 1) 
				with: ((self shouldAddUnderline)
					ifTrue: [ {GtTargetCircleWithUnderlineAdornment new
						identifier: (association value);
						coder: coder;
						node: aNode;
						start: aNode start;
						stop: aNode stop} ]
					ifFalse: [ {GtYellowCircleExplanationTextAdornment 
						forIdentifier: (association value)} ]) ]].
]

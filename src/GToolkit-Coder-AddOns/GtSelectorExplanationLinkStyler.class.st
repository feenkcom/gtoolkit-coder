"
I add a yellow circle adornment to selectors in a text. The selectors are pragma nodes, literal nodes and message nodes.
"
Class {
	#name : #GtSelectorExplanationLinkStyler,
	#superclass : #GtSourceExplanationLinkStyler,
	#instVars : [
		'selectorsDictionary',
		'coder'
	],
	#category : #'GToolkit-Coder-AddOns-Explainer'
}

{ #category : #accessing }
GtSelectorExplanationLinkStyler >> addSelector: aSymbol [	
	self addSelector: aSymbol withIdentifier: aSymbol.
]

{ #category : #adding }
GtSelectorExplanationLinkStyler >> addSelector: aSymbol withIdentifier: anIdentifier [
	selectorsDictionary at: aSymbol put: anIdentifier.
]

{ #category : #adding }
GtSelectorExplanationLinkStyler >> addSelectors: aCollection [
	aCollection do: [ :selector | self addSelector: selector ].
]

{ #category : #accessing }
GtSelectorExplanationLinkStyler >> coder: aMethodCoder [
	coder := aMethodCoder.
]

{ #category : #initialization }
GtSelectorExplanationLinkStyler >> initialize [
	super initialize.
	selectorsDictionary := IdentityDictionary new.
	coder := GtPharoMethodCoder new.
]

{ #category : #accessing }
GtSelectorExplanationLinkStyler >> selectorsAssociations [
	^ selectorsDictionary associations.
]

{ #category : #asserting }
GtSelectorExplanationLinkStyler >> shouldAddUnderline [
	^ coder compiledMethod isNotNil.
]

{ #category : #visiting }
GtSelectorExplanationLinkStyler >> visitMessageNode: aMessageNode [
	super visitMessageNode: aMessageNode.
	self selectorsAssociations do: [ :association | 
		aMessageNode selector = association key ifTrue: [
			self 
					styleFrom: aMessageNode keywordsIntervals first first - 1 
					to: aMessageNode keywordsIntervals first first - 1
					with: ((self shouldAddUnderline)
						ifTrue: [ {GtTargetCircleWithUnderlineAdornment new
							identifier: (association value);
							coder: coder;
							node: aMessageNode;
							start: aMessageNode start;
							stop: aMessageNode stop} ]
						ifFalse: [ {GtYellowCircleExplanationTextAdornment 
							forIdentifier: association value} ]) ] ].
]

{ #category : #visiting }
GtSelectorExplanationLinkStyler >> visitPragmaNode: aNode [
	super visitPragmaNode: aNode.
	self selectorsAssociations do: [:association |
		(aNode selector = association key) ifTrue: 
			[ self styleFrom: (aNode start - 1) to: (aNode start - 1) 
				with: ((self shouldAddUnderline)
					ifTrue: [ {GtTargetCircleWithUnderlineAdornment new
						identifier: (association value);
						coder: coder;
						node: aNode;
						start: aNode left;
						stop: aNode right} ]
					ifFalse: [ {GtYellowCircleExplanationTextAdornment 
						forIdentifier: (association value)} ]) ]].
]

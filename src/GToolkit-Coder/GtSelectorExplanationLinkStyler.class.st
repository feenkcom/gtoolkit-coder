"
I add a yellow circle adornment to selectors in a text. The selectors are pragma nodes, literal nodes and message nodes.
"
Class {
	#name : #GtSelectorExplanationLinkStyler,
	#superclass : #GtSourceExplanationLinkStyler,
	#instVars : [
		'selectorsDictionary'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
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

{ #category : #initialization }
GtSelectorExplanationLinkStyler >> initialize [
	super initialize.
	selectorsDictionary := IdentityDictionary new.
]

{ #category : #accessing }
GtSelectorExplanationLinkStyler >> selectorsAssociations [
	^ selectorsDictionary associations.
]

{ #category : #visiting }
GtSelectorExplanationLinkStyler >> visitMessageNode: aMessageNode [
	super visitMessageNode: aMessageNode.
	self selectorsAssociations do: [ :association | 
		aMessageNode selector = association key ifTrue: [ 
			self 
				styleFrom: aMessageNode keywordsPositions first - 1 
				to: aMessageNode keywordsPositions first - 1
				with: { GtYellowCircleExplanationTextAdornment forIdentifier: association value } ] ]
]

{ #category : #visiting }
GtSelectorExplanationLinkStyler >> visitPragmaNode: aNode [
	super visitPragmaNode: aNode.
	self selectorsAssociations do: [:association |
		(aNode selector = association key) ifTrue: 
			[ self styleFrom: (aNode start - 1) to: (aNode start - 1) 
				with: { GtYellowCircleExplanationTextAdornment forIdentifier: (association value) } ]].
]

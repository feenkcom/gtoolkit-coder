"
I add a yellow circle adornment to selectors in a text. The selectors are pragma nodes, literal nodes and message nodes.
"
Class {
	#name : #GtSelectorExplanationLinkStyler,
	#superclass : #GtSourceExplanationLinkStyler,
	#instVars : [
		'selectorsDictionary',
		'attributesPosition'
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

{ #category : #testing }
GtSelectorExplanationLinkStyler >> hasExplanationLinkAttributeAt: aPosition [
	^ self positions anySatisfy: [ :position | 
		aPosition = position ].
]

{ #category : #initialization }
GtSelectorExplanationLinkStyler >> initialize [
	super initialize.
	selectorsDictionary := IdentityDictionary new.
	attributesPosition := OrderedCollection new.
]

{ #category : #accessing }
GtSelectorExplanationLinkStyler >> positions [
	^ attributesPosition.
]

{ #category : #accessing }
GtSelectorExplanationLinkStyler >> selectorsAssociations [
	^ selectorsDictionary associations.
]

{ #category : #visiting }
GtSelectorExplanationLinkStyler >> visitLiteralNode: aNode [
	self selectorsAssociations do: [:association |
		super visitLiteralNode: aNode.
		(aNode value = association key) ifTrue:
			[ self styleFrom: (aNode start - 1) to: (aNode start - 1) with: 
				{ GtYellowCircleExplanationTextAdornment forIdentifier: (association value) }.
			  selectorsDictionary removeKey: (association key) ]].
]

{ #category : #visiting }
GtSelectorExplanationLinkStyler >> visitMessageNode: aMessageNode [
	| attribute |
	self selectorsAssociations do: [ :association | 
		super visitMessageNode: aMessageNode.
		aMessageNode selector = association key ifTrue: [ 
			aMessageNode selectorParts
				with: aMessageNode keywordsPositions
				do: [ :keyword :position | 
					attribute := association key = association value
						             ifTrue: [ 
						             GtYellowCircleExplanationTextAdornment 
							             forIdentifier: keyword ]
						             ifFalse: [ 
							             GtYellowCircleExplanationTextAdornment 
								             forIdentifier: association value ].
					(self hasExplanationLinkAttributeAt: position - 1)
						ifFalse: [
							self styleFrom: position - 1 to: position - 1 with: { attribute }.
							attributesPosition add: position-1 ] ] ] ]
]

{ #category : #visiting }
GtSelectorExplanationLinkStyler >> visitPragmaNode: aNode [
	self selectorsAssociations do: [:association |
		super visitPragmaNode: aNode.
		(aNode selector = association key) ifTrue: 
			[ self styleFrom: (aNode start - 1) to: (aNode start - 1) 
				with: { GtYellowCircleExplanationTextAdornment forIdentifier: (association value) }.
			  selectorsDictionary removeKey: (association key) ]].
]

Class {
	#name : #GtPharoSelectorReferenceAndLiteralHighlighter,
	#superclass : #GtPharoCodeHighlighter,
	#instVars : [
		'selector'
	],
	#category : #'GToolkit-Coder-Pharo-AddOns-Highlighter'
}

{ #category : #'instance creation' }
GtPharoSelectorReferenceAndLiteralHighlighter class >> forSelector: aSymbol [
	^ self new
		selector: aSymbol;
		yourself
]

{ #category : #accessing }
GtPharoSelectorReferenceAndLiteralHighlighter >> selector [
	^ selector
]

{ #category : #accessing }
GtPharoSelectorReferenceAndLiteralHighlighter >> selector: aSymbol [
	selector := aSymbol
]

{ #category : #visiting }
GtPharoSelectorReferenceAndLiteralHighlighter >> visitMessage: aMessageNode [
	super visitMessage: aMessageNode.

	aMessageNode selector = selector
		ifTrue: [
			aMessageNode selectorParts do: [ :eachSelectorPart |
				stream nextPut: (eachSelectorPart startPosition to: eachSelectorPart stopPosition) ] ]
]

{ #category : #visiting }
GtPharoSelectorReferenceAndLiteralHighlighter >> visitSymbolLiteral: aNode [
	super visitSymbolLiteral: aNode.

	aNode symbol = selector
		ifTrue: [ stream nextPut: (aNode startPosition to: aNode stopPosition) ]
]

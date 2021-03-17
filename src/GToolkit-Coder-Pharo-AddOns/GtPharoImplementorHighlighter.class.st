Class {
	#name : #GtPharoImplementorHighlighter,
	#superclass : #GtPharoCodeHighlighter,
	#instVars : [
		'selector'
	],
	#category : #'GToolkit-Coder-Pharo-AddOns-Highlighter'
}

{ #category : #'instance creation' }
GtPharoImplementorHighlighter class >> forSelector: aSymbol [
	^ self new
		selector: aSymbol;
		yourself
]

{ #category : #accessing }
GtPharoImplementorHighlighter >> selector [
	^ selector
]

{ #category : #accessing }
GtPharoImplementorHighlighter >> selector: aSymbol [
	selector := aSymbol
]

{ #category : #visiting }
GtPharoImplementorHighlighter >> visitMethod: aMethodNode [
	aMethodNode selector = selector
		ifTrue: [
			aMethodNode selectorParts
				do: [ :eachSelectorPart | stream nextPut: (eachSelectorPart startPosition to: eachSelectorPart stopPosition) ] ]
]

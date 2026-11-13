"
Copies the attributes of a captured source text onto matching text. Accepts an optional final carriage return appended by TextDiffBuilder. Attributes are applied by contiguous ranges, retaining editor defaults.
"
Class {
	#name : #GtFromTextStyler,
	#superclass : #BlTextStyler,
	#instVars : [
		'sourceText'
	],
	#category : #'GToolkit-Coder-UI-Diff'
}

{ #category : #private }
GtFromTextStyler >> privateStyle: aText [
	| sourceString targetString start attributes |
	sourceString := sourceText asString.
	targetString := aText asString.
	(targetString = sourceString or: [ targetString = (sourceString , String cr) ])
		ifFalse: [ self error: 'Target text does not align with the source text' ].
	sourceText isEmpty ifTrue: [ ^ aText ].
	start := 1.
	attributes := sourceText attributesAt: 1.
	2
		to: sourceText size
		do: [ :index | 
			| next |
			next := sourceText attributesAt: index.
			next = attributes
				ifFalse: [ aText
						attributes: attributes
						from: start
						to: index - 1.
					start := index.
					attributes := next ] ].
	aText
		attributes: attributes
		from: start
		to: sourceText size.
	^ aText
]

{ #category : #accessing }
GtFromTextStyler >> sourceText: aText [
	sourceText := aText copy
]

Class {
	#name : #GtCoderExamplePatternStyler,
	#superclass : #BrRBTextStyler,
	#instVars : [
		'coder'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #'method coder styler' }
GtCoderExamplePatternStyler class >> examplePatternStylerFor: aMethodCoder [
	<gtMethodCoderPatternStyler: 5>
	aMethodCoder example isNil
		ifTrue: [ ^ nil ].
	^ self new
		coder: aMethodCoder;
		classOrMetaClass: aMethodCoder classOrMetaClass;
		yourself
]

{ #category : #accessing }
GtCoderExamplePatternStyler >> coder [
	^ coder
]

{ #category : #accessing }
GtCoderExamplePatternStyler >> coder: aMethodCoder [
	coder := aMethodCoder
]

{ #category : #private }
GtCoderExamplePatternStyler >> privateStyle: aText [
	| result |
	result := super privateStyle: aText.
	(result from: result size to: result size) attributes: {(GtExampleStatusAttribute forResult: coder exampleResult)}.
	^ result
]

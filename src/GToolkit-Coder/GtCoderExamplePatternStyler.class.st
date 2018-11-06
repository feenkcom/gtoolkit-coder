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
GtCoderExamplePatternStyler >> style: aText ast: ast [
	super style: aText ast: ast.
	(aText from: aText size to: aText size) attributes: {(GtExampleStatusAttribute forResult: coder exampleResult)}
]

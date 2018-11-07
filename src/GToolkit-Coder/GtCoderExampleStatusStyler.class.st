Class {
	#name : #GtCoderExampleStatusStyler,
	#superclass : #BrRBTextStyler,
	#instVars : [
		'coder'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #'method coder styler' }
GtCoderExampleStatusStyler class >> examplePatternStylerFor: aMethodCoder [
	<gtMethodCoderPatternStyler: 5>
	aMethodCoder example isNil
		ifTrue: [ ^ nil ].
	^ self new
		coder: aMethodCoder;
		classOrMetaClass: aMethodCoder classOrMetaClass;
		yourself
]

{ #category : #accessing }
GtCoderExampleStatusStyler >> coder [
	^ coder
]

{ #category : #accessing }
GtCoderExampleStatusStyler >> coder: aMethodCoder [
	coder := aMethodCoder
]

{ #category : #private }
GtCoderExampleStatusStyler >> style: aText ast: ast [
	super style: aText ast: ast.
	(aText from: aText size to: aText size) attributes: {(GtExampleStatusAttribute forResult: coder exampleResult)}
]

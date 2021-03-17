Class {
	#name : #GtBlockCoderExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Coders'
}

{ #category : #examples }
GtBlockCoderExamples >> compileBlock [
	<gtExample>
	| block |
	
	block := self twoArgumentBlock block.
	self assert: (block value: 4 value: 3) = 10.
	
	^ block
]

{ #category : #examples }
GtBlockCoderExamples >> syntaxError [
	<gtExample>
	| aBlockClosureCoder wasSignalled |
	
	aBlockClosureCoder := GtPharoBlockClosureCoder new
		addParameter: 'a' ofType: Integer;
		addParameter: 'b' ofType: Integer;
		forSource: '2 * (+a sqrt + b)'.
	
	wasSignalled := false.
	[ aBlockClosureCoder block ]
		on: SyntaxErrorNotification
		do: [ :e | wasSignalled := true ].

	self assert: wasSignalled.

	^ aBlockClosureCoder
]

{ #category : #examples }
GtBlockCoderExamples >> twoArgumentBlock [
	<gtExample>

	^ GtPharoBlockClosureCoder new
		addParameter: 'a' ofType: Integer;
		addParameter: 'b' ofType: Integer;
		forSource: '2 * (a sqrt + b)'
]

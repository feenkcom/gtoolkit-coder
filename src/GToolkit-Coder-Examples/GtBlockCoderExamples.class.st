Class {
	#name : #GtBlockCoderExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples'
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
GtBlockCoderExamples >> twoArgumentBlock [
	<gtExample>
	^ GtBlockCoder new
		addParameter: 'a' ofType: Integer;
		addParameter: 'b' ofType: Integer;
		source: '2 * (a sqrt + b)'
]

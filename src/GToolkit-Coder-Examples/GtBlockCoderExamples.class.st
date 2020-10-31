Class {
	#name : #GtBlockCoderExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Model'
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

	^ GtBlockCoder new
		addParameter: 'a' ofType: Integer;
		addParameter: 'b' ofType: Integer;
		forSource: '2 * (+a sqrt + b)';
		block;
		yourself
]

{ #category : #examples }
GtBlockCoderExamples >> twoArgumentBlock [
	<gtExample>

	^ GtBlockCoder new
		addParameter: 'a' ofType: Integer;
		addParameter: 'b' ofType: Integer;
		forSource: '2 * (a sqrt + b)'
]

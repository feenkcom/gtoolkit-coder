Class {
	#name : #GtPharoSnippetCoderExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples'
}

{ #category : #examples }
GtPharoSnippetCoderExamples >> snippetCoder [
	<gtExample>
	| aSnippetCoder |
	aSnippetCoder := GtPharoSnippetCoder new
		forSource:
			'3 +
	4';
		yourself.

	self assert: aSnippetCoder expanded.
	self
		assert: aSnippetCoder variableBindings
		equals: GtSnippetBindings new.
	
	^ aSnippetCoder
]

{ #category : #examples }
GtPharoSnippetCoderExamples >> syntaxError [
	<gtExample>
	^ GtPharoSnippetCoder new
		forSource: '3 + - 4';
		yourself
]

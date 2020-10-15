Class {
	#name : #GtPharoSnippetCoderExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Model'
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
GtPharoSnippetCoderExamples >> snippetCoderDefaultDestinationChangeExample [
	<gtExample>
	| snippetCoder |
	snippetCoder := GtPharoSnippetCoder new.
	
	snippetCoder spawnDestination: GtPhlowSpawnBelowDestination new.
	self assert: snippetCoder spawnDestination isSpawnBelow.
	
	^ snippetCoder
]

{ #category : #examples }
GtPharoSnippetCoderExamples >> snippetCoderDefaultDestinationExample [
	<gtExample>
	| snippetCoder |
	snippetCoder := GtPharoSnippetCoder new.
	
	self assert: snippetCoder spawnDestination isSpawnNextPane.
	
	^ snippetCoder
]

{ #category : #examples }
GtPharoSnippetCoderExamples >> syntaxError [
	<gtExample>
	^ GtPharoSnippetCoder new
		forSource: '3 + - 4';
		yourself
]

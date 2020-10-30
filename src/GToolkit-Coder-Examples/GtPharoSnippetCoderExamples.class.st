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

	self
		assert: aSnippetCoder variableBindings
		equals: GtSnippetBindings new.
	
	^ aSnippetCoder
]

{ #category : #examples }
GtPharoSnippetCoderExamples >> snippetCoderDefaultDestinationExample [
	<gtExample>
	| snippetCoder |
	snippetCoder := self snippetCoder.
	
	self assert: snippetCoder spawnDestination isSpawnNextPane.
	
	^ snippetCoder
]

{ #category : #examples }
GtPharoSnippetCoderExamples >> snippetCoderDestinationChangeExample [
	<gtExample>
	| snippetCoder |
	snippetCoder := self snippetCoderDefaultDestinationExample.
	
	snippetCoder spawnDestination: GtPhlowSpawnBelowDestination new.
	self assert: snippetCoder spawnDestination isSpawnBelow.
	
	^ snippetCoder
]

{ #category : #examples }
GtPharoSnippetCoderExamples >> syntaxError [
	<gtExample>
	^ GtPharoSnippetCoder new
		forSource: '3 + - 4';
		yourself
]

Class {
	#name : #GtPharoSnippetCoderExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples'
}

{ #category : #examples }
GtPharoSnippetCoderExamples >> snippetCoder [
	<gtExample>
	^ GtPharoSnippetCoder new
		source:
			'3 +
	4';
		yourself
]

{ #category : #examples }
GtPharoSnippetCoderExamples >> syntaxError [
	<gtExample>
	^ GtPharoSnippetCoder new
		source: '3 + - 4';
		playAndInspectFrom: nil;
		yourself
]

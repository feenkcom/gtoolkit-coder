Class {
	#name : #GtBindingExamples,
	#superclass : #Object,
	#category : #'GToolkit-VariableBindings-Examples'
}

{ #category : #'binding strategy' }
GtBindingExamples >> defaultHighlightingBindingStrategy [
	<gtExample>
	<label: 'Default highlighting binding strategy'>
	^ GtHighlightingBindingStrategy new
]

{ #category : #'binding strategy' }
GtBindingExamples >> defaultSnippetBindingStrategy [
	<gtExample>
	<label: 'Default playground binding strategy'>
	^ GtSnippetBindingStrategy new
]

{ #category : #'binding strategy' }
GtBindingExamples >> highlightingBindingStrategy [
	<gtExample>
	<label: 'Initialized playground bindings'>
	^ self defaultHighlightingBindingStrategy
		bindings: self snippetEmptyBindings
]

{ #category : #'binding strategy' }
GtBindingExamples >> queryDefaultHighlightingBindingStrategy [
	<gtExample>
	<label: 'Query default highlighting binding strategy'>
	| strategy result |
	strategy := self defaultHighlightingBindingStrategy.
	result := strategy bindingOf: self variableOneName.
	self assert: result isNil.
	^ strategy
]

{ #category : #'binding strategy' }
GtBindingExamples >> queryDefaultSnippetBindingStrategy [
	<gtExample>
	<label: 'Query default playground binding strategy'>
	| strategy result |
	strategy := self defaultSnippetBindingStrategy.
	result := strategy bindingOf: self variableOneName.
	self assert: result isNil.
	^ strategy
]

{ #category : #'bindings - snippet' }
GtBindingExamples >> queryEmptySnippetBindings [
	<gtExample>
	<label: 'Query empty bindings'>
	| emptyBindings result |
	emptyBindings := self snippetEmptyBindings.
	result := emptyBindings
		bindingOf: self variableOneName.
	self assert: result isNil.
	^ emptyBindings
]

{ #category : #'binding strategy' }
GtBindingExamples >> queryHighlightingBindingStrategy [
	<gtExample>
	<label: 'Query highlighting binding strategy'>
	| strategy result |
	strategy := self highlightingBindingStrategy.
	result := strategy bindingOf: self variableOneName.
	self assert: result isNil.
	^ strategy
]

{ #category : #'binding strategy' }
GtBindingExamples >> querySnippetBindingStrategy [
	<gtExample>
	<label: 'Query playground binding strategy'>
	| strategy result |
	strategy := self snippetBindingStrategy.
	result := strategy bindingOf: self variableOneName.
	self assert: result notNil.
	self assert: result key equals: self variableOneName.
	self assert: result value equals: nil.
	^ result
]

{ #category : #'bindings - snippet' }
GtBindingExamples >> querySnippetBindingsWithReceiver [
	<gtExample>
	<label: 'Set receiver'>
	| bindings result |
	bindings := self snippetEmptyBindings.
	bindings receiver: self setSnippetBindingsReceiver.
	result := bindings bindingOf: #receiver.
	self assert: result isNil.
	^ bindings
]

{ #category : #'bindings - snippet' }
GtBindingExamples >> setSnippetBindings [
	<gtExample>
	<label: 'Set variable one'>
	| bindings result |
	bindings := self snippetEmptyBindings.
	bindings at: self variableOneName put: 42.
	result := bindings
		bindingOf: self variableOneName.
	self assert: result notNil.
	self assert: result value equals: 42.
	self assert: result key equals: self variableOneName.
	^ bindings
]

{ #category : #'bindings - snippet' }
GtBindingExamples >> setSnippetBindingsReceiver [
	<gtExample>
	<label: 'Set receiver'>
	| bindings |
	bindings := self snippetEmptyBindings.
	bindings receiver: 42.
	self assert: bindings receiver equals: 42.
	self assert: bindings receiverClass equals: 42 class.
	^ bindings
]

{ #category : #'bindings - snippet' }
GtBindingExamples >> setSnippetBindingsWithReceiver [
	<gtExample>
	| bindings result receiver |
	bindings := self querySnippetBindingsWithReceiver.
	receiver := self setSnippetBindingsReceiver.
	bindings receiver: receiver.
	bindings at: #receiver put: 42.
	result := receiver receiver.
	self assert: result notNil.
	self assert: result equals: 42.
	^ bindings
]

{ #category : #'binding strategy' }
GtBindingExamples >> snippetBindingStrategy [
	<gtExample>
	<label: 'Initialized playground bindings'>
	^ self defaultSnippetBindingStrategy
		bindings: self snippetEmptyBindings
]

{ #category : #'bindings - snippet' }
GtBindingExamples >> snippetEmptyBindings [
	<gtExample>
	<label: 'Default object bindings'>
	| aBindings |
	aBindings := GtSnippetBindings new.
	self assert: aBindings receiver isNil.
	self assert: aBindings asDictionary isEmpty.
	^ aBindings
]

{ #category : #accessing }
GtBindingExamples >> variableOneName [
	<gtExample>
	<label: 'Variable one name'>
	^ #variableOne
]

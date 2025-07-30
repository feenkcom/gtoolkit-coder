Class {
	#name : #GtCoderActionClosureDefinition,
	#superclass : #GtCoderActionDefinition,
	#instVars : [
		'closure'
	],
	#category : #'GToolkit-Coder-Coders - Addons'
}

{ #category : #accessing }
GtCoderActionClosureDefinition >> closure [
	^ closure
]

{ #category : #accessing }
GtCoderActionClosureDefinition >> closure: aBlock [
	closure := aBlock
]

{ #category : #'gt - extensions' }
GtCoderActionClosureDefinition >> gtClosureVariablesFor: aView [
	<gtView>
	^ aView forward
		title: 'Variables';
		object: [ closure ];
		view: #gtVariablesFor:
]

{ #category : #'gt - extensions' }
GtCoderActionClosureDefinition >> gtSourceCodeFor: aView [
	<gtView>
	^ aView forward
		title: 'Source code';
		priority: 1;
		object: [ self closure ];
		view: #gtSourceCodeFor:
]

{ #category : #testing }
GtCoderActionClosureDefinition >> isDefined [
	^ self closure isNotNil
]

Class {
	#name : #GtSearchExamplesFilter,
	#superclass : #GtSearchPragmasFilter,
	#instVars : [
		'coder',
		'resultState'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #defaults }
GtSearchExamplesFilter class >> defaultState [
	^ GtFilterExampleAllState default
]

{ #category : #comparing }
GtSearchExamplesFilter >> = anObject [
	^ super = anObject and: [ 
		self resultState = anObject resultState and: [ 
			self coder = anObject coder ] ]
]

{ #category : #accessing }
GtSearchExamplesFilter >> coder [
	<return: #GtSearchMethodsFilter>
	^ coder
]

{ #category : #accessing }
GtSearchExamplesFilter >> coder: aGtSearchMethodsFilter [
	coder := aGtSearchMethodsFilter
]

{ #category : #accessing }
GtSearchExamplesFilter >> filterValueString [
	^ self resultState label
]

{ #category : #comparing }
GtSearchExamplesFilter >> hash [
	^ (super hash bitXor: self resultState hash) 
		bitXor: self coder hash
]

{ #category : #testing }
GtSearchExamplesFilter >> includesMethod: aCompiledMethod [
	^ (super includesMethod: aCompiledMethod) and: [ 
		self satisfiesFilter: aCompiledMethod ]
]

{ #category : #initialization }
GtSearchExamplesFilter >> initialize [
	super initialize.
	symbol := #gtExample.
	resultState := self class defaultState.
]

{ #category : #accessing }
GtSearchExamplesFilter >> resultState [
	<return: #GtFilterExampleState>
	^ resultState
]

{ #category : #'api - initialization' }
GtSearchExamplesFilter >> resultState: aGtFilterExampleStatus [
	resultState := aGtFilterExampleStatus
]

{ #category : #'api - initialization' }
GtSearchExamplesFilter >> resultStateString: aString [
	self resultState: (GtFilterExampleState default stateFromLabel: aString)
]

{ #category : #testing }
GtSearchExamplesFilter >> satisfiesFilter: aCompiledMethod [
	| aMethodCoder |
	self coder ifNil: [ ^ true ].
	
	aMethodCoder := self coder exampler coderFor: aCompiledMethod.
	
	^ self resultState includesCoder: aMethodCoder.
]

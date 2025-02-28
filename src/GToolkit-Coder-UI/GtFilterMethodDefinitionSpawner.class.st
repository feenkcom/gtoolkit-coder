"
I find and spawn {{gtClass:GtFilterModel}} compiled method definitions.
"
Class {
	#name : #GtFilterMethodDefinitionSpawner,
	#superclass : #Object,
	#instVars : [
		'filterElement'
	],
	#category : #'GToolkit-Coder-UI-Filters - Support'
}

{ #category : #accessing }
GtFilterMethodDefinitionSpawner >> filterElement [
	^ filterElement
]

{ #category : #accessing }
GtFilterMethodDefinitionSpawner >> filterElement: anElement [
	filterElement := anElement
]

{ #category : #'api - spawning' }
GtFilterMethodDefinitionSpawner >> methodDefinition [
	<return: #CompiledMethod>
	| aSearchFilter aMethod aClass |
	filterElement hasFilterViewModel ifFalse: [ ^ nil ].

	aSearchFilter := filterElement filterViewModel filterModel asSearchFilter.
	aSearchFilter ifNil: [ ^ nil ].

	aClass := aSearchFilter class classSide.
	aMethod := aClass lookupSelector: #filterDescriptor2For:.
	(aMethod isNil
		or: [ aMethod = (GtSearchFilter class >> #filterDescriptor2For:) ])
			ifTrue: [ aMethod := aClass lookupSelector: #globalFilterDescriptor2 ].

	^ aMethod
]

{ #category : #'api - spawning' }
GtFilterMethodDefinitionSpawner >> spawn [
	filterElement ifNil: [ ^ self ].
	
	self methodDefinition ifNotNil: [ :aMethod |
		filterElement phlow spawnTool: (GtMethodCoderTool compiledMethod: aMethod) ].
]

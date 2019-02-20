Class {
	#name : #GtSearchMethodsFilterQuery,
	#superclass : #GtSearchMethodsQuery,
	#instVars : [
		'methodFilter'
	],
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #execution }
GtSearchMethodsFilterQuery >> buildResult: aQueryResult [
	| filteredMethods |
	filteredMethods := OrderedCollection new.
	
	scope methodsDo: [ :aCompiledMethod | 
		(methodFilter matches: aCompiledMethod) ifTrue: [
			filteredMethods add: aCompiledMethod ] ].
	^ filteredMethods
	"aQueryResult fillWith: filteredMethods" "Ideally add elements to the result from the query"
]

{ #category : #accessing }
GtSearchMethodsFilterQuery >> highlighter [
	^ methodFilter 
		ifNil: [ nil ]
		ifNotNil: [ methodFilter highlighter ]
]

{ #category : #accessing }
GtSearchMethodsFilterQuery >> methodFilter: aMethodFilter [
	self 
		assert: [ aMethodFilter isMethodFilter ] 
		description: 'Only method filters can be used with a method query'.
	methodFilter := aMethodFilter.
]

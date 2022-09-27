Class {
	#name : #GtLabeledSearchFilter,
	#superclass : #GtSearchFilter,
	#instVars : [
		'filter',
		'label',
		'methodDefinition'
	],
	#category : #'GToolkit-SearchFilters'
}

{ #category : #accessing }
GtLabeledSearchFilter class >> gtSearchFilterPragmaDescriptor [
	^ GtFilterDescriptor new
		creator: [ :value | 
			(self allSearchFilters
				detect: [ :each | each filterLabel = value ]
				ifNone: [ self allSearchFilters
						detect: [ :each | each filterLabel beginsWith: value caseSensitive: false ]
						ifNone: [ nil ] ]) ifNil: [ GtSearchImageMethodsFilter allMethods ] ];
		named: 'Custom Filter';
		order: 10;
		emptyDefaultValue: GtSearchImageMethodsFilter allMethods filterLabel;
		completion: [ GtStringsCompletionStrategy new
				completions: [ GtPrefixTree withAll: (self allSearchFilters collect: #filterLabel) ] ]
]

{ #category : #comparing }
GtLabeledSearchFilter >> = anObject [
	^ self class = anObject class
		and: [ self filterLabel = anObject filterLabel and: [ self filter = anObject filter ] ]
]

{ #category : #accessing }
GtLabeledSearchFilter >> children [
	^ {filter}
]

{ #category : #accessing }
GtLabeledSearchFilter >> defaultFilterScope [
	^ filter defaultFilterScope
]

{ #category : #accessing }
GtLabeledSearchFilter >> filter [
	^ filter
]

{ #category : #accessing }
GtLabeledSearchFilter >> filter: aSearchFilter [
	filter := aSearchFilter
]

{ #category : #accessing }
GtLabeledSearchFilter >> filterLabel [
	^ label
]

{ #category : #accessing }
GtLabeledSearchFilter >> filterLabel: aString [
	label := aString
]

{ #category : #accessing }
GtLabeledSearchFilter >> filterValueString [
	^ filter filterValueString
]

{ #category : #accessing }
GtLabeledSearchFilter >> gtDisplayOn: aStream [
	label gtDisplayOn: aStream
]

{ #category : #comparing }
GtLabeledSearchFilter >> hash [
	^ self filterLabel hash hashMultiply bitXor: self filter hash
]

{ #category : #accessing }
GtLabeledSearchFilter >> highlighter [
	^ filter highlighter
]

{ #category : #accessing }
GtLabeledSearchFilter >> matches: anObject [
	^ filter matches: anObject
]

{ #category : #accessing }
GtLabeledSearchFilter >> methodDefinition [
	^ methodDefinition
]

{ #category : #accessing }
GtLabeledSearchFilter >> methodDefinition: aCompiledMethod [
	methodDefinition := aCompiledMethod
]

{ #category : #accessing }
GtLabeledSearchFilter >> resultType [
	^ filter resultType
]

{ #category : #accessing }
GtLabeledSearchFilter >> size [
	^ filter size
]

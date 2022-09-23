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

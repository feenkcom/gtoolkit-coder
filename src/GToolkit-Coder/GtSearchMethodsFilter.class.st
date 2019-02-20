Class {
	#name : #GtSearchMethodsFilter,
	#superclass : #GtSearchFilter,
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #accessing }
GtSearchMethodsFilter class >> queryType [
	^ GtSearchMethodsFilterQuery
]

{ #category : #accessing }
GtSearchMethodsFilter class >> resultType [
	^ GtSearchMethodGroupResult 
]

{ #category : #accessing }
GtSearchMethodsFilter >> highlighter [
	^ nil
]

{ #category : #testing }
GtSearchMethodsFilter >> includeMethod: aCompiledMethod [
	self subclassResponsibility
]

{ #category : #accessing }
GtSearchMethodsFilter >> isEmpty [
	^ self asCollection isEmpty
]

{ #category : #testing }
GtSearchMethodsFilter >> isMethodFilter [
	^ true
]

{ #category : #testing }
GtSearchMethodsFilter >> matches: anObject [
	^ self includeMethod: anObject
]

{ #category : #'logical operations' }
GtSearchMethodsFilter >> not [
	^ GtCoderNegationFilter new originalFilter: self
]

{ #category : #testing }
GtSearchMethodsFilter >> notEmpty [
	^ self isEmpty not
]

{ #category : #accessing }
GtSearchMethodsFilter >> resultType [
	^ self class resultType
]

{ #category : #'logical operations' }
GtSearchMethodsFilter >> select: aBlock [
	^ self & (GtCoderBlockFilter forBlock: aBlock)
]

{ #category : #accessing }
GtSearchMethodsFilter >> size [
	^ self asCollection size
]

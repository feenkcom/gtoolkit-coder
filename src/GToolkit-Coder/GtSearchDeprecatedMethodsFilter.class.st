Class {
	#name : #GtSearchDeprecatedMethodsFilter,
	#superclass : #GtSearchMethodsFilter,
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #comparing }
GtSearchDeprecatedMethodsFilter >> = anObject [
	^ self class = anObject class
]

{ #category : #comparing }
GtSearchDeprecatedMethodsFilter >> hash [
	^ self class hash
]

{ #category : #testing }
GtSearchDeprecatedMethodsFilter >> includesMethod: aMethod [
	^ aMethod isDeprecated
]

Class {
	#name : #GtSearchDeprecatedMethodsFilter,
	#superclass : #GtSearchMethodsFilter,
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #testing }
GtSearchDeprecatedMethodsFilter >> includesMethod: aMethod [
	^ aMethod isDeprecated
]

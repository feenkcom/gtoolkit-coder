Class {
	#name : #GtSearchDeprecatedMethodsFilter,
	#superclass : #GtSearchMethodsFilter,
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #testing }
GtSearchDeprecatedMethodsFilter >> includesMethod: aMethod [
	^ aMethod isDeprecated
]

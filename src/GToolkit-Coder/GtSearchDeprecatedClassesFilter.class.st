Class {
	#name : #GtSearchDeprecatedClassesFilter,
	#superclass : #GtSearchClassesFilter,
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #testing }
GtSearchDeprecatedClassesFilter >> includesClass: aClass [
	^ aClass isDeprecated
]

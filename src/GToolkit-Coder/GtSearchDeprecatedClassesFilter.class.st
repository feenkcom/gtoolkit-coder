Class {
	#name : #GtSearchDeprecatedClassesFilter,
	#superclass : #GtSearchClassesFilter,
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #testing }
GtSearchDeprecatedClassesFilter >> includesClass: aClass [
	^ aClass isDeprecated
]

Class {
	#name : #GtSearchTestClassFilter,
	#superclass : #GtSearchClassesFilter,
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #testing }
GtSearchTestClassFilter >> includesClass: aClass [
	^ aClass isTestCase
]

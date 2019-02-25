Class {
	#name : #GtSearchTestClassesFilter,
	#superclass : #GtSearchClassesFilter,
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #testing }
GtSearchTestClassesFilter >> includesClass: aClass [
	^ aClass isTestCase
]

Class {
	#name : #GtSearchTestClassesFilter,
	#superclass : #GtSearchClassesFilter,
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #testing }
GtSearchTestClassesFilter >> includesClass: aClass [
	^ aClass isTestCase
]

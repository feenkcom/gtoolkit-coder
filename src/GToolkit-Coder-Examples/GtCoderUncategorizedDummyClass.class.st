"
I must be uncategorized!


"
Class {
	#name : #GtCoderUncategorizedDummyClass,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples'
}

{ #category : #examples }
GtCoderUncategorizedDummyClass >> checkUncategorized [
	<gtExample>
	<return: #RPackageTag>
	| aPackage aPackageTag |
	aPackage := self class package.
	aPackageTag := aPackage tags
			detect: [ :eachTag | eachTag name = aPackage name ].

	self assert: aPackage name equals: aPackageTag name.

	^ aPackageTag
]

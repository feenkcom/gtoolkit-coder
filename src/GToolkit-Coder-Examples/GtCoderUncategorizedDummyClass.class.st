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
	<return: #PackageTag>
	| aPackage aPackageTag |
	aPackage := self class package.
	aPackageTag := aPackage tags
			detect: [ :eachTag | eachTag isRoot ].

	self assert: aPackageTag isRoot.
	self assert: aPackage name equals: 'GToolkit-Coder-Examples'.
	self 
		forPharo12AndNewer: [
			self assert: aPackageTag name equals: 'Uncategorized'.] 
		forPharo11: [
			self assert: aPackage name equals: aPackageTag name ].

	^ aPackageTag
]

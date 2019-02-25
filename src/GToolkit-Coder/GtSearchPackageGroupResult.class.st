Class {
	#name : #GtSearchPackageGroupResult,
	#superclass : #GtSearchTypedGroupResult,
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #enumerating }
GtSearchPackageGroupResult >> refreshItems [
	self refreshPackages
]

{ #category : #enumerating }
GtSearchPackageGroupResult >> refreshPackages [
	| packages |
	filtered
		ifTrue: [ ^ self ].
	packages := OrderedCollection new.
	filter ifNotNil: [ 
		scope packagesDo: [ :aClass | 
			(filter matches: aClass) ifTrue: [
				packages add: aClass ] ] ].
	packages
		sort: [ :a :b | a name < b name ].
	items := packages.
	filtered := true.
]

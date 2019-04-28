Class {
	#name : #GtSearchClassesInPackageFilter,
	#superclass : #GtSearchClassesFilter,
	#instVars : [
		'package'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #'instance creation' }
GtSearchClassesInPackageFilter class >> forPackageNamed: aPackageName [
	^ self new
		package: aPackageName asPackage
]

{ #category : #comparing }
GtSearchClassesInPackageFilter >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ package = anObject package
]

{ #category : #enumerating }
GtSearchClassesInPackageFilter >> classesDo: aBlock [
	package definedClasses do: aBlock
]

{ #category : #accessing }
GtSearchClassesInPackageFilter >> defaultFilterScope [
	^ self
]

{ #category : #testing }
GtSearchClassesInPackageFilter >> includesClass: aClass [
	^ aClass package = package
]

{ #category : #enumerating }
GtSearchClassesInPackageFilter >> itemsDo: aBlock [
	^ self classesDo: aBlock
]

{ #category : #accessing }
GtSearchClassesInPackageFilter >> package [
	^ package
]

{ #category : #accessing }
GtSearchClassesInPackageFilter >> package: aPackage [
	package := aPackage
]

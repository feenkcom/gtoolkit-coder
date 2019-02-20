Class {
	#name : #GtSearchPackageMethodFilter,
	#superclass : #GtSearchMethodsFilter,
	#instVars : [
		'package'
	],
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #accessing }
GtSearchPackageMethodFilter >> defaultFilterScope [
	^ self
]

{ #category : #testing }
GtSearchPackageMethodFilter >> includeMethod: aCompiledMethod [
	aCompiledMethod package = package
]

{ #category : #enumerating }
GtSearchPackageMethodFilter >> methodsDo: aBlock [
	package methods do: aBlock.
]

{ #category : #accessing }
GtSearchPackageMethodFilter >> package: aPackage [
	package := aPackage
]

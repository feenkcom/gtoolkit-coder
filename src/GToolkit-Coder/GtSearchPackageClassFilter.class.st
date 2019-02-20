Class {
	#name : #GtSearchPackageClassFilter,
	#superclass : #GtSearchClassesFilter,
	#instVars : [
		'package'
	],
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #enumerating }
GtSearchPackageClassFilter >> classesDo: aBlock [
	package definedClasses do: aBlock
]

{ #category : #accessing }
GtSearchPackageClassFilter >> defaultFilterScope [
	^ self
]

{ #category : #testing }
GtSearchPackageClassFilter >> includesClass: aClass [
	^ aClass package = package
]

{ #category : #accessing }
GtSearchPackageClassFilter >> package: aPackage [
	package := aPackage
]

Class {
	#name : #GtCoderPackageExtensionTag,
	#superclass : #Object,
	#instVars : [
		'package'
	],
	#category : #'GToolkit-Coder-Navigation - Model'
}

{ #category : #'instance creation' }
GtCoderPackageExtensionTag class >> forPackage: aRPackage [
	^ self new package: aRPackage.
]

{ #category : #testing }
GtCoderPackageExtensionTag >> = anObject [
	^ self class = anObject class
		and: [ package = anObject package ]
]

{ #category : #accessing }
GtCoderPackageExtensionTag >> categoryName [
	^ self package categoryName
]

{ #category : #accessing }
GtCoderPackageExtensionTag >> classes [
	<return: #Array>
	^ self package extendedClasses asArray
]

{ #category : #accessing }
GtCoderPackageExtensionTag >> gtTagName [
	^ self name
]

{ #category : #testing }
GtCoderPackageExtensionTag >> hasExtendedClasses [
	<return: #Boolean>
	^ self package gtDoesExtendClasses
]

{ #category : #testing }
GtCoderPackageExtensionTag >> hash [
	^ package hash
]

{ #category : #testing }
GtCoderPackageExtensionTag >> isRoot [
	^false
]

{ #category : #testing }
GtCoderPackageExtensionTag >> isUncategorized [
	^false
]

{ #category : #accessing }
GtCoderPackageExtensionTag >> name [
	^ 'Extensions'
]

{ #category : #accessing }
GtCoderPackageExtensionTag >> package [
	<return: #Package>
	^ package
]

{ #category : #accessing }
GtCoderPackageExtensionTag >> package: aRPackage [
	package := aRPackage
]

{ #category : #accessing }
GtCoderPackageExtensionTag >> packageName [
	^ self package name
]

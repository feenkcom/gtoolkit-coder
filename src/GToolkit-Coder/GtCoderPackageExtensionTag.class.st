Class {
	#name : #GtCoderPackageExtensionTag,
	#superclass : #Object,
	#instVars : [
		'package',
		'classes'
	],
	#category : #'GToolkit-Coder-Navigation - Model'
}

{ #category : #'instance creation' }
GtCoderPackageExtensionTag class >> forPackage: aRPackage [
	^ self new package: aRPackage.
]

{ #category : #testing }
GtCoderPackageExtensionTag >> = anObject [
	^ self class == anObject class
		and: [ package = anObject package and: [ classes = anObject classes ] ]
]

{ #category : #accessing }
GtCoderPackageExtensionTag >> classes [
	<return: #Array>
	^ classes
]

{ #category : #accessing }
GtCoderPackageExtensionTag >> classes: anObject [
	classes := anObject
]

{ #category : #accessing }
GtCoderPackageExtensionTag >> gtTagName [
	^ self name
]

{ #category : #testing }
GtCoderPackageExtensionTag >> hasExtendedClasses [
	<return: #Boolean>
	^ self classes isNotEmpty
]

{ #category : #testing }
GtCoderPackageExtensionTag >> hash [
	^ package hash bitXor: classes hash
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

{ #category : #hooks }
GtCoderPackageExtensionTag >> onPackageChange [
	self classes: self package extendedClasses asArray
]

{ #category : #accessing }
GtCoderPackageExtensionTag >> package [
	<return: #RPackage>
	^ package
]

{ #category : #accessing }
GtCoderPackageExtensionTag >> package: aRPackage [
	package := aRPackage.
	self onPackageChange.
]

{ #category : #accessing }
GtCoderPackageExtensionTag >> packageName [
	^ self package name.
]

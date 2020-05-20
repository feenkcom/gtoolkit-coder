Class {
	#name : #GtCoderPackageExtentionTag,
	#superclass : #Object,
	#traits : 'TBlDebug',
	#classTraits : 'TBlDebug classTrait',
	#instVars : [
		'package',
		'classes'
	],
	#category : #'GToolkit-Coder-Navigation - Model'
}

{ #category : #'instance creation' }
GtCoderPackageExtentionTag class >> forPackage: aRPackage [
	^ self new package: aRPackage.
]

{ #category : #accessing }
GtCoderPackageExtentionTag >> classes [
	<return: #Array>
	^ classes
]

{ #category : #accessing }
GtCoderPackageExtentionTag >> classes: anObject [
	classes := anObject
]

{ #category : #testing }
GtCoderPackageExtentionTag >> hasExtendedClasses [
	<return: #Boolean>
	^ self classes isNotEmpty
]

{ #category : #accessing }
GtCoderPackageExtentionTag >> name [
	^ 'Extensions'
]

{ #category : #hooks }
GtCoderPackageExtentionTag >> onPackageChange [
	self classes: self package extendedClasses asArray
]

{ #category : #accessing }
GtCoderPackageExtentionTag >> package [
	<return: #RPackage>
	^ package
]

{ #category : #accessing }
GtCoderPackageExtentionTag >> package: aRPackage [
	package := aRPackage.
	self onPackageChange.
]

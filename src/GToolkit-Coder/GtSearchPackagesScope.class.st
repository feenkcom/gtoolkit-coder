Class {
	#name : #GtSearchPackagesScope,
	#superclass : #GtSearchCodeScope,
	#instVars : [
		'packages'
	],
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #'instance creation' }
GtSearchPackagesScope class >> forPackageNamed: aPackageName [
	^ self new
		packages: { aPackageName asPackage }
]

{ #category : #enumerating }
GtSearchPackagesScope >> classesDo: aBlock [
	self packagesDo: [ :package | 
		package definedClasses do: aBlock ]
]

{ #category : #testing }
GtSearchPackagesScope >> includeMethod: aCompiledMethod [
]

{ #category : #accessing }
GtSearchPackagesScope >> packages [
	^ packages
]

{ #category : #accessing }
GtSearchPackagesScope >> packages: aCollectionOfPackages [
	self assert: [ aCollectionOfPackages isNotNil ].
	self assert: [ aCollectionOfPackages isCollection ].
	packages := aCollectionOfPackages
]

{ #category : #enumerating }
GtSearchPackagesScope >> packagesDo: aBlock [
	self packages do: aBlock
]

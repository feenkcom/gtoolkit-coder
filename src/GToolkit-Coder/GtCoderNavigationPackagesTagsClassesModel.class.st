Class {
	#name : #GtCoderNavigationPackagesTagsClassesModel,
	#superclass : #Object,
	#instVars : [
		'packages',
		'selectedPackage',
		'selectedTag',
		'selectedClass'
	],
	#category : #'GToolkit-Coder-Navigation'
}

{ #category : #'instance creation' }
GtCoderNavigationPackagesTagsClassesModel class >> fromPackages: aCollectionOfPackages [
	^ self new fromPackages: aCollectionOfPackages
]

{ #category : #'api - accessing' }
GtCoderNavigationPackagesTagsClassesModel >> classesToShow [
	<return: #Collection of: #Class>

	self hasSelectedPackage
		ifFalse: [ ^ #() ].
		
	^ self hasSelectedTag
		ifTrue: [ self selectedTag classes ]
		ifFalse: [ self selectedPackage definedClasses ]
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesModel >> fromPackages: aCollectionOfRPackage [
	packages := aCollectionOfRPackage
]

{ #category : #testing }
GtCoderNavigationPackagesTagsClassesModel >> hasSelectedClass [
	<return: #Boolean>

	^ selectedClass isNotNil
]

{ #category : #testing }
GtCoderNavigationPackagesTagsClassesModel >> hasSelectedPackage [
	<return: #Boolean>

	^ selectedPackage isNotNil
]

{ #category : #testing }
GtCoderNavigationPackagesTagsClassesModel >> hasSelectedTag [
	<return: #Boolean>

	^ selectedTag isNotNil
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesModel >> initialize [
	super initialize.
	
	packages := #()	
]

{ #category : #'api - accessing' }
GtCoderNavigationPackagesTagsClassesModel >> selectedClass [
	<return: #Class>
	self
		assert: [ self hasSelectedClass ]
		description: [ 'A class must be selected' ].
		
	^ selectedClass
]

{ #category : #'api - accessing' }
GtCoderNavigationPackagesTagsClassesModel >> selectedClassDo: aBlock [
	self hasSelectedClass
		ifTrue: [ aBlock value: self selectedClass ]
]

{ #category : #'api - accessing' }
GtCoderNavigationPackagesTagsClassesModel >> selectedPackage [
	<return: #RPackage>
	self
		assert: [ self hasSelectedPackage ]
		description: [ 'A package must be selected' ].
		
	^ selectedPackage
]

{ #category : #'api - accessing' }
GtCoderNavigationPackagesTagsClassesModel >> selectedPackageDo: aBlock [
	self hasSelectedPackage
		ifTrue: [ aBlock value: self selectedPackage ]
]

{ #category : #'api - accessing' }
GtCoderNavigationPackagesTagsClassesModel >> selectedTag [
	<return: #RPackageTag>
	self
		assert: [ self hasSelectedTag ]
		description: [ 'A tag must be selected' ].
		
	^ selectedTag
]

{ #category : #'api - accessing' }
GtCoderNavigationPackagesTagsClassesModel >> selectedTagDo: aBlock [
	self hasSelectedTag
		ifTrue: [ aBlock value: self selectedTag ]
]

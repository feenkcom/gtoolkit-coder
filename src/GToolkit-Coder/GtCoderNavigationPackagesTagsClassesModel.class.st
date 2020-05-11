Class {
	#name : #GtCoderNavigationPackagesTagsClassesModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'announcer',
		'packages',
		'selectedPackage',
		'selectedTag',
		'selectedClass'
	],
	#category : #'GToolkit-Coder-Navigation - Model'
}

{ #category : #'instance creation' }
GtCoderNavigationPackagesTagsClassesModel class >> fromPackages: aCollectionOfPackages [
	^ self new initializeWithPackages: aCollectionOfPackages
]

{ #category : #announcer }
GtCoderNavigationPackagesTagsClassesModel >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
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

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesModel >> initializeWithPackages: aCollectionOfRPackage [
	packages := aCollectionOfRPackage.
	
	
]

{ #category : #'private - notifying' }
GtCoderNavigationPackagesTagsClassesModel >> notifyClassSelected: aClass package: anRPackage tag: anRPackageTag [
	self announcer announce: (GtCoderNavigationClassSelected new
		package: anRPackage;
		tag: anRPackageTag;
		theClass: aClass)
]

{ #category : #'private - notifying' }
GtCoderNavigationPackagesTagsClassesModel >> notifyMethodSelected: aMethod [
	self announcer
		announce: (GtCoderNavigationMethodSelected new method: aMethod)
]

{ #category : #'private - notifying' }
GtCoderNavigationPackagesTagsClassesModel >> notifyPackageSelected: anRPackage [
	self announcer announce: (GtCoderNavigationPackageSelected new package: anRPackage)
]

{ #category : #'private - notifying' }
GtCoderNavigationPackagesTagsClassesModel >> notifyTagSelected: anRPackageTag package: anRPackage [
	self announcer announce: (GtCoderNavigationTagSelected new
		package: anRPackage;
		tag: anRPackageTag)
]

{ #category : #'api - accessing' }
GtCoderNavigationPackagesTagsClassesModel >> packagesToShow [
	<return: #Collection of: #RPackage>

	^ packages
]

{ #category : #'api - selection' }
GtCoderNavigationPackagesTagsClassesModel >> selectClass: aClass [
	| aClassPackage |
	
	selectedClass = aClass
		ifTrue: [ ^ self ].
	
	aClassPackage := aClass package.
	
	(packages includes: aClassPackage)
		ifFalse: [ ^ self ].

	selectedClass := aClass.
	
	self notifyClassSelected: selectedClass package: selectedPackage tag: selectedTag
]

{ #category : #'api - selection' }
GtCoderNavigationPackagesTagsClassesModel >> selectMethod: aMethod [
	selectedClass := aMethod methodClass instanceSide.
	self notifyMethodSelected: aMethod
]

{ #category : #'api - selection' }
GtCoderNavigationPackagesTagsClassesModel >> selectPackage: anRPackage [
	(packages includes: anRPackage)
		ifFalse: [ ^ self ].
		
	selectedPackage := anRPackage.
	selectedTag := nil.
	
	self notifyPackageSelected: selectedPackage
]

{ #category : #'api - selection' }
GtCoderNavigationPackagesTagsClassesModel >> selectTag: anRPackageTag [		
	selectedTag = anRPackageTag
		ifTrue: [ ^ self ].
		
	(packages includes: anRPackageTag package)
		ifFalse: [ ^ self ].
	
	selectedPackage := anRPackageTag package.
	selectedTag := anRPackageTag.
	
	self notifyTagSelected: selectedTag package: selectedPackage
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

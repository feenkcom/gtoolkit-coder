Class {
	#name : #GtCoderNavigationPackagesTagsClassesModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'announcer',
		'packages',
		'coder'
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
	^ self selectedClass notNil
]

{ #category : #testing }
GtCoderNavigationPackagesTagsClassesModel >> hasSelectedPackage [
	<return: #Boolean>
	^ self selectedPackage notNil
]

{ #category : #testing }
GtCoderNavigationPackagesTagsClassesModel >> hasSelectedTag [
	<return: #Boolean>
	^ self selectedTag notNil
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesModel >> initialize [
	super initialize.
	
	packages := #().
	coder := GtPackagesCoder new
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesModel >> initializeWithPackages: aCollectionOfRPackage [
	packages := aCollectionOfRPackage.
	
	
]

{ #category : #'private - notifying' }
GtCoderNavigationPackagesTagsClassesModel >> notifyClassSelected: aClass package: anRPackage tag: anRPackageTag [
	self
		announce:
			(GtCoderNavigationClassSelected new
				coder: coder;
				package: anRPackage;
				tag: anRPackageTag;
				theClass: aClass)
]

{ #category : #'api - selection' }
GtCoderNavigationPackagesTagsClassesModel >> notifyCoderSelected [
	self announce: (GtCoderNavigationPackagesSelected new coder: coder)
]

{ #category : #'private - notifying' }
GtCoderNavigationPackagesTagsClassesModel >> notifyMethodSelected: aMethod [
	coder withSelectedMethod: aMethod
]

{ #category : #'private - notifying' }
GtCoderNavigationPackagesTagsClassesModel >> notifyPackageSelected: anRPackage [
	self
		announce:
			(GtCoderNavigationPackageSelected new
				coder: coder;
				package: anRPackage)
]

{ #category : #'private - notifying' }
GtCoderNavigationPackagesTagsClassesModel >> notifyTagSelected: anRPackageTag package: anRPackage [
	self
		announce:
			(GtCoderNavigationTagSelected new
				coder: coder;
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
	(packages includes: aClass package)
		ifFalse: [ ^ self ].
	(coder isForClass and: [ coder theClass = aClass ])
		ifFalse: [ coder := GtClassCoder forClass: aClass.
			self
				notifyClassSelected: aClass
				package: aClass package
				tag: (aClass package classTagForClass: aClass) ]
]

{ #category : #'api - selection' }
GtCoderNavigationPackagesTagsClassesModel >> selectCoder: aCoder [
	aCoder isForPackage
		ifTrue: [ (coder isForPackage and: [ aCoder package = coder package ])
				ifTrue: [ ^ self ].
			coder := aCoder.
			^ self notifyPackageSelected: coder package ].
	aCoder isForPackageTag
		ifTrue:
			[ (coder isForPackageTag and: [ aCoder packageTag = coder packageTag ])
				ifTrue: [ ^ self ].
			coder := aCoder.
			^ self notifyTagSelected: coder packageTag package: coder package ].
	aCoder isForClass
		ifTrue: [ (coder isForClass and: [ aCoder theClass = coder theClass ])
				ifTrue: [ ^ self ].
			coder := aCoder.
			^ self
				notifyClassSelected: coder theClass
				package: coder package
				tag: coder packageTag ].
	coder := aCoder.
	self notifyCoderSelected
]

{ #category : #'api - selection' }
GtCoderNavigationPackagesTagsClassesModel >> selectMethod: aMethod [
	self selectClass: aMethod methodClass instanceSide.
	self notifyMethodSelected: aMethod
]

{ #category : #'api - selection' }
GtCoderNavigationPackagesTagsClassesModel >> selectPackage: anRPackage [
	(packages includes: anRPackage)
		ifFalse: [ ^ self ].
	(coder isForPackage and: [ coder package = anRPackage ])
		ifTrue: [ ^ self ].
	(coder isForPackageTag and: [ coder package = anRPackage ])
		ifTrue: [ coder := coder packageCoder ]
		ifFalse: [ coder := GtPackageCoder forPackage: anRPackage ].
	self notifyPackageSelected: anRPackage
]

{ #category : #'api - selection' }
GtCoderNavigationPackagesTagsClassesModel >> selectTag: anRPackageTag [
	(packages includes: anRPackageTag package)
		ifFalse: [ ^ self ].
	(coder isForPackageTag and: [ coder packageTag = anRPackageTag ])
		ifTrue: [ ^ self ].
	coder := ((coder isForPackage
		and: [ coder package = anRPackageTag package ])
		ifTrue: [ coder packageTagCoderFor: anRPackageTag ])
		ifNil: [ GtPackageTagCoder forPackageTag: anRPackageTag ].
	self notifyTagSelected: anRPackageTag package: anRPackageTag package
]

{ #category : #'api - accessing' }
GtCoderNavigationPackagesTagsClassesModel >> selectedClass [
	<return: #Class>
	^ coder theClass
]

{ #category : #'api - accessing' }
GtCoderNavigationPackagesTagsClassesModel >> selectedClassDo: aBlock [
	self selectedClass ifNotNil: aBlock
]

{ #category : #'api - accessing' }
GtCoderNavigationPackagesTagsClassesModel >> selectedPackage [
	<return: #RPackage>
	^ coder package
]

{ #category : #'api - accessing' }
GtCoderNavigationPackagesTagsClassesModel >> selectedPackageDo: aBlock [
	self selectedPackage ifNotNil: aBlock
]

{ #category : #'api - accessing' }
GtCoderNavigationPackagesTagsClassesModel >> selectedTag [
	<return: #RPackageTag>
	^ coder packageTag
]

{ #category : #'api - accessing' }
GtCoderNavigationPackagesTagsClassesModel >> selectedTagDo: aBlock [
	self selectedTag ifNotNil: aBlock
]

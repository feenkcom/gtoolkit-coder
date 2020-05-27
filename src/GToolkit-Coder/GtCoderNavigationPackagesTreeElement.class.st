"
I show a simple list of packages sorting alphabetically
"
Class {
	#name : #GtCoderNavigationPackagesTreeElement,
	#superclass : #BrSimpleTree,
	#category : #'GToolkit-Coder-Navigation - UI'
}

{ #category : #'instance creation' }
GtCoderNavigationPackagesTreeElement class >> fromPackages: aCollectionOfPackages [
	^ self new initializeWithPackages: aCollectionOfPackages
]

{ #category : #'private - enumeration' }
GtCoderNavigationPackagesTreeElement >> childrenForPackageOrTag: eachPackageOrTag [
	| theTags anExtension |
	(eachPackageOrTag isKindOf: RPackage) ifFalse: [ ^ #() ].
	theTags := eachPackageOrTag classTags asArray sorted: [ :tagA :tagB | tagA name < tagB name ].
	anExtension := GtCoderPackageExtentionTag forPackage: eachPackageOrTag.
	anExtension hasExtendedClasses ifTrue: [ 
		theTags := theTags copyWith: anExtension ].
	"Do not return an only tag of the same name as the package"
	theTags size = 1 ifTrue: [ ^ #() ].
	^ theTags
]

{ #category : #initialization }
GtCoderNavigationPackagesTreeElement >> initialize [
	super initialize.
	
	self stencil: GtCoderExpandablePackagesTreeItemStencilBuilder new.
]

{ #category : #initialization }
GtCoderNavigationPackagesTreeElement >> initializeWithPackages: aCollectionOfPackages [
	| theSortedPackages |

	theSortedPackages := aCollectionOfPackages asArray
		sorted: [ :packageA :packageB | packageA name asLowercase < packageB name asLowercase ].

	self
		items: theSortedPackages
		children: [ :eachPackageOrTag |
			self childrenForPackageOrTag: eachPackageOrTag ]
]

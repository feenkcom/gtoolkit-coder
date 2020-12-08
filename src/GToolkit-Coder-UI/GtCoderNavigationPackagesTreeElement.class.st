"
I show a simple list of packages sorting alphabetically
"
Class {
	#name : #GtCoderNavigationPackagesTreeElement,
	#superclass : #BrSimpleTree,
	#category : #'GToolkit-Coder-UI-Navigation'
}

{ #category : #'instance creation' }
GtCoderNavigationPackagesTreeElement class >> fromPackages: aCollectionOfPackages [
	^ self new initializeWithPackages: aCollectionOfPackages
]

{ #category : #'private - enumeration' }
GtCoderNavigationPackagesTreeElement >> childrenForPackageOrTag: aPackageOrTag [
	| theTags anExtension |
	(aPackageOrTag isKindOf: RPackage) ifFalse: [ ^ #() ].
	theTags := aPackageOrTag classTags asOrderedCollection.
	theTags withIndexDo: [ :eachTag :eachIndex | eachTag name = aPackageOrTag name ifTrue: [ 
		theTags at: eachIndex put: (GtCoderPackageUncategorizedTag forPackageTag: eachTag) ] ].
	theTags sort: [ :tagA :tagB | self isTag: tagA lessThan: tagB ].

	anExtension := GtCoderPackageExtentionTag forPackage: aPackageOrTag.
	anExtension hasExtendedClasses ifTrue: [ 
		theTags addLast: anExtension ].
	"Do not return an only tag of the same name as the package"
	(theTags size = 1 and: [ 
		theTags anyOne class = GtCoderPackageUncategorizedTag ]) ifTrue: [ ^ #() ].
	
	^ theTags
]

{ #category : #initialization }
GtCoderNavigationPackagesTreeElement >> initialize [
	super initialize.

	self rowStencil: BrGlamorousSimpleTreeSelectableRowElementStencilBuilder new.

	self nodeStencil: [
			BrLabel new
				beSmallSize;
				look: BrGlamorousListLabelLook ];
		nodeDataBinder: [ :aPackageElement :aPackage |
			aPackageElement
				text: (aPackage
					ifNil: [ '' ]
					ifNotNil: [ aPackage name ]) ]
]

{ #category : #'api - initialization' }
GtCoderNavigationPackagesTreeElement >> initializeWithPackages: aCollectionOfPackages [
	| theSortedPackages |
	theSortedPackages := aCollectionOfPackages asArray
		sorted:
			[ :packageA :packageB | packageA name asLowercase < packageB name asLowercase ].
	self
		items: theSortedPackages
		lazy:
			[ :eachPackageOrTag | self childrenForPackageOrTag: eachPackageOrTag ]
]

{ #category : #'private - testing' }
GtCoderNavigationPackagesTreeElement >> isTag: tagA lessThan: tagB [
	tagA class = GtCoderPackageUncategorizedTag ifTrue: [ ^ true ].
	tagB class = GtCoderPackageUncategorizedTag ifTrue: [ ^ false ].
	^ tagA name < tagB name
	
]

{ #category : #'api - selection' }
GtCoderNavigationPackagesTreeElement >> selectedIndice [
	"Return selected indice or zero"
	
	self selectedIndices
		ifNotEmpty: [ :theIndices |
			(theIndices first between: 1 and: self viewModel itemCount)
				ifTrue: [ ^ theIndices first ] ].
	^ 0
]

{ #category : #'api - selection' }
GtCoderNavigationPackagesTreeElement >> selectedPackage [
	<return: #RPackage or: nil>
	^ self selectedPackageNodeDo: #value
]

{ #category : #'api - selection' }
GtCoderNavigationPackagesTreeElement >> selectedPackageNodeDo: aBlock [
	self selectedNodeDo: [ :aNode | aNode depth = 0
		ifTrue: [ ^ aBlock cull: aNode ] ].
	^ nil
]

{ #category : #'api - selection' }
GtCoderNavigationPackagesTreeElement >> selectedPackageTag [
	<return: #RPackageTag or: nil>
	^ self selectedPackageTagNodeDo: #value
]

{ #category : #'api - selection' }
GtCoderNavigationPackagesTreeElement >> selectedPackageTagNodeDo: aBlock [
	self selectedNodeDo: [ :aNode | aNode depth = 1
		ifTrue: [ ^ aBlock cull: aNode ] ].
	^ nil
]

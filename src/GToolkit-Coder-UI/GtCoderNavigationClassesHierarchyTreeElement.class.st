"
I show a list of classes grouping them based on the inheritance hierarchy and sorting alphabetically


"
Class {
	#name : #GtCoderNavigationClassesHierarchyTreeElement,
	#superclass : #BrSimpleTree,
	#instVars : [
		'classesTree'
	],
	#category : #'GToolkit-Coder-UI-Navigation'
}

{ #category : #'instance creation' }
GtCoderNavigationClassesHierarchyTreeElement class >> fromClasses: aCollectionOfClasses [
	^ self new initializeWithClasses: aCollectionOfClasses
]

{ #category : #'private - ui' }
GtCoderNavigationClassesHierarchyTreeElement >> expandClass: aClass [
	| aClassDepth |
	aClassDepth := 0.
	aClass
		allSuperclassesDo: [ :eachClass | aClassDepth := aClassDepth + 1 ].
	self expandUpTo: aClassDepth + 1
]

{ #category : #initialization }
GtCoderNavigationClassesHierarchyTreeElement >> initialize [
	super initialize.
	
	self rowStencil: BrGlamorousSimpleTreeSelectableRowElementStencilBuilder new.
	
	self
		nodeStencil: [ BrLabel new
				beSmallSize;
				aptitude: BrGlamorousLabelAptitude ];
		nodeDataBinder: [ :aClassElement :aClassHierarchyTree | 
			aClassElement
				text:
					(aClassHierarchyTree
						ifNil: [ '' asRopedText ]
						ifNotNil: [ | aClass aText |
							aClass := aClassHierarchyTree rootClass.
							aText := aClass gtDisplayText asRopedText.
							(aClass isAbstract or: [ aClass hasAbstractMethods ])
								ifTrue: [ aText italic ].
							aClass isDeprecated
								ifTrue: [ aText append: ' (deprecated)' asRopedText italic ].
							aText ]) ]
]

{ #category : #'api - initialization' }
GtCoderNavigationClassesHierarchyTreeElement >> initializeWithClasses: aCollectionOfClasses [
	classesTree := (GtCoderClassesHierarchyTree
		fromClasses: aCollectionOfClasses) sortByClassName.
	self
		items: classesTree subclassTrees
		lazy: [ :eachTree | eachTree subclassTrees ].
	self expandAll
]

{ #category : #'api - initialization' }
GtCoderNavigationClassesHierarchyTreeElement >> initializeWithHierachyForClass: aClass [
	classesTree := (GtCoderGrowingClassesHierarchyTree
		hierarchyForClass: aClass) sortByClassName.
	self
		items: classesTree subclassTrees
		lazy: [ :eachTree | eachTree subclassTrees ].
	self expandAll
]

{ #category : #'api - selection' }
GtCoderNavigationClassesHierarchyTreeElement >> selectedClass [
	<return: #Class or: nil>
	self selectedNodeDo: [ :aNode | ^ aNode value rootClass ].
	^ nil
]

{ #category : #'api - selection' }
GtCoderNavigationClassesHierarchyTreeElement >> selectedIndice [
	"Return selected indice or zero"
	
	self selectedIndices
		ifNotEmpty: [ :theIndices |
			(theIndices first between: 1 and: self viewModel itemCount)
				ifTrue: [ ^ theIndices first ] ].
	^ 0
]

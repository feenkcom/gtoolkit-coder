Class {
	#name : #GtCoderNavigationPackagesAndHierarchyElement,
	#superclass : #BlElement,
	#instVars : [
		'navigationModel',
		'tabGroup',
		'packagesTab',
		'hierarchyTab'
	],
	#category : #'GToolkit-Coder-Navigation - UI'
}

{ #category : #'building ui' }
GtCoderNavigationPackagesAndHierarchyElement >> buildHierarchyTree [
	| hierarchyTree |
	hierarchyTree := BrSimpleTree new.
	hierarchyTree
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	hierarchyTree userData at: #blocContainer put: #hierarchyTree.
	self updateHierarchyTree: hierarchyTree.
	hierarchyTree
		stencil:
			(BrSimpleTreeRowStencilBuilder new
				text: [ :anObject | anObject name asRopedText glamorousRegularFontAndSize ]).
	hierarchyTree
		when: BrSelectionChanged
		do: [ :anEvent | 
			hierarchyTree
				selectedNodeDo: [ :aNode | navigationModel selectInCoderClass: aNode value ] ].
	^ hierarchyTree
]

{ #category : #'building ui' }
GtCoderNavigationPackagesAndHierarchyElement >> buildPackagesTree [
	| packagesTree |
	packagesTree := BrSimpleTree new.
	packagesTree
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	packagesTree userData at: #blocContainer put: #packagesTree.
	packagesTree
		items: (RPackageOrganizer default packages sort: [ :a :b | a name < b name ])
		children: [ :anObject | 
			(anObject isKindOf: RPackage)
				ifTrue: [ anObject definedClasses asOrderedCollection
						sort: [ :a :b | a name < b name ] ]
				ifFalse: [ #() ] ].
	packagesTree
		stencil:
			(BrSimpleTreeRowStencilBuilder new
				text: [ :anObject | anObject name asRopedText glamorousRegularFontAndSize ]).
	packagesTree
		when: BrSelectionChanged
		do: [ :anEvent | 
			anEvent
				selectedDo: [ :anInterval | 
					packagesTree
						selectedNodeDo: [ :aNode | 
							aNode value isClass
								ifTrue: [ navigationModel selectInCoderClass: aNode value ].
							(aNode value isKindOf: RPackage)
								ifTrue: [ navigationModel selectInCoderPackage: aNode value ] ] ] ].
	^ packagesTree
]

{ #category : #'building ui' }
GtCoderNavigationPackagesAndHierarchyElement >> buildTabs [
	tabGroup := BrTabGroup new.
	tabGroup look: BrGlamorousTabGroupLook new.
	tabGroup
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	tabGroup
		addTab:
			(packagesTab := BrTab new
				look: BrGlamorousTabLook new;
				label: 'Packages';
				stencil: [ self buildPackagesTree ]).
	tabGroup
		addTab:
			(hierarchyTab := BrTab new
				look: BrGlamorousTabLook new;
				label: 'Hierarchy';
				stencil: [ self buildHierarchyTree ]).
	tabGroup viewModel
		when: BrTabSelectedEvent
		do: [ self
				enqueueTask: (BlTaskAction new action: [ self updateSelection ]) ].
	^ tabGroup
]

{ #category : #accessing }
GtCoderNavigationPackagesAndHierarchyElement >> hierarchyTree [
	hierarchyTab isNil
		ifTrue: [ ^ nil ].
	hierarchyTab viewModel isSelected
		ifFalse: [ ^ nil ].
	^ tabGroup content
		childNamed: #hierarchyTree
		ifFound: [ :tree | tree ]
		ifNone: [  ]
]

{ #category : #'initialize-release' }
GtCoderNavigationPackagesAndHierarchyElement >> navigationModel: aNavigationModel [
	navigationModel ifNotNil: [ navigationModel unsubscribe: self ].
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	navigationModel := aNavigationModel.
	navigationModel
		when: GtClassCoderNavigationSelectionChanged
		send: #updateSelection
		to: self.
	self
		removeChildren;
		addChild: self buildTabs.
	navigationModel theClass
		ifNotNil: [ :aClass | self selectClass: aClass ]
]

{ #category : #accessing }
GtCoderNavigationPackagesAndHierarchyElement >> packagesTree [
	packagesTab isNil
		ifTrue: [ ^ nil ].
	packagesTab viewModel isSelected
		ifFalse: [ ^ nil ].
	^ tabGroup content
		childNamed: #packagesTree
		ifFound: [ :tree | tree ]
		ifNone: [  ]
]

{ #category : #accessing }
GtCoderNavigationPackagesAndHierarchyElement >> selectClass: aClass [
	self selectPackage: aClass package
]

{ #category : #accessing }
GtCoderNavigationPackagesAndHierarchyElement >> selectPackage: aPackage [
	self packagesTree
		ifNotNil: [ :tree | 
			tree viewModel collapseAll.
			tree viewModel root withAllChildrenNodesBreadthFirst
				detect: [ :each | each value = aPackage ]
				ifFound: [ :e | e withAllParentNodesDo: #expand ] ]
]

{ #category : #'updating ui' }
GtCoderNavigationPackagesAndHierarchyElement >> selectTab: aSymbol [
	| tab |
	aSymbol = #hierarchy
		ifTrue: [ tab := hierarchyTab ].
	aSymbol = #packages
		ifTrue: [ tab := packagesTab ].
	tab notNil
		ifTrue: [ self enqueueTask: (BlTaskAction new action: [ tab select ]) ]
]

{ #category : #callbacks }
GtCoderNavigationPackagesAndHierarchyElement >> updateHierarchyTree: hierarchyTree [
	| items class superclasses |
	class := navigationModel theClass.
	class isNil
		ifTrue: [ items := Class rootsOfTheWorld reject: [ :each | each isTrait ].
			superclasses := #() ]
		ifFalse: [ superclasses := class withAllSuperclasses.
			items := {superclasses last} ].
	hierarchyTree
		items: items
		children: [ :anObject | 
			| index |
			index := superclasses indexOf: anObject.
			index > 1
				ifTrue: [ {(superclasses at: index - 1)} ]
				ifFalse:
					[ anObject subclasses asSortedCollection: [ :a :b | a name < b name ] ] ].
	1 to: superclasses size do: [ :i | (hierarchyTree viewModel itemAt: i) expand ].
	superclasses size > 0
		ifTrue: [ hierarchyTree selectOne: superclasses size ]
]

{ #category : #callbacks }
GtCoderNavigationPackagesAndHierarchyElement >> updatePackagesTree: tree [
	tree
		selectedNodeDo: [ :selectionNode | 
			selectionNode value = navigationModel selectedObject
				ifTrue: [ ^ self ] ].
	tree viewModel root
		allChildrenNodesBreadthFirstDo: [ :treeNode | 
			| selectedNode |
			treeNode ensureChildNodesComputed.
			navigationModel selectedObject = treeNode value
				ifTrue: [ selectedNode := treeNode.
					treeNode withAllParentNodesDo: [ :node | node expand ].
					tree selectOne: treeNode globalIndexInTree.
					(tree childNamed: #tree)
						scrollToPosition: treeNode globalIndexInTree ] ]
]

{ #category : #callbacks }
GtCoderNavigationPackagesAndHierarchyElement >> updateSelection [
	self packagesTree ifNotNil: [ :tree | self updatePackagesTree: tree ].
	self hierarchyTree
		ifNotNil: [ :tree | self updateHierarchyTree: tree ]
]
